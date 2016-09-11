#include "stopmodel.h"

StopModel::StopModel(QObject *parent) : AbstractModel(parent) {
//        QList<AbstractItem> list;
//        AbstractItem item;
//        for (int i = 0; i < 20; i++) {
//            item.ln0 = "Index" + QString::number(i);
//            item.ln1 = "Testing on it!";
//            item.ln2 = "yeah g.";
//            list.append(item);
//        }
//        AbstractModel::append(list);

    // SIGNALS & SLOTS >>>
}

void StopModel::reload() {
    AbstractModel::setLoading(true);
    AbstractModel::clear();
}
