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

signals:
    void getStopDataComplete(QStringList ln, QList<double> coord);

public slots:
    QList<AbstractItem> fillList(QStringList ids);
    void getStopData(QString id);
};

#endif // DBSTOPS_H
