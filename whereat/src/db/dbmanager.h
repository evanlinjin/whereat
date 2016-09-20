#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QObject>
#include <QtSql>
#include <QList>
#include <QStandardPaths>
#include <QJsonObject>
#include <QTime>
#include <QDate>
#include <QDebug>

#include "../models/abstractmodel.h"

struct SavedStopItem {
    QString id;     // Identifier String.
    bool fav;
    int fav_index;
    int visits;
    QString color;
};

struct TimeboardItem {
    QString trip_id;
    QString route_id;
    QString route_short_name; // "007"
    int time;
    int due;
    QString due_str;
    int stop_sequence; // Position of stop on trip.
    int direction_id;
    QString time_str;
    QString trip_headsign; // "Panmure"
};

class DbManager : public QObject
{
    Q_OBJECT
public:
    explicit DbManager(QObject *parent = 0);
    ~DbManager();

private:
    QSqlDatabase openDb(QString dbName);
    QSqlDatabase initTable(
            QString dbName, QString tableName,
            QStringList keys, QStringList keyTypes, int primaryIndex);

    QString getIconUrl(QString stop_name);
    QString getWeekday();
    QString getTimeString(int h);
    int getCurrentTimeInSeconds();

    QSqlQuery getSavedStopsQuery();
    QSqlQuery getApiQuery();

    // FOR : STOPS >>>

signals:
    void updateSavedStopFavouriteComplete(QString id, bool fav);
    void getOneSavedStopComplete(QString id, bool fav, int fav_index, int visits, QString color);
    void getOneApiStopComplete(QStringList ln, QList<double> coord);
    void getStopFavouritesListComplete(QStringList list);
    void rtTimeboardTripsListComplete(QStringList tripIdList);

public slots:
    void updateSavedStopFavourite(QString id, bool fav); // emits.
    SavedStopItem getOneSavedStop(QString id); // emits.
    void getOneApiStop(QString id); // emits.
    QList<SavedStopItem> getStopFavouritesList(); // emits.
    QList<AbstractItem> getStopFavouritesListForModel();

    QVariantList getTimeboardBasicData(QString id);
    QString getVersion();
    QList<TimeboardItem> getTimeboardList(QList<TimeboardItem> raw);
};

#endif // DBMANAGER_H
