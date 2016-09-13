#ifndef DBVERSIONS_H
#define DBVERSIONS_H

#include "dbabstract.h"

class DbVersions : public DbAbstract {
    Q_OBJECT
public:
    explicit DbVersions(QObject *parent = 0);
    ~DbVersions();
};

#endif // DBVERSIONS_H
