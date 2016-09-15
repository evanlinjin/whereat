#ifndef DBSTOPS_H
#define DBSTOPS_H

#include "dbabstract.h"
#include "../models/abstractmodel.h"

class DbStops : public DbAbstract {
    Q_OBJECT
public:
    explicit DbStops(QObject *parent = 0);
    ~DbStops();

public slots:
    QList<AbstractItem> fillList(QStringList ids);
};

#endif // DBSTOPS_H
