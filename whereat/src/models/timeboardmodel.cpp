#include "timeboardmodel.h"

TimeboardModel::TimeboardModel(Downloader &d, DbManager &dbm, QObject *parent) :
    AbstractModel(parent), downloader(d), dbManager(dbm)
{
    m_ln.reserve(8);
    for (int i = 0; i < 8; i++) {m_ln.append(QVariant());}

    connect(&dbManager,
            SIGNAL(updateSavedStopFavouriteComplete(QString,bool)),
            this,
            SLOT(updateLn(QString)));

    connect(&dbManager,
            SIGNAL(rtTimeboardTripsListComplete(QStringList)),
            &downloader,
            SLOT(getTimeboardRtSearch(QStringList)));

    connect(this,
            SIGNAL(end()),
            SLOT(reload_END()));
}

int TimeboardModel::getCurrentTimeInSeconds() {
    return QTime(0,0).secsTo(QTime::currentTime());
}

void TimeboardModel::updateLn(QString id) {
    m_ln = dbManager.getTimeboardBasicData(id);
    emit lnChanged();
}

void TimeboardModel::reload(QString id) {
    AbstractModel::startReload();
    this->updateLn(id);
    time.start(); // TIME : download time.

    connect(&downloader,
            SIGNAL(timeboardSearchComplete(int,QNetworkReply*)),
            this,
            SLOT(reload_REPLY(int,QNetworkReply*)));

    downloader.getTimeboardSearch(id);
}

void TimeboardModel::reload_REPLY(int status, QNetworkReply* reply) {
    disconnect(&downloader,
               SIGNAL(timeboardSearchComplete(int,QNetworkReply*)),
               this,
               SLOT(reload_REPLY(int,QNetworkReply*)));

    if (status != 0) {
        AbstractModel::endReload();
        AbstractModel::setEmptyState("network_error");
        reply->deleteLater();
        return;
    }

    qDebug() << this << "DOWNLOAD TIME :" << time.restart() << "ms";

    QJsonArray response = AbstractModel::takeResponseArray(reply);
    reply->deleteLater();
    QtConcurrent::run(this, &TimeboardModel::reload_THREAD, response);
}

void TimeboardModel::reload_THREAD(QJsonArray response) {
    qDebug() << this << "RESPONSE TIME :" << time.restart() << "ms";

    QString version = dbManager.getVersion();
    int cpTime = this->getCurrentTimeInSeconds() - 3600; // Current time with 1hr delay.

    QList<TimeboardItem> list;
    list.reserve(response.size());
    TimeboardItem item;

    for (int i = 0; i < response.size(); i++) {
        QJsonObject obj = response.at(i).toObject();

        // Skip outdated elements.
        item.time = obj["arrival_time_seconds"].toInt();
        if (item.time < cpTime) {continue;}

        // Skip outversioned elements.
        item.trip_id = obj["trip_id"].toString();
        if (!item.trip_id.contains(version)) {continue;}

        // Add to list if all OKAY.
        item.stop_sequence = obj["stop_sequence"].toInt();
        list.prepend(item);
    }
    qDebug() << this << "FILTER TIME :" << time.restart() << "ms";

    connect(&downloader,
            SIGNAL(timeboardRtSearchComplete(int,QNetworkReply*)),
            this,
            SLOT(reload_rtREPLY(int,QNetworkReply*)));
    tempList = dbManager.getTimeboardList(list);
    qDebug() << this << "SORT TIME :" << time.restart() << "ms";

    emit end();
}

void TimeboardModel::reload_rtREPLY(int status, QNetworkReply* reply) {
    disconnect(&downloader,
               SIGNAL(timeboardRtSearchComplete(int,QNetworkReply*)),
               this,
               SLOT(reload_rtREPLY(int,QNetworkReply*)));

    if (status != 0) {
        AbstractModel::endReload();
        AbstractModel::setEmptyState("network_error");
        if (status != -1) {
            reply->deleteLater();
        }
        return;
    }

    QString json_str = (QString) reply->readAll();
    QJsonObject document = QJsonDocument::fromJson(json_str.toUtf8()).object();
    QJsonObject response = document["response"].toObject();

    // Get entity list & loop through enitites.
    QJsonArray entityList = response["entity"].toArray();
    QString trip_id, due_str; int delay, time, due, stop_seq;
    QJsonObject stop_time_update, arrival_departure;

    for (int i = 0; i < entityList.size(); i++) {
        QJsonObject object = entityList.at(i).toObject()["trip_update"].toObject(); /* Entity Object : Trip Update Object */

        // Get the trip ID from entity.
        trip_id = object["trip"].toObject()["trip_id"].toString();

        stop_time_update = object["stop_time_update"].toObject();
        if (!stop_time_update.contains("arrival")) {continue;}
        arrival_departure = stop_time_update["arrival"].toObject();

        // Get stop_seq, delay & time from entity.
        stop_seq = stop_time_update["stop_sequence"].toInt();
        delay = arrival_departure["delay"].toInt();
        time = (int)arrival_departure["time"].toDouble();

        qDebug() << "[" << trip_id << "] stop_seq:" << stop_seq << "delay:" << delay << "time:" << time;

        // Determine the ln3 value for the trip_id.........................

        qDebug() << "[ CURRENT TIME ]" << QString::number(QDateTime::currentMSecsSinceEpoch()/1000);
        due = (QDateTime::currentMSecsSinceEpoch()/1000 - time - delay)/60;

        for (int j = 0; j < tempList.size(); j++) {
            if (tempList.at(j).trip_id == trip_id) {
                tempList[j].due = due;
            }
        }
    }

    for (int j = tempList.size() - 1; j >= 0; j--) {
        TimeboardItem temp = tempList.at(j);
        if (temp.due == 0) {temp.due_str = "*";}
        else if (temp.due < 0) {tempList.removeAt(j);}
        else if (temp.due > 60) {temp.due_str = "-";}
        else {temp.due_str = QString::number(temp.due);}
        tempList.replace(j, temp);
    }
    emit end();
}


void TimeboardModel::reload_END() {
    QList<AbstractItem> list;
    list.reserve(tempList.size());

    for (int i = 0; i < tempList.size(); i++) {
        AbstractItem item;
        item.id = tempList[i].trip_id;
        item.ln0 = tempList[i].route_short_name;
        item.ln1 = tempList[i].trip_headsign;
        item.ln2 = tempList[i].time_str;
        item.ln3 = tempList[i].due_str;
        list.append(item);
    }

    AbstractModel::clear();
    AbstractModel::append(list);
    qDebug() << this << "APPEND TIME :" << time.restart() << "ms";

    AbstractModel::endReload();
}













