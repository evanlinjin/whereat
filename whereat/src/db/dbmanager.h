#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QObject>
#include <QtSql>
#include <QList>
#include <QStandardPaths>
#include <QJsonObject>
#include <QDebug>

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

    QSqlQuery getSavedStopsQuery();

    // FOR : SAVED STOPS >>>
signals:
    void updateSavedStopFavouriteComplete(QString id, bool fav);
    void getOneSavedStopComplete(QString id, bool fav, int fav_index, int visits, QString color);
    void getStopFavouritesListComplete(QStringList list);
public slots:
    void updateSavedStopFavourite(QString id, bool fav);
    SavedStopItem getOneSavedStop(QString id);
    QStringList getStopFavouritesList();

};

#endif // DBMANAGER_H
