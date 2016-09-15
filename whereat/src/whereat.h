#ifndef WHEREAT_H
#define WHEREAT_H

#include <QObject>
#include <QDebug>
#include <QEventLoop>

#include "db/all.h"
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
    JsonParser* jsonParser;

    StopModel* favouriteStopsModel;
    StopModel* nearbyStopsModel;
    StopModel* textSearchStopsModel;

    DbSavedStops* dbSavedStops;

private:
    QEventLoop eventLoop;

    int parseCount, dlCount, dlFails, dlMax;
    QList<QNetworkReply*> dlReplyList;

signals:
    void quit(); // Connect this to QGuiApplication::quit.
    void progress(QString n, int done, int max);
    void progress0(int done, int max);
    void updateDbManualComplete();

public slots:
    void updateDbManual();
    void updateDbManual_REPLY(QNetworkReply* reply);
    void updateDbManual_REPLY(QNetworkReply::NetworkError error);
    void updateDbManual_JSON(QString name);

    void updateNearbyStops();
    void reloadNearbyStops();
    void reloadNearbyStops_COORD(bool status, double lat, double lon);
    void reloadNearbyStops_REPLY(int status, QNetworkReply* reply);
    void reloadNearbyStops_JSON(QList<AbstractItem> list);

    void reloadTextSearch(QString query);
    void reloadTextSearch_REPLY(int status, QNetworkReply* reply);
    void reloadTextSearch_JSON(QList<AbstractItem> list);
    // Hack for bug where text search loading is enabled randomnly.
    void reloadTextSearch_forceLoadingOff();

    void updateStopFavourite(QString id, bool fav);

private slots:
    void clearDlReplyList();

};

#endif // WHEREAT_H
