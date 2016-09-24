#include "timeboardmodel.h"

#define TB_LOAD_DELAY 2000

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

double TimeboardModel::getAdditionalDelayFromTimeSequence(int ts) {
    if (ts >= 3 && ts <= 7) {return 300.0;}
    else if (ts == 8 || ts == 9) {return 60.0;}
    return 0.0;
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

    const double timeNowSecs = ((double)getCurrentTimeInSeconds());

    QString json_str = (QString) reply->readAll();
    QJsonObject document = QJsonDocument::fromJson(json_str.toUtf8()).object();
    QJsonObject response = document["response"].toObject();

    // Get entity list & loop through enitites.
    QJsonArray entityList = response["entity"].toArray();
    QString trip_id; double delay;
    QJsonObject stop_time_update, arrival_departure;
    double stop_sequence_delay;

    for (int i = 0; i < entityList.size(); i++) {
        QJsonObject object = entityList.at(i).toObject()["trip_update"].toObject(); /* Entity Object : Trip Update Object */

        // Get the trip ID from entity.
        trip_id = object["trip"].toObject()["trip_id"].toString();

        stop_time_update = object["stop_time_update"].toObject();
        if (stop_time_update.contains("departure")) {
            arrival_departure = stop_time_update["departure"].toObject();
        } else {
            arrival_departure = stop_time_update["arrival"].toObject();
        }

        // delay logic >>
        stop_sequence_delay = getAdditionalDelayFromTimeSequence(stop_time_update["stop_sequence"].toInt());
        delay = arrival_departure["delay"].toDouble();
        if (delay > stop_sequence_delay && stop_sequence_delay != 0) {
            delay = stop_sequence_delay;
        }
//        delay = delay;

        qDebug() << this << "ANALYSE TRIP >>>";
        qDebug() << this << "[" << trip_id << "] FROM RT : delay=" << arrival_departure["delay"].toDouble()
                 << ", stop_sequence=" << stop_time_update["stop_sequence"].toInt()
                 << ", stop_sequence_delay=" << stop_sequence_delay;

        // Determine the ln3 value for the trip_id.........................

        for (int j = tempList.size() - 1; j >= 0; j--) {
            if (tempList.at(j).trip_id == trip_id) {
                qDebug() << this << "[" << trip_id << "] OLD due :" << tempList[j].due;
                //tempList[j].due += delay; // :::
                qDebug() << "tempList[j].due = (tempList[j].time - timeNowSecs + delay)/60.0;";
                qDebug() << "tempList[j].time" << tempList[j].time
                         << "timeNowSecs" << timeNowSecs
                         << "delay" << delay;
                tempList[j].due = (tempList[j].time - timeNowSecs + delay)/60.0;

                if (tempList[j].due >= 0.0 && tempList[j].due <= 1.0) {
                    tempList[j].due_str = "*";
                } else {
                    tempList[j].due_str = QString::number(tempList[j].due, 'f', 0);
                }
                qDebug() << this << "[" << trip_id << "] CHANGED :"
                         << tempList[j].route_short_name
                         << tempList[j].trip_headsign
                         << tempList[j].time_str
                         << tempList[j].due_str;
            }
        }
    }

    //    for (int j = tempList.size() - 1; j >= 0; j--) {
    //    if (tempList[j].due >= 0.0 && tempList[j].due <= 1.0) {
    //        tempList[j].due_str = "*";
    //}
    //        else if (tempList[j].due_str.isEmpty() || tempList[j].due_str.isNull()) {
    //            tempList[j].due_str = "-";
    //        }
    //    }
    emit end();
}


void TimeboardModel::reload_END() {
    QList<AbstractItem> list;
    list.reserve(tempList.size());
    QString thisStopId = m_ln.at(2).toString();

    for (int i = 0; i < tempList.size(); i++) {
        if (tempList[i].due < 0) {continue;} // Show only times after 'now'.
        AbstractItem item;

        item.id = tempList[i].trip_id;
        item.ln0 = tempList[i].route_short_name;
        if (tempList[i].trip_headsign.contains(thisStopId)) {
            continue;
        }
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













