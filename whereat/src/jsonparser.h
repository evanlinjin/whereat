#ifndef JSONPARSER_H
#define JSONPARSER_H

#include <QObject>
#include <QList>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDate>
#include <QTime>
#include <QtConcurrent>
#include <QNetworkReply>

#include "models/abstractmodel.h"
#include "db/dbabstract.h"

class JsonParser : public QObject {
    Q_OBJECT

public:
    explicit JsonParser(QObject *parent = 0);

private:
    // Takes response array from reply (deleting reply).
    QJsonArray takeResponseArray(QNetworkReply* reply);
    // Returns an empty and clear AbstractItem.
    AbstractItem getEmptyItem();
    // Gets icon URL from stop_name.
    QString getIconUrl(QString stop_name);

    // Used by parseAll for Concurrent Updating.
    void parseAll_ONE(QString name, QJsonArray response);
    int pareAll_getPrimaryId(QString n, QStringList keys);
    QStringList pareAll_getSqlTypes(QJsonObject element);

signals:
    void parseAllComplete_clearReplyList();
    void parseAll_ONEProgress(QString name, int done, int max);
    void parseAll_ONEComplete(QString name);

    void parseNearbyStopsComplete(QList<AbstractItem> list);
    void parseTextSearchStopsComplete(QList<AbstractItem> list);
    void parseStopTimeboardComplete(QList<AbstractItem> list);

public slots:
    void parseAll(QList<QNetworkReply*> replyList);

    void parseNearbyStops(QNetworkReply* reply);
    void parseTextSearchStops(QNetworkReply* reply);
    void parseStopTimeboard(QNetworkReply* reply);
};

#endif // JSONPARSER_H
