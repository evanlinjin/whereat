#ifndef JSONPARSER_H
#define JSONPARSER_H

#include <QObject>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDate>
#include <QTime>
#include <QtConcurrent>
#include <QNetworkReply>

#include "models/abstractmodel.h"

class JsonParser : public QObject {
    Q_OBJECT

public:
    explicit JsonParser(QObject *parent = 0);

private:
    // Takes response array from reply (deleting reply).
    QJsonArray takeResponseArray(QNetworkReply* reply);

signals:
    void parseNearbyStopsComplete(QList<AbstractItem> list);

public slots:
    void parseNearbyStops(QNetworkReply* reply);
};

#endif // JSONPARSER_H
