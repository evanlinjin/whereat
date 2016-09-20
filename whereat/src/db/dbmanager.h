#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QObject>
#include <QtSql>
#include <QList>
#include <QStandardPaths>
#include <QJsonObject>
#include <QDebug>

#include "../models/abstractmodel.h"

struct SavedStopItem {
    QString id;     // Identifier String.
    bool fav;
    int fav_index;
    int visits;
    QString color;
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

    QSqlQuery getSavedStopsQuery();
    QSqlQuery getApiQuery();

    // FOR : STOPS >>>

signals:
    void updateSavedStopFavouriteComplete(QString id, bool fav);
    void getOneSavedStopComplete(QString id, bool fav, int fav_index, int visits, QString color);
    void getOneApiStopComplete(QStringList ln, QList<double> coord);
    void getStopFavouritesListComplete(QStringList list);

public slots:
    void updateSavedStopFavourite(QString id, bool fav); // emits.
    SavedStopItem getOneSavedStop(QString id); // emits.
    void getOneApiStop(QString id); // emits.
    QList<SavedStopItem> getStopFavouritesList(); // emits.
    QList<AbstractItem> getStopFavouritesListForModel();
    QVariantList getTimeboardBasicData(QString id);
};

#endif // DBMANAGER_H
