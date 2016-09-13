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
