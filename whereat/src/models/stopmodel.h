#ifndef STOPMODEL_H
#define STOPMODEL_H

#include "abstractmodel.h"

class StopModel : public AbstractModel {
    Q_OBJECT

public:
    explicit StopModel(QObject *parent = 0);
    ~StopModel() {AbstractModel::clear();}

    void append(QList<AbstractItem> list, QStringList favList);

signals:

public slots:
    void reload();
    bool updateFavourite(QString id, bool fav);
};

#endif // STOPMODEL_H
