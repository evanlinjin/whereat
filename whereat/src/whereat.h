#ifndef WHEREAT_H
#define WHEREAT_H

#include <QObject>
#include <QDebug>

#include "models/abstractmodel.h"
#include "models/stopmodel.h"
#include "src/locator.h"
#include "src/downloader.h"
#include "src/settingsmanager.h"
#include "src/jsonparser.h"

class WhereAt : public QObject {
    Q_OBJECT

public:
    explicit WhereAt(QObject *parent = 0);
    ~WhereAt();

    Locator* locator;
    Downloader* downloader;
    SettingsManager* settingsManager;

    StopModel* favouriteStopsModel;
    StopModel* nearbyStopsModel;
    StopModel* recentStopsModel;
    StopModel* textSearchStopsModel;

    JsonParser* jsonParser;

private:
    int dlCount, dlFails, dlMax;
    QList<QNetworkReply*> dlReplyList;

signals:

public slots:
    void updateDbManual();
    void updateDbManual_REPLY(QNetworkReply* reply);
    void updateDbManual_REPLY(QNetworkReply::NetworkError error);

    void updateNearbyStops();
    void reloadNearbyStops();
    void reloadNearbyStops_COORD(bool status, double lat, double lon);
    void reloadNearbyStops_REPLY(int status, QNetworkReply* reply);
    void reloadNearbyStops_JSON(QList<AbstractItem> list);

    void reloadTextSearch(QString query);
    void reloadTextSearch_REPLY(int status, QNetworkReply* reply);
    void reloadTextSearch_JSON(QList<AbstractItem> list);

private slots:
    void clearDlReplyList();

};

#endif // WHEREAT_H
