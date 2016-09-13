#ifndef DBABSTRACT_H
#define DBABSTRACT_H

#include <QObject>
#include <QtSql>
#include <QList>
#include <QStandardPaths>
#include <QDebug>

class DbAbstract : public QObject
{
    Q_OBJECT
public:
    explicit DbAbstract(QString name, QObject *parent = 0);
    ~DbAbstract();

protected:
    const QString dbName;
    QSqlDatabase db;

signals:

public slots:
    void initTable(QStringList keys, QStringList keyTypes, int primaryIndex);

};

#endif // DBABSTRACT_H
