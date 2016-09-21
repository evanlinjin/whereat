#include "timeboardmodel.h"

#define TB_LOAD_DELAY 3600

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
    int cpTime = this->getCurrentTimeInSeconds() - TB_LOAD_DELAY; // Current time with 1hr delay.

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
    QString trip_id, due_str; double delay, time, due; int stop_seq;
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

        qDebug() << this << "ANALYSE TRIP >>>";
        qDebug() << this << "[" << trip_id << "] FROM RT : stop_sequence =" << stop_seq << ", delay =" << delay << ", time =" << time;

        // Determine the ln3 value for the trip_id.........................

        //qDebug() << "[ CURRENT TIME ]" << QString::number(QDateTime::currentMSecsSinceEpoch()/1000);
        qDebug() << this << "TIME [CURRENT]" << QDateTime::currentMSecsSinceEpoch()/1000;
        qDebug() << this << "TIME [FROM RT]" << (int)time << "(-)";
        qDebug() << this << "TIME [  DELAY]" << delay;
        due = (delay - (QDateTime::currentMSecsSinceEpoch()/1000 - time) )/60;
        qDebug() << this << "TIME [    DUE]" << due;
        if (due < 0) {
            qDebug() << this << "[" << trip_id << "] NEGATIVE DUE TIME : no changes";
            continue;
        }

        for (int j = tempList.size() - 1; j >= 0; j--) {

            if (tempList.at(j).trip_id == trip_id) {

                qDebug() << this << "[" << tempList[j].trip_id << "] ITEM ("
                         << tempList.at(j).route_short_name
                         << tempList.at(j).trip_headsign
                         << tempList.at(j).time_str
                         << tempList.at(j).due << ")";
                qDebug() << this << "[" << tempList[j].trip_id << "] FROM LIST :"
                         << "stop_sequence =" << tempList[j].stop_sequence
                         << ", direction_id =" << tempList[j].direction_id;

//                bool isDirectionValid = tempList[j].direction_id ?
//                            (tempList[j].stop_sequence >= stop_seq) : // direction_id : 1
//                            (tempList[j].stop_sequence <= stop_seq);  // direction_id : 0
                bool isDirectionValid = tempList[j].stop_sequence >= stop_seq;
                if (isDirectionValid) {
                    qDebug() << this << "[" << tempList[j].trip_id << "]" << "DIRECTION VALID : changing DUE from"
                             << tempList[j].due << "to" << due;
                    tempList[j].due = due;
                } else {
                    qDebug() << this << "[" << tempList[j].trip_id << "]" << "DIRECTION INVALID : no changes";
                }

                break;
            }
        }
    }

    for (int j = tempList.size() - 1; j >= 0; j--) {
        if (tempList[j].due >= 0.0 && tempList[j].due < 1.0) {
            tempList[j].due_str = "*";
        }
        else if (tempList[j].due > 60.0) {
            tempList[j].due_str = "-";
        }
        else {
            tempList[j].due_str = QString::number(tempList[j].due, 'f', 0);
        }
    }
    emit end();
}


void TimeboardModel::reload_END() {
    QList<AbstractItem> list;
    list.reserve(tempList.size());

    for (int i = 0; i < tempList.size(); i++) {
        if (tempList[i].due < 0) {continue;} // Show only times after 'now'.
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













