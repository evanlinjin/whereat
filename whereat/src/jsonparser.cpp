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

QString JsonParser::getIconUrl(QString stop_name) {
    if (stop_name.contains("Train Station", Qt::CaseSensitive)) {
        return QString("qrc:/icons/train.svg");
    }
    if (stop_name.contains("Ferry Terminal", Qt::CaseSensitive)) {
        return QString("qrc:/icons/ferry.svg");
    }
    return QString("qrc:/icons/bus.svg");
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
