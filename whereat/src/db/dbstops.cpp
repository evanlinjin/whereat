#include "dbstops.h"

DbStops::DbStops(QObject *parent) : DbAbstract("stops", parent) {
}

DbStops::~DbStops() {
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
            item.color = "";
            item.fav = true;
            item.header = false;
            list.append(item);
            qDebug() << this << "fillList" << item.id;
        }
    }
    return list;
}
