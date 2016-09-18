#ifndef TIMEBOARDMODEL_H
#define TIMEBOARDMODEL_H

#include "abstractmodel.h"

class TimeboardModel : public AbstractModel {
    Q_OBJECT

public:
    explicit TimeboardModel(QObject *parent = 0);
    ~TimeboardModel() {AbstractModel::clear();}

    void append(QList<AbstractItem> list);

public slots:
    void reload();
};

#endif // TIMEBOARDMODEL_H
