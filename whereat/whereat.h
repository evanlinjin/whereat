#ifndef WHEREAT_H
#define WHEREAT_H

#include <QObject>
#include "models/abstractmodel.h"
#include "models/stopmodel.h"

class WhereAt : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString atApiKey READ atApiKey WRITE setAtApiKey NOTIFY atApiKeyChanged)

public:
    explicit WhereAt(QObject *parent = 0);
    QString atApiKey() const {return m_atApiKey;}
    void setAtApiKey(const QString &a) {if (a != m_atApiKey) {m_atApiKey = a; emit atApiKeyChanged();}}

    AbstractModel* listModel;
    StopModel* favouritesModel;

private:
    QString m_atApiKey;

signals:
    void atApiKeyChanged();

public slots:
};

#endif // WHEREAT_H