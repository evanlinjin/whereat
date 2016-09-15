#ifndef DBSAVEDSTOPS_H
#define DBSAVEDSTOPS_H

#include "dbabstract.h"

class DbSavedStops : public DbAbstract {
    Q_OBJECT
public:
    explicit DbSavedStops(QObject *parent = 0);
    ~DbSavedStops();
private:
    QStringList keys, keyTypes;
    void connectIfNeeded();

signals:
    void updateFavouriteComplete(QString id, bool fav);
    void getOneComplete(QString id, bool fav, int fav_index, int visits, QString color);
    void getFavouritesListComplete(QStringList list);

public slots:
    void updateFavourite(QString id, bool fav);
    void getOne(QString id);
    QStringList getFavouritesList();
};

#endif // DBSAVEDSTOPS_H
