#include "jsonparser.h"

JsonParser::JsonParser(QObject *parent) : QObject(parent) {

}

// PRIVATE DEFINITIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

QJsonArray JsonParser::takeResponseArray(QNetworkReply* reply) {
    QJsonObject object = QJsonDocument::fromJson(reply->readAll()).object();
    reply->deleteLater();
    return object["response"].toArray();
}

AbstractItem JsonParser::getEmptyItem() {
    AbstractItem item;
    item.color = "";
    item.fav = false;
    item.header = false;
    item.id = "";
    item.ln0 = "";
    item.ln1 = "";
    item.ln2 = "";
    item.ln3 = "";
    item.type = "";
    return item;
}

QString JsonParser::getIconUrl(QString stop_name) {
    if (stop_name.contains("Train Station", Qt::CaseSensitive)) {
        return QString("qrc:/icons/train.svg");
    }
    if (stop_name.contains("Ferry Terminal", Qt::CaseSensitive)) {
        return QString("qrc:/icons/ferry.svg");
    }
    return QString("qrc:/icons/bus.svg");
}

// PARSE ALL DEFINITIONS (FOR DB MANUAL UPDATE) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void JsonParser::parseAll(QList<QNetworkReply*> replyList) {
    for (int i = 0; i < replyList.size(); i++) {
        QtConcurrent::run(
                    this, &JsonParser::parseAll_ONE,
                    replyList.at(i)->url().path(),
                    this->takeResponseArray(replyList.at(i)));
    }
    emit parseAllComplete_clearReplyList();
}

void JsonParser::parseAll_ONE(QString name, QJsonArray response) {
    name = name.remove(QString("/v1/gtfs/"), Qt::CaseInsensitive);
    QJsonObject element      = response.at(0).toObject();
    QStringList keys         = element.keys();
    QStringList keySqlTypes  = this->pareAll_getSqlTypes(element);
    int         primaryId    = this->pareAll_getPrimaryId(name, keys);

    qDebug() << this << "KEYS OF TABLE [" << name << "] :";
    for (int i = 0; i < keys.size(); i++) {
        qDebug() << "   " << i << ":" << keys.at(i)
                 << (i == primaryId ? "(PRIMARY)" : "");
    }

    // Create, if appropriate, .db file and table.
    DbAbstract db(name);
    db.initTable(keys, keySqlTypes, primaryId);

    // Fill database table >>>
    QString prep_str;
    for (int i = 0; i < response.size(); i++) {
        element = response.at(i).toObject(); // Grab element.
        db.updateElement(element, keys);
        emit parseAll_ONEProgress(name, i+1, response.size());
    }

    emit parseAll_ONEComplete(name);
    return;
}

int JsonParser::pareAll_getPrimaryId(QString n, QStringList keys) {
    if (n == "/v1/gtfs/versions") return keys.indexOf("version");
    if (n == "/v1/gtfs/agency") return keys.indexOf("agency_id");
    if (n == "/v1/gtfs/routes") return keys.indexOf("route_id");
    if (n == "/v1/gtfs/calendar") return keys.indexOf("service_id");
    if (n == "/v1/gtfs/stops") return keys.indexOf("stop_id");
    if (n == "/v1/gtfs/trips") return keys.indexOf("trip_id");
    return -1;
}

QStringList JsonParser::pareAll_getSqlTypes(QJsonObject element) {
    QStringList sql_types;
    QStringList keys = element.keys();
    for (int i = 0; i < element.size(); i++) {
        switch (element[keys.at(i)].type()) {
        case 0: sql_types.append("TEXT"); break;
        case 1: sql_types.append("BOOLEAN"); break;
        case 2: sql_types.append("DOUBLE"); break;
        case 3: sql_types.append("TEXT"); break;
        case 4: sql_types.append("TEXT"); break;
        case 5: sql_types.append("TEXT"); break;
        default: sql_types.append("TEXT");
        }
    }
    return sql_types;
}

// PARSE SINGLE LISTS DEFINITIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void JsonParser::parseNearbyStops(QNetworkReply* reply) {
    QJsonArray response = takeResponseArray(reply);
    qDebug() << this << "parseNearbyStops" << response.size();

    QList<AbstractItem> list; // Emitted with complete signal.
    list.reserve(response.size());

    QJsonObject obj;
    AbstractItem item = getEmptyItem();

    for (int i = 0; i < response.size(); i++) {
        obj = response.at(i).toObject();
        item.id = obj["stop_id"].toString();
        if (item.id.size() >= 5) {continue;} // Get rid of parent stations.
        item.ln0 = obj["stop_code"].toString();
        item.ln1 = obj["stop_name"].toString();
        item.ln2 = QString::number(obj["st_distance_sphere"].toDouble(), 'f', 0)
                + QString("m");
        item.type = this->getIconUrl(item.ln1);
        list.append(item);
    }

    emit parseNearbyStopsComplete(list);
}

void JsonParser::parseTextSearchStops(QNetworkReply* reply) {
    QJsonArray response = takeResponseArray(reply);
    qDebug() << this << "parseTextSearchStops" << response.size();

    QList<AbstractItem> list; // Emitted with complete signal.
    list.reserve(response.size());

    QJsonObject obj;
    AbstractItem item = getEmptyItem();

    for (int i = 0; i < response.size(); i++) {
        obj = response.at(i).toObject();
        item.id = obj["stop_id"].toString();
        if (item.id.size() >= 5) {continue;} // Get rid of parent stations.
        item.ln0 = obj["stop_code"].toString();
        item.ln1 = obj["stop_name"].toString();
        item.type = this->getIconUrl(item.ln1);
        list.append(item);
    }

    emit parseTextSearchStopsComplete(list);
}
