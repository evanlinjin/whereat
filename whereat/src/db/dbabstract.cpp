#include "dbabstract.h"

DbAbstract::DbAbstract(QString name, QObject *parent)
    : QObject(parent), dbName(name), isOpen(false) {

    //this->connectIfNeeded();
}

DbAbstract::~DbAbstract() {
    //db.close();
    //QSqlDatabase::removeDatabase(dbName);
}

QSqlDatabase DbAbstract::openDb() {
    QSqlDatabase db;

    // Setup directory.
    QString path =
            QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation)
            + QString("/db/");
    QDir dir(path);
    if (!dir.exists()) {dir.mkdir(path);}

    // Get current db connections.
    QStringList dbConnections = QSqlDatabase::connectionNames();
    for (int i = 0; i < dbConnections.size(); i++) {
        if (dbConnections.at(i) == dbName) {
            db = QSqlDatabase::database(dbName);
            goto finish_init;
        }
    }
    db = QSqlDatabase::addDatabase("QSQLITE", dbName);
finish_init:
    db.setDatabaseName(path + dbName + QString(".db"));

    if (!db.open()) {
        qDebug() << this << "openDB ERROR" << db.lastError().text();
        db.close();
        QSqlDatabase::removeDatabase(dbName);
    }
    return db;
}

QSqlQuery DbAbstract::getApiQuery() {
    QSqlDatabase db = openDb();
    return QSqlQuery(db);
}

void DbAbstract::initTable(QStringList keys, QStringList keyTypes, int primaryIndex) {
    QString q_str = "CREATE TABLE IF NOT EXISTS " + dbName + "(";
    for (int i = 0; i < keys.size(); i++) {
        if (i == primaryIndex) { q_str += keys.at(i) + " TEXT PRIMARY KEY"; }
        else                   { q_str += keys.at(i) + " " + keyTypes.at(i); }

        // Add comma to entry if not last column.
        if (i != keys.size() - 1) {q_str += ", ";}
    }
    q_str += ")";
    qDebug() << this << "initTable" << q_str;

    QSqlQuery q = getApiQuery();
    if (!q.exec(q_str)) {
        qDebug() << this << "initTable ERROR" << db.lastError().text();
    }
    q.finish();
}

void DbAbstract::initTable(QString tableName,
        QStringList keys, QStringList keyTypes, int primaryIndex)
{
    QString q_str = "CREATE TABLE IF NOT EXISTS " + tableName + "(";
    for (int i = 0; i < keys.size(); i++) {
        if (i == primaryIndex) { q_str += keys.at(i) + " TEXT PRIMARY KEY"; }
        else                   { q_str += keys.at(i) + " " + keyTypes.at(i); }

        // Add comma to entry if not last column.
        if (i != keys.size() - 1) {q_str += ", ";}
    }
    q_str += ")";
    qDebug() << this << "initTable" << q_str;

    QSqlQuery q = getApiQuery();
    if (!q.exec(q_str)) {
        qDebug() << this << "initTable ERROR" << db.lastError().text();
    }
    q.finish();
}

void DbAbstract::updateElement(QString tableName, QJsonObject element, QStringList keys) {
    QString q_str = "INSERT OR IGNORE INTO " + tableName + "(";
    for (int j = 0; j < keys.size(); j++) {
        q_str += keys.at(j); if (j != keys.size() - 1) {q_str += ", ";}
    }
    q_str += ") VALUES(";
    for (int j = 0; j < keys.size(); j++) {
        q_str += "?"; if (j != keys.size() - 1) {q_str += ", ";}
    }
    q_str += ")";

    QSqlQuery q = getApiQuery();
    q.prepare(q_str);

    for (int j = 0; j < element.size(); j++) {
        switch (element[keys.at(j)].type()) {
        case 0: q.addBindValue(element[keys.at(j)].toString()); break;
        case 1: q.addBindValue(element[keys.at(j)].toBool()); break;
        case 2: q.addBindValue(element[keys.at(j)].toDouble()); break;
        case 3: q.addBindValue(element[keys.at(j)].toString()); break;
        case 4: q.addBindValue(element[keys.at(j)].toString()); break;
        case 5: q.addBindValue(element[keys.at(j)].toString()); break;
        default: q.addBindValue(element[keys.at(j)].toString());
        }
    }

    q.exec();
    q.finish();
}
