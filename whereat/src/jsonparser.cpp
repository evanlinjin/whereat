#include "jsonparser.h"

JsonParser::JsonParser(QObject *parent) : QObject(parent) {

}

// PRIVATE DEFINITIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

QJsonArray JsonParser::takeResponseArray(QNetworkReply* reply) {
    QJsonObject object = QJsonDocument::fromJson(reply->readAll()).object();
    reply->deleteLater();
    return object["response"].toArray();
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
    QString db_name("api");
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
    DbAbstract db(db_name);
    db.initTable(name, keys, keySqlTypes, primaryId);

    // Fill database table >>>
    QString prep_str;
    for (int i = 0; i < response.size(); i++) {
        element = response.at(i).toObject(); // Grab element.
        db.updateElement(name, element, keys);
        qDebug() << this << "parseAll_ONEProgress" << name << "[" << i+1 << "/" << response.size() << "]";
        emit parseAll_ONEProgress("Processing " + name + QString("..."),
                                  i+1, response.size());
    }

    emit parseAll_ONEComplete(name);
    return;
}

int JsonParser::pareAll_getPrimaryId(QString n, QStringList keys) {
    if (n == "versions") return keys.indexOf("version");
    if (n == "agency") return keys.indexOf("agency_id");
    if (n == "routes") return keys.indexOf("route_id");
    if (n == "calendar") return keys.indexOf("service_id");
    if (n == "stops") return keys.indexOf("stop_id");
    if (n == "trips") return keys.indexOf("trip_id");
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
