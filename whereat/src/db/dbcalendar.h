#ifndef DBCALENDAR_H
#define DBCALENDAR_H

#include "dbabstract.h"

class DbCalendar : public DbAbstract {
    Q_OBJECT
public:
    explicit DbCalendar(QObject *parent = 0);
    ~DbCalendar();
};

#endif // DBCALENDAR_H
