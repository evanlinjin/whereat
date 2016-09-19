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
        if (dbConnections.at(i) == dbName) {
            db = QSqlDatabase::database(dbName);
            goto finish_init;
        }
    }
    db = QSqlDatabase::addDatabase("QSQLITE", dbName);
    db.setDatabaseName(path + dbName + QString(".db"));

    if (!db.open()) {
        qDebug() << this << "openDB ERROR" << db.lastError().text();
        db.close();
        QSqlDatabase::removeDatabase(dbName);
    }

finish_init:
    return db;
}

QSqlDatabase DbManager::initTable(
        QString dbName, QString tableName,
        QStringList keys, QStringList keyTypes, int primaryIndex)
{
    QSqlDatabase db = openDb(dbName);
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

// DEFINITIONS : PRIATE OTHERS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

QString DbManager::getIconUrl(QString stop_name) {
    if (stop_name == "") {
        return QString("qrc:/icons/AT.png");
    }
    if (stop_name.contains("Train Station", Qt::CaseSensitive)) {
        return QString("qrc:/icons/train.svg");
    }
    if (stop_name.contains("Ferry Terminal", Qt::CaseSensitive)) {
        return QString("qrc:/icons/ferry.svg");
    }
    return QString("qrc:/icons/bus.svg");
}


// DEFINITIONS : GET QUERYS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

QSqlQuery DbManager::getSavedStopsQuery() {
    QStringList keys, keyTypes;
    keys     << "id"   << "fav"     << "fav_index" << "visits" << "color";
    keyTypes << "TEXT" << "BOOLEAN" << "INT"       << "INT"    << "TEXT";
    QSqlDatabase db = initTable("saved", "stops", keys, keyTypes, 0);
    return QSqlQuery(db);
}

QSqlQuery DbManager::getApiQuery() {
    QSqlDatabase db = openDb("api");
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

        QList<SavedStopItem> id_list = getStopFavouritesList();

        // Normalize indexFavourite values in database.
        for (int i = 1; i <= id_list.size(); i++) {
            q.prepare("UPDATE stops SET fav_index = ? WHERE id == ?");
            q.addBindValue(i);
            q.addBindValue(id_list.at(i - 1).id);
            q.exec();
            qDebug() << this << "updateFavourite" << q.executedQuery();
        }
    }

    emit updateSavedStopFavouriteComplete(id, fav);
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

    emit getOneSavedStopComplete(item.id, item.fav, item.fav_index, item.visits, item.color);
    return item;
}

void DbManager::getOneApiStop(QString id) {
    QSqlQuery q = getApiQuery();

    q.prepare("SELECT * FROM stops WHERE stop_id = ?");
    q.addBindValue(id);
    q.exec();

    QStringList ln;
    QList<double> coord;

    if (q.first()) {
        ln.append(q.value("stop_code").toString());
        ln.append(q.value("stop_name").toString());
        ln.append(getIconUrl(ln[1]));
        coord.append(q.value("stop_lat").toDouble());
        coord.append(q.value("stop_lon").toDouble());
    }

    emit getOneApiStopComplete(ln, coord);
}

QList<SavedStopItem> DbManager::getStopFavouritesList() {
    QSqlQuery q = getSavedStopsQuery();

    QStringList list;
    QList<SavedStopItem> fullList;

    q.prepare("SELECT * FROM stops WHERE fav = 1 ORDER BY fav_index");
    q.exec();

    while (q.next()) {
        SavedStopItem temp;
        temp.id = q.value("id").toString();
        temp.fav = q.value("fav").toBool();
        temp.fav_index = q.value("fav_index").toInt();
        temp.visits = q.value("visits").toInt();
        temp.color = q.value("color").toString();
        fullList.append(temp);
        list.append(temp.id);

    }
    qDebug() << this << "getFavouritesList" << list;
    emit getStopFavouritesListComplete(list);
    return fullList;
}

QList<AbstractItem> DbManager::getStopFavouritesListForModel() {
    QList<AbstractItem> list;
    QSqlQuery q = getApiQuery();

    QList<SavedStopItem> favList = this->getStopFavouritesList();

    for (int i = 0; i < favList.size(); i++) {
        AbstractItem temp;

        q.prepare("SELECT * FROM stops WHERE stop_id = ?");
        q.addBindValue(favList.at(i).id);
        q.exec();

        if (q.first()) {
            temp.id = q.value("stop_id").toString();
            temp.ln0 = q.value("stop_code").toString();
            temp.ln1 = q.value("stop_name").toString();
            temp.type = getIconUrl(temp.ln1);
        } else {
            temp.id = favList.at(i).id;
            temp.ln0 = "No entry in database";
            temp.ln1 = "Database update might be needed.";
            temp.type = getIconUrl("");
        }
        temp.color = favList.at(i).color;
        temp.fav = favList.at(i).fav;
        temp.header = false;

        list.append(temp);
    }

    return list;
}
















