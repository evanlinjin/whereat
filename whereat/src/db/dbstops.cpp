#include "dbstops.h"

DbStops::DbStops(QObject *parent) : DbAbstract("stops", parent) {
}

DbStops::~DbStops() {
}

QString DbStops::getIconUrl(QString stop_name) {
    if (stop_name.contains("Train Station", Qt::CaseSensitive)) {
        return QString("qrc:/icons/train.svg");
    }
    if (stop_name.contains("Ferry Terminal", Qt::CaseSensitive)) {
        return QString("qrc:/icons/ferry.svg");
    }
    return QString("qrc:/icons/bus.svg");
}

QList<AbstractItem> DbStops::fillList(QStringList ids) {
    DbAbstract::connectIfNeeded();
    QList<AbstractItem> list;

    for (int i = 0; i < ids.size(); i++) {
        QSqlQuery q(db);
        q.prepare("SELECT * FROM stops WHERE stop_id = ?");
        q.addBindValue(ids.at(i));
        q.exec();

        if (q.first()) {
            AbstractItem item;
            item.id = q.value("stop_id").toString();
            item.ln0 = q.value("stop_code").toString();
            item.ln1 = q.value("stop_name").toString();
            item.ln2 = "";
            item.ln3 = "";
            item.type = getIconUrl(item.ln1);
            item.color = "";
            item.fav = true;
            item.header = false;
            list.append(item);
            qDebug() << this << "fillList" << item.id;
        }
    }
    return list;
}

void DbStops::getStopData(QString id) {
    DbAbstract::connectIfNeeded();

    QSqlQuery q(db);
    q.prepare("SELECT * FROM stops WHERE stop_id = ?");
    q.addBindValue(id);
    q.exec();

    QStringList ln;
    QList<double> coord;

    if (q.first()) {
        ln.append(q.value("stop_code").toString());
        ln.append(q.value("stop_name").toString());
        ln.append(getIconUrl(ln[1]));
        coord.append(q.value("stop_lat").toDouble());
        coord.append(q.value("stop_lon").toDouble());
    }

    emit getStopDataComplete(ln, coord);
}
