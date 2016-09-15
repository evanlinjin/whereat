#include "dbsavedstops.h"

DbSavedStops::DbSavedStops(QObject *parent) : DbAbstract("saved_stops", parent) {
    keys     << "id"   << "fav"     << "fav_index" << "visits" << "color";
    keyTypes << "TEXT" << "BOOLEAN" << "INT"       << "INT"    << "TEXT";
    DbAbstract::initTable(keys, keyTypes, 0);
}

DbSavedStops::~DbSavedStops() {

}

void DbSavedStops::connectIfNeeded() {
    if (DbAbstract::connectIfNeeded()) {
        DbAbstract::initTable(keys, keyTypes, 0);
    }
}

void DbSavedStops::updateFavourite(QString id, bool fav) {
    connectIfNeeded();
    QSqlQuery q(db);
    int insert_index = 0;

    if (fav == true) { // SET FAVOURITE :

        // Get max "indexFavourite" value.
        q.exec("SELECT MAX(fav_index) FROM " + QString(dbName) + " WHERE fav == 1");
        if (q.first()) {
            insert_index = q.value(0).toInt() + 1;
        }
        qDebug() << this << "updateFavourite insert_index" << insert_index;


        // Add favourite in database.
        q.prepare("INSERT OR IGNORE INTO " + QString(dbName) + "(id, fav, fav_index) VALUES(?,1,?)");
        q.addBindValue(id);
        q.addBindValue(insert_index);
        q.exec();
        qDebug() << this << "updateFavourite" << q.executedQuery();

        q.prepare("UPDATE " + QString(dbName) + " SET fav = 1, fav_index = ? WHERE id == ?");
        q.addBindValue(insert_index);
        q.addBindValue(id);
        q.exec();
        qDebug() << this << "updateFavourite" << q.executedQuery();

    } else { // CLEAR FAVOURITE :

        q.prepare("UPDATE " + QString(dbName) + " SET fav = 0, fav_index = null WHERE id = ?");
        q.addBindValue(id);
        q.exec();
        qDebug() << this << "updateFavourite" << q.executedQuery();

        QStringList id_list = getFavouritesList();

        // Normalize indexFavourite values in database.
        for (int i = 1; i <= id_list.size(); i++) {
            q.prepare("UPDATE " + QString(dbName) + " SET fav_index = ? WHERE id == ?");
            q.addBindValue(i);
            q.addBindValue(id_list.at(i - 1));
            q.exec();
            qDebug() << this << "updateFavourite" << q.executedQuery();
        }
    }

    emit updateFavouriteComplete(id, fav);
}

void DbSavedStops::getOne(QString id) {
    connectIfNeeded();
    QSqlQuery q(db);
    bool fav = false;
    int fav_index = -1;
    int visits = 0;
    QString color = "";

    q.prepare("SELECT * FROM " + QString(dbName) + " WHERE id == ?");
    q.addBindValue(id);
    q.exec();

    if (q.first()) {
        fav       = q.value("fav").toBool();
        fav_index = q.value("fav_index").toInt();
        visits    = q.value("visits").toInt();
        color     = q.value("color").toString();
    }
    emit getOneComplete(id, fav, fav_index, visits, color);
}

QStringList DbSavedStops::getFavouritesList() {
    connectIfNeeded();
    QStringList list;
    QSqlQuery q(db);

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
