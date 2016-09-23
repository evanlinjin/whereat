#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDebug>
#include <QStringBuilder>

#include "keys.h"

class Downloader : public QObject
{
    Q_OBJECT

public:
    explicit Downloader(QObject *parent = 0);
    ~Downloader();

private:
    QNetworkAccessManager* nm;

signals:
    // For Updating Database >>>
    void getAllOneComplete(QNetworkReply* reply);
    void getAllOneFailed(QNetworkReply::NetworkError error);

    void getGitDbComplete(int status, QNetworkReply* reply);
    void getGitDbProgress(qint64 done, qint64 total);

    // For Filling ListViews >>>
    void stopsNearbySearchComplete(int status, QNetworkReply* reply);
    void stopsTextSearchComplete(int status, QNetworkReply* reply);
    void timeboardSearchComplete(int status, QNetworkReply* reply);
    void timeboardRtSearchComplete(int status, QNetworkReply* reply);
    void routesNearbySearchComplete(int status, QNetworkReply* reply);

public slots:
    // For Updating Database >>>
    void getAll();
    void resetConnections();

    void getGitDb();

    // For Filling ListViews >>>
    void getStopsNearbySearch(double lat, double lon, double radius);
    void getStopsTextSearch(QString query);
    void getTimeboardSearch(QString stop_id);
    void getTimeboardRtSearch(QStringList trip_ids);
    void getRoutesNearbySearch(double lat, double lon, double radius);

private slots:
    void networkReplyHandler(QNetworkReply* reply);
};

#endif // DOWNLOADER_H
