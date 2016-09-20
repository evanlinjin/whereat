#ifndef NEARBYSTOPSMODEL_H
#define NEARBYSTOPSMODEL_H

#include "abstractmodel.h"
#include "src/db/dbmanager.h"
#include "src/locator.h"
#include "src/downloader.h"
#include "src/settingsmanager.h"

class NearbyStopsModel : public AbstractModel {
    Q_OBJECT
public:
    explicit NearbyStopsModel(Locator &l, Downloader &d, DbManager &dbm, SettingsManager &s, QObject *parent = 0);
    ~NearbyStopsModel();

private:
    Locator &locator;
    Downloader &downloader;
    DbManager &dbManager;
    SettingsManager &settingsManager;

public slots:
    void update();
    void reload();

private slots:
    void reload_COORD(bool status, double lat, double lon);
    void reload_REPLY(int status, QNetworkReply* reply);
};

#endif // NEARBYSTOPSMODEL_H
