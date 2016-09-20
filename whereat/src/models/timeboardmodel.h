#ifndef TIMEBOARDMODEL_H
#define TIMEBOARDMODEL_H

#include <QVariant>
#include <QTime>
#include <QDate>
#include <QDebug>
#include <QtConcurrent>

#include "abstractmodel.h"
#include "src/db/dbmanager.h"
#include "src/downloader.h"

class TimeboardModel : public AbstractModel {
    Q_OBJECT
    Q_PROPERTY(QVariantList ln READ ln NOTIFY lnChanged)
    // 0:id, 1:code, 2:name, 3:lat, 4:lon, 5:type, 6:fav, 7:color
public:
    explicit TimeboardModel(Downloader &d, DbManager &dbm, QObject *parent = 0);
    ~TimeboardModel() {AbstractModel::clear();}

    QVariantList ln() const {return m_ln;}

private:
    Downloader &downloader;
    DbManager &dbManager;

    QList<TimeboardItem> tempList;
    QVariantList m_ln;
    QTime time;

    int getCurrentTimeInSeconds();

signals:
    void lnChanged();
    void end();

public slots:
    void updateLn(QString id);
    void reload(QString id);

private slots:
    void reload_REPLY(int status, QNetworkReply* reply);
    void reload_THREAD(QJsonArray response);
    void reload_rtREPLY(int status, QNetworkReply* reply);
    //void reload_rtTHREAD();
    void reload_END();

};

#endif // TIMEBOARDMODEL_H
