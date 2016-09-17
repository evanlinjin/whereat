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
    DbStops* dbStops;

private:
    QEventLoop eventLoop;

    // Used for manual database update.
    int parseCount, dlCount, dlFails, dlMax;
    QList<QNetworkReply*> dlReplyList;

signals:
    // Connect this to QGuiApplication::quit.
    void quit();

    void progress(QString n, int done, int max);
    void progress0(int done, int max);
    void updateDbManualComplete();

    // Let QML PageTimeboard know if to update timeboard header information.
    void updateStopFavouriteComplete(QString id, bool fav);

    void updateStopTimeboardComplete_StopData(QStringList ln, QList<double> coord);
    void updateStopTimeboardComplete_SavedStopData(QString id, bool fav, int fav_index, int visits, QString color);

public slots:
    void updateDbManual();

    void reloadFavouriteStops();

    void updateNearbyStops();
    void reloadNearbyStops();

    void reloadTextSearch(QString query);
    // Hack for bug where text search loading is enabled randomnly.
    // Used in QML when clicking on search tab.
    void reloadTextSearch_forceLoadingOff();

    void updateStopFavourite(QString id, bool fav); /*Individual Stop Items*/

    void updateStopTimeboard(QString id);

private slots:
    // Clearing db for manual database update.
    void clearDlReplyList();

    void updateDbManual_REPLY(QNetworkReply* reply);
    void updateDbManual_REPLY(QNetworkReply::NetworkError error);
    void updateDbManual_JSON(QString name);

    void reloadNearbyStops_COORD(bool status, double lat, double lon);
    void reloadNearbyStops_REPLY(int status, QNetworkReply* reply);
    void reloadNearbyStops_JSON(QList<AbstractItem> list);

    void reloadTextSearch_REPLY(int status, QNetworkReply* reply);
    void reloadTextSearch_JSON(QList<AbstractItem> list);

};

#endif // WHEREAT_H
