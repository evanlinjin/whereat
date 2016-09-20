#ifndef DBABSTRACT_H
#define DBABSTRACT_H

#include <QObject>
#include <QtSql>
#include <QList>
#include <QStandardPaths>
#include <QJsonObject>
#include <QDebug>

class DbAbstract : public QObject {
    Q_OBJECT
public:
    explicit DbAbstract(QString name, QObject *parent = 0);
    ~DbAbstract();

protected:
    const QString dbName;
    QSqlDatabase db;
    bool isOpen;

    QSqlDatabase openDb();
    QSqlQuery getApiQuery();

signals:

public slots:
    //bool connectIfNeeded();
    void initTable(QStringList keys, QStringList keyTypes, int primaryIndex);
    void initTable(QString tableName, QStringList keys, QStringList keyTypes, int primaryIndex);
    void updateElement(QString tableName, QJsonObject element, QStringList keys);

};

#endif // DBABSTRACT_H
