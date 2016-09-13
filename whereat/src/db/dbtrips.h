#ifndef DBTRIPS_H
#define DBTRIPS_H

#include "dbabstract.h"

class DbTrips : public DbAbstract {
    Q_OBJECT
public:
    explicit DbTrips(QObject *parent = 0);
    ~DbTrips();
};

#endif // DBTRIPS_H
