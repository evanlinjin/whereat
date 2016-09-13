#ifndef APIDBMANAGER_H
#define APIDBMANAGER_H

#include <QObject>
#include <QJsonValue>
#include <QVariant>

struct ApiDbItem {
    bool isPrimary;
    QString key;
    QJsonValue::Type type;
    QVariant value;
};

class ApiDbManager : public QObject
{
    Q_OBJECT
public:
    explicit ApiDbManager(QObject *parent = 0);

signals:

public slots:
};

#endif // APIDBMANAGER_H
