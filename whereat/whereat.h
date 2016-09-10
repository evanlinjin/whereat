#ifndef WHEREAT_H
#define WHEREAT_H

#include <QObject>
#include <QDebug>

#include "models/abstractmodel.h"
#include "models/stopmodel.h"
#include "misc/locator.h"
#include "misc/downloader.h"
#include "misc/settingsmanager.h"

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

private:
    QString m_atApiKey;

signals:
    void atApiKeyChanged();

public slots:
    void reloadNearbyStopsModel();
    void reloadNearbyStopsModel_COORD(bool status, double lat, double lon);
    void reloadNearbyStopsModel_REPLY(int status, QNetworkReply* reply);
};

#endif // WHEREAT_H
