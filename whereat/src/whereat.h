#ifndef WHEREAT_H
#define WHEREAT_H

#include <QObject>
#include <QDebug>

#include "src/db/dbabstract.h"
#include "src/downloader.h"
#include "src/jsonparser.h"

class WhereAt : public QObject {
    Q_OBJECT

public:
    explicit WhereAt(QObject *parent = 0);
    ~WhereAt();

    Downloader* downloader; // needed by WhereAt...
    JsonParser* jsonParser;

private:

    // Used for manual database update.
    int parseCount, dlCount, dlFails, dlMax;
    QList<QNetworkReply*> dlReplyList;

signals:
    // Connect this to QGuiApplication::quit.
    void quit();

    void progress(QString n, int done, int max);
    void progress0(int done, int max);
    void updateDbManualComplete();

public slots:
    void updateDbManual();

private slots:
    // Clearing db for manual database update.
    void clearDlReplyList();

    void updateDbManual_REPLY(QNetworkReply* reply);
    void updateDbManual_REPLY(QNetworkReply::NetworkError error);
    void updateDbManual_JSON(QString name);

};

#endif // WHEREAT_H
