#include "whereat.h"

WhereAt::WhereAt(QObject *parent) : QObject(parent) {

    downloader = new Downloader(this);
    jsonParser = new JsonParser(this);
}

WhereAt::~WhereAt() {

    downloader->deleteLater();
    jsonParser->deleteLater();

    // Remove all db connections.
    QStringList dbConnections = QSqlDatabase::connectionNames();
    for (int i = 0; i < dbConnections.size(); i++) {
        QSqlDatabase::removeDatabase(dbConnections.at(i));
    }
}

// PRIVATE DEFINITIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void WhereAt::clearDlReplyList() {
    qDebug() << this << "clearDlReplyList" << dlReplyList.size();
    for (int i = 0; i < dlReplyList.size(); i++) {
        dlReplyList.takeAt(0)->deleteLater();
    }
}

// DEFINITIONS FOR : UPDATE DATABASE MANUAL >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void WhereAt::updateDbManual() {
    qDebug() << this << "updateDbManual";
    parseCount = dlCount = dlFails = 0; dlMax = 6;
    this->clearDlReplyList();

    connect(downloader, SIGNAL(getAllOneComplete(QNetworkReply*)),
            this, SLOT(updateDbManual_REPLY(QNetworkReply*)));
    connect(downloader, SIGNAL(getAllOneFailed(QNetworkReply::NetworkError)),
            this, SLOT(updateDbManual_REPLY(QNetworkReply::NetworkError)));

    downloader->getAll();
}

void WhereAt::updateDbManual_REPLY(QNetworkReply *reply) {
    qDebug() << this << "updateDbManual_REPLY" << reply->url().path();
    dlCount += 1;
    this->dlReplyList.append(reply);
    emit progress(QString("Downloading..."), dlCount+1, dlMax);

    // Only Continue if all files downloaded.
    if (dlCount == dlMax) {
        disconnect(downloader, SIGNAL(getAllOneComplete(QNetworkReply*)),
                   this, SLOT(updateDbManual_REPLY(QNetworkReply*)));
        disconnect(downloader, SIGNAL(getAllOneFailed(QNetworkReply::NetworkError)),
                   this, SLOT(updateDbManual_REPLY(QNetworkReply::NetworkError)));

        if (dlFails > 0) { // If some downloads fail, stop all & reset.
            qDebug() << this << "updateDbManual_REPLY FAILED" << dlFails;
            parseCount = dlCount = dlFails = dlMax = 0;
            this->clearDlReplyList();
            downloader->resetConnections();
            return;
        }

        connect(jsonParser, SIGNAL(parseAllComplete_clearReplyList()),
                this, SLOT(clearDlReplyList()));
        connect(jsonParser, SIGNAL(parseAll_ONEComplete(QString)),
                this, SLOT(updateDbManual_JSON(QString)));
        connect(jsonParser, SIGNAL(parseAll_ONEProgress(QString,int,int)),
                this, SIGNAL(progress(QString,int,int)));

        jsonParser->parseAll(this->dlReplyList);
    }
}

void WhereAt::updateDbManual_REPLY(QNetworkReply::NetworkError error) {
    qDebug() << this << "updateDbManual_REPLY" << error;
    dlFails += 1;
}

void WhereAt::updateDbManual_JSON(QString name) {
    qDebug() << this << "updateDbManual_JSON DONE" << name;
    parseCount += 1;
    emit progress0(parseCount, dlMax);

    if (parseCount == dlMax) {
        disconnect(jsonParser, SIGNAL(parseAllComplete_clearReplyList()),
                   this, SLOT(clearDlReplyList()));
        disconnect(jsonParser, SIGNAL(parseAll_ONEComplete(QString)),
                   this, SLOT(updateDbManual_JSON(QString)));
        disconnect(jsonParser, SIGNAL(parseAll_ONEProgress(QString,int,int)),
                   this, SIGNAL(progress(QString,int,int)));

        parseCount = dlCount = dlFails = dlMax = 0;
        downloader->resetConnections();
        emit updateDbManualComplete();
    }
}

// DEFINITIONS FOR : UPDATE DATABASE NORMAL >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void WhereAt::updateDb() {
    qDebug() << this << "updateDb";

    connect(downloader, SIGNAL(getGitDbComplete(int,QNetworkReply*)),
            this, SLOT(updateDb_REPLY(int,QNetworkReply*)));
    connect(downloader, SIGNAL(getGitDbProgress(qint64,qint64)),
            this, SIGNAL(progress0(qint64,qint64)));

    downloader->getGitDb();
}

void WhereAt::updateDb_REPLY(int status, QNetworkReply* reply) {
    if (status != 0) {
        qDebug() << this << "Download error.";
        return;
    }

    QIODevice *data = reply;
    QByteArray sdata;

    // Setup directory.
    QString path =
            QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation)
            + QString("/db/");
    QDir dir(path);
    if (!dir.exists()) {dir.mkdir(path);}

    QFile file(path + "api.db");
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << this << "Cannot open" << path << "api.db" << "for writing.";
        goto dbUpdateEnd;
    } else {
        qDebug() << this << "Opened" << path << "api.db" << "for writing.";
    }

    sdata = data->readAll();
    file.write(sdata);
    qDebug() << sdata;
    file.close();

dbUpdateEnd:
    reply->deleteLater();
    disconnect(downloader, SIGNAL(getGitDbComplete(int,QNetworkReply*)),
               this, SLOT(updateDb_REPLY(int,QNetworkReply*)));
    disconnect(downloader, SIGNAL(getGitDbProgress(qint64,qint64)),
               this, SIGNAL(progress0(qint64,qint64)));
    emit updateDbManualComplete();
}









































