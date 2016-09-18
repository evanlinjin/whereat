#ifndef FAVOURITESTOPSMODEL_H
#define FAVOURITESTOPSMODEL_H

#include <QObject>
#include "abstractmodel.h"

class FavouriteStopsModel : public AbstractModel
{
    Q_OBJECT
public:
    explicit FavouriteStopsModel(QObject *parent = 0);
    ~FavouriteStopsModel();
};

#endif // FAVOURITESTOPSMODEL_H
