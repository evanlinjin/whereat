#ifndef FAVOURITESTOPSMODEL_H
#define FAVOURITESTOPSMODEL_H

#include <QObject>
#include "abstractmodel.h"
#include "src/db/dbmanager.h"

class FavouriteStopsModel : public AbstractModel
{
    Q_OBJECT
public:
    explicit FavouriteStopsModel(DbManager &dbm, QObject *parent = 0);
    ~FavouriteStopsModel();
private:
    DbManager &dbManager;
public slots:
    void reload();
    void addRemoveRow(QString id, bool fav);
};

#endif // FAVOURITESTOPSMODEL_H
