#ifndef DBSTOPS_H
#define DBSTOPS_H

#include "dbabstract.h"
#include "../models/abstractmodel.h"

class DbStops : public DbAbstract {
    Q_OBJECT
public:
    explicit DbStops(QObject *parent = 0);
    ~DbStops();
private:
    QString getIconUrl(QString stop_name);
public slots:
    QList<AbstractItem> fillList(QStringList ids);
};

#endif // DBSTOPS_H
