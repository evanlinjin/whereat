#include "dbabstract.h"

DbAbstract::DbAbstract(QString name, QObject *parent)
    : QObject(parent), dbName(name) {

    // Setup directory.
    QString path =
            QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation)
            + QString("/db/");
    QDir dir(path);
    if (!dir.exists()) {dir.mkdir(path);}

    // Setup database connection.
    db = QSqlDatabase::addDatabase("QSQLITE", name);
    db.setDatabaseName(path + dbName + QString(".db"));
    if (!db.open()) {
        qDebug() << this << "constructor ERROR" << db.lastError().text();
    }
}

DbAbstract::~DbAbstract() {
    db.close();
    QSqlDatabase::removeDatabase(dbName);
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

    QSqlQuery q(db);
    if (!q.exec(q_str)) {
        qDebug() << this << "initTable ERROR" << db.lastError().text();
    }
}

void DbAbstract::updateElement(QJsonObject element, QStringList keys) {
    QString q_str = "INSERT OR IGNORE INTO " + dbName + "(";
    for (int j = 0; j < keys.size(); j++) {
        q_str += keys.at(j); if (j != keys.size() - 1) {q_str += ", ";}
    }
    q_str += ") VALUES(";
    for (int j = 0; j < keys.size(); j++) {
        q_str += "?"; if (j != keys.size() - 1) {q_str += ", ";}
    }
    q_str += ")";

    QSqlQuery q(db);
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
}
