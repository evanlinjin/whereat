#ifndef DBROUTES_H
#define DBROUTES_H

#include "dbabstract.h"

class DbRoutes : public DbAbstract {
    Q_OBJECT
public:
    explicit DbRoutes(QObject *parent = 0);
    ~DbRoutes();
};

#endif // DBROUTES_H
