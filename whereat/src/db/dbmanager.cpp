#include "dbmanager.h"

DbManager::DbManager(QObject *parent) : QObject(parent)
{

}

DbManager::~DbManager() {

}

// DEFINITIONS : PRIVATE >>>

QSqlDatabase DbManager::openDb(QString dbName) {
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
        if (dbConnections.at(i) == name) {
            db = QSqlDatabase::database(name);
            goto finish_init;
        }
    }
    db = QSqlDatabase::addDatabase("QSQLITE", name);
    db.setDatabaseName(path + name + QString(".db"));

    if (!db.open()) {
        qDebug() << this << "openDB ERROR" << db.lastError().text();
        db.close();
        QSqlDatabase::removeDatabase(name);
    }

finish_init:
    return db;
}

QSqlDatabase DbManager::initTable(
        QString dbName, QString tableName,
        QStringList keys, QStringList keyTypes, int primaryIndex)
{
    QSqlDatabase db = openDB(dbName);
    QString q_str = "CREATE TABLE IF NOT EXISTS " + tableName + "(";
    for (int i = 0; i < keys.size(); i++) {
        if (i == primaryIndex) { q_str += keys.at(i) + " TEXT PRIMARY KEY"; }
        else                   { q_str += keys.at(i) + " " + keyTypes.at(i); }

        // Add comma to entry if not last column.
        if (i != keys.size() - 1) {q_str += ", ";}
    }
    q_str += ")";

    QSqlQuery q(db);
    if (!q.exec(q_str)) {
        qDebug() << this << "initTable ERROR" << db.lastError().text();
    }
    return db;
}

QSqlQuery DbManager::getSavedStopsQuery() {
    QStringList keys, keyTypes;
    keys     << "id"   << "fav"     << "fav_index" << "visits" << "color";
    keyTypes << "TEXT" << "BOOLEAN" << "INT"       << "INT"    << "TEXT";
    QSqlDatabase db = initTable("saved", "stops", keys, keyTypes, 0);
    return QSqlQuery(db);
}

// DEFINITIONS : SAVED STOPS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void DbManager::updateSavedStopFavourite(QString id, bool fav) {
    QSqlQuery q = getSavedStopsQuery();
    int insert_index = 0;

    if (fav == true) { // SET FAVOURITE :

        // Get max "indexFavourite" value.
        q.exec("SELECT MAX(fav_index) FROM stops WHERE fav == 1");
        if (q.first()) {
            insert_index = q.value(0).toInt() + 1;
        }
        qDebug() << this << "updateFavourite insert_index" << insert_index;


        // Add favourite in database.
        q.prepare("INSERT OR IGNORE INTO stops(id, fav, fav_index) VALUES(?,1,?)");
        q.addBindValue(id);
        q.addBindValue(insert_index);
        q.exec();
        qDebug() << this << "updateFavourite" << q.executedQuery();

        q.prepare("UPDATE stops SET fav = 1, fav_index = ? WHERE id == ?");
        q.addBindValue(insert_index);
        q.addBindValue(id);
        q.exec();
        qDebug() << this << "updateFavourite" << q.executedQuery();

    } else { // CLEAR FAVOURITE :

        q.prepare("UPDATE stops SET fav = 0, fav_index = null WHERE id = ?");
        q.addBindValue(id);
        q.exec();
        qDebug() << this << "updateFavourite" << q.executedQuery();

        QStringList id_list = getFavouritesList();

        // Normalize indexFavourite values in database.
        for (int i = 1; i <= id_list.size(); i++) {
            q.prepare("UPDATE stops SET fav_index = ? WHERE id == ?");
            q.addBindValue(i);
            q.addBindValue(id_list.at(i - 1));
            q.exec();
            qDebug() << this << "updateFavourite" << q.executedQuery();
        }
    }

    emit updateFavouriteComplete(id, fav);
}

SavedStopItem DbManager::getOneSavedStop(QString id) {
    QSqlQuery q = getSavedStopsQuery();

    SavedStopItem item;
    item.fav = false;
    item.fav_index = -1;
    item.visits = 0;
    item.color = "";

    q.prepare("SELECT * FROM stops WHERE id == ?");
    q.addBindValue(id);
    q.exec();

    if (q.first()) {
        item.fav       = q.value("fav").toBool();
        item.fav_index = q.value("fav_index").toInt();
        item.visits    = q.value("visits").toInt();
        item.color     = q.value("color").toString();
    }

    emit getOneComplete(item.id, item.fav, item.fav_index, item.visits, item.color);
    return item;
}

// MAKE THIS USE SavedStopItem !!!
QStringList DbManager::getStopFavouritesList() {
    QSqlQuery q = getSavedStopsQuery();

    QStringList list;

    q.prepare("SELECT * FROM " + QString(dbName) + " WHERE fav = 1 ORDER BY fav_index");
    q.exec();

    while (q.next()) {
        bool isFav = q.value("fav").isNull() ? false : q.value("fav").toBool();
        if (isFav) {
            list.append(q.value("id").toString());
        }
    }
    qDebug() << this << "getFavouritesList" << list;
    emit getFavouritesListComplete(list);
    return list;
}












