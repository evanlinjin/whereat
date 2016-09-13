#ifndef DBSTOPS_H
#define DBSTOPS_H

#include "dbabstract.h"

class DbStops : public DbAbstract {
    Q_OBJECT
public:
    explicit DbStops(QObject *parent = 0);
    ~DbStops();
};

#endif // DBSTOPS_H
