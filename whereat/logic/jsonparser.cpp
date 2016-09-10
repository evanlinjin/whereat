#include "jsonparser.h"

JsonParser::JsonParser(QObject *parent) : QObject(parent) {

}

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
        list.append(item);
    }

    emit parseTextSearchStopsComplete(list);
}
