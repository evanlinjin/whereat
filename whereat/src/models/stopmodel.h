#ifndef STOPMODEL_H
#define STOPMODEL_H

#include "abstractmodel.h"

class StopModel : public AbstractModel {
    Q_OBJECT

public:
    explicit StopModel(QObject *parent = 0);
    ~StopModel() {AbstractModel::clear();}

signals:

public slots:
    void reload();
    //bool removeFavourite(int index);
};

#endif // STOPMODEL_H
