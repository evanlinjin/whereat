#ifndef JSONPARSER_H
#define JSONPARSER_H

#include <QObject>
#include <QList>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDate>
#include <QTime>
#include <QtConcurrent>
#include <QNetworkReply>

#include "models/abstractmodel.h"
#include "db/dbabstract.h"

class JsonParser : public QObject {
    Q_OBJECT

public:
    explicit JsonParser(QObject *parent = 0);

private:
    // Takes response array from reply (deleting reply).
    QJsonArray takeResponseArray(QNetworkReply* reply);

    // Used by parseAll for Concurrent Updating.
    void parseAll_ONE(QString name, QJsonArray response);
    int pareAll_getPrimaryId(QString n, QStringList keys);
    QStringList pareAll_getSqlTypes(QJsonObject element);

signals:
    void parseAllComplete_clearReplyList();
    void parseAll_ONEProgress(QString name, int done, int max);
    void parseAll_ONEComplete(QString name);

public slots:
    void parseAll(QList<QNetworkReply*> replyList);
};

#endif // JSONPARSER_H
