#ifndef SEARCHSTOPSMODEL_H
#define SEARCHSTOPSMODEL_H

#include "abstractmodel.h"
#include "src/db/dbmanager.h"
#include "src/downloader.h"

class SearchStopsModel : public AbstractModel {
    Q_OBJECT
public:
    explicit SearchStopsModel(Downloader &d, DbManager &dbm, QObject *parent = 0);
    ~SearchStopsModel();

private:
    Downloader &downloader;
    DbManager &dbManager;

public slots:
    void reload(QString query);

private slots:
    void reload_REPLY(int status, QNetworkReply* reply);
};

#endif // SEARCHSTOPSMODEL_H
