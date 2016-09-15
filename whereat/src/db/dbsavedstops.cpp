#include "dbsavedstops.h"

DbSavedStops::DbSavedStops(QObject *parent) : DbAbstract("saved_stops", parent) {
    QStringList keys, keyTypes;
    keys     << "id"   << "fav"     << "fav_index" << "visits" << "color";
    keyTypes << "TEXT" << "BOOLEAN" << "INT"       << "INT"    << "TEXT";
    DbAbstract::initTable(keys, keyTypes, 0);
}

DbSavedStops::~DbSavedStops() {

}

void DbSavedStops::updateFavourite(QString id, bool fav) {
    QSqlQuery q(db);

    if (fav == true) { // SET FAVOURITE :

        // Get max "indexFavourite" value.
        q.prepare("SELECT MAX(fav_index) FROM ? WHERE fav == 1");
        q.addBindValue(dbName);
        q.first();
        int insert_index = q.value(0).toInt() + 1;

        // Add favourite in database.
        q.prepare("INSERT OR IGNORE INTO ?(id, fav, fav_index) VALUES(?,1,?)");
        q.addBindValue(dbName);
        q.addBindValue(id);
        q.addBindValue(insert_index);
        q.exec();

        q.prepare("UPDATE ? SET fav = 1, fav_index = ? WHERE id == ?");
        q.addBindValue(dbName);
        q.addBindValue(insert_index);
        q.addBindValue(id);
        q.exec();

    } else { // CLEAR FAVOURITE :

        q.prepare("UPDATE ? SET fav = 0, fav_index = null WHERE id = ?");
        q.addBindValue(dbName);
        q.addBindValue(id);
        q.exec();

        // Get ordered id list.
        q.prepare("SELECT id FROM ? WHERE fav >= 0 ORDER BY fav_index");
        q.addBindValue(dbName);
        q.exec();

        QStringList id_list;

        int i = 0;
        while (q.next()) {
            id_list.append(q.value(0).toString());
            i++;
        }

        q.last(); const int j = q.at() + 1;
        // Normalize indexFavourite values in database.
        for (int i = 1; i <= j; i++) {
            q.next();
            q.prepare("UPDATE ? SET fav_index = ? WHERE id == ?");
            q.addBindValue(dbName);
            q.addBindValue(i);
            q.addBindValue(id_list.at(i - 1));
            q.exec();
        }
    }

    emit updateFavouriteComplete(id, fav);
}

void DbSavedStops::getOne(QString id) {
    QSqlQuery q(db);
    bool fav = false;
    int fav_index = -1;
    int visits = 0;
    QString color = "";

    q.prepare("SELECT * FROM ? WHERE id == ?");
    q.addBindValue(dbName);
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
    QStringList list;
    QSqlQuery q(db);

    q.prepare("SELECT * FROM ? WHERE fav = 1 ORDER BY fav_index");
    q.addBindValue(dbName);
    q.exec();

    while (q.next()) {
        bool isFav = q.value("fav").isNull() ? false : q.value("fav").toBool();
        if (isFav) {
            list.append(q.value("id").toString());
        }
    }
    emit getFavouritesListComplete(list);
    return list;
}




















