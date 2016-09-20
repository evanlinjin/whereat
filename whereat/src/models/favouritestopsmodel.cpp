#include "favouritestopsmodel.h"

FavouriteStopsModel::FavouriteStopsModel(DbManager &dbm, QObject *parent) :
    AbstractModel(parent), dbManager(dbm)
{
//    connect(&dbManager,
//            SIGNAL(updateSavedStopFavouriteComplete(QString,bool)),
//            this,
//            SLOT(updateFavourite(QString,bool)));

    connect(&dbManager,
            SIGNAL(updateSavedStopFavouriteComplete(QString,bool)),
            this,
            SLOT(addRemoveRow(QString,bool)));
}

FavouriteStopsModel::~FavouriteStopsModel() {

}

void FavouriteStopsModel::reload() {
    AbstractModel::startReload();
    AbstractModel::append(dbManager.getStopFavouritesListForModel());
    AbstractModel::endReload();
}

void FavouriteStopsModel::addRemoveRow(QString id, bool fav) {
    if (fav == false) {
        AbstractModel::removeRowWithId(id,fav);
    } else {
        if (!AbstractModel::ifContains(id)) {
            reload();
        }
    }
}
