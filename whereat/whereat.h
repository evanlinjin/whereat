#ifndef WHEREAT_H
#define WHEREAT_H

#include <QObject>
#include <QDebug>

#include "models/abstractmodel.h"
#include "models/stopmodel.h"
#include "misc/locator.h"
#include "misc/downloader.h"
#include "misc/settingsmanager.h"
#include "logic/jsonparser.h"

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
    QString m_atApiKey;

signals:
    void atApiKeyChanged();

public slots:
    void updateNearbyStops();
    void reloadNearbyStops();
    void reloadNearbyStops_COORD(bool status, double lat, double lon);
    void reloadNearbyStops_REPLY(int status, QNetworkReply* reply);
    void reloadNearbyStops_JSON(QList<AbstractItem> list);

    void reloadTextSearch(QString query);
    void reloadTextSearch_REPLY(int status, QNetworkReply* reply);
    void reloadTextSearch_JSON(QList<AbstractItem> list);
};

#endif // WHEREAT_H
