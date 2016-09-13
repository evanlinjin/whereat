#ifndef DBAGENCY_H
#define DBAGENCY_H

#include "dbabstract.h"

class DbAgency : public DbAbstract {
    Q_OBJECT
public:
    explicit DbAgency(QObject *parent = 0);
    ~DbAgency();
};

#endif // DBAGENCY_H
