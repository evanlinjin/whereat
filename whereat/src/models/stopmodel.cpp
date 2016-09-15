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

void StopModel::append(QList<AbstractItem> list, QStringList favList) {
    AbstractModel::append(list);
    for (int i = 0; i < favList.size(); i++) {
        this->updateFavourite(favList.at(i), true);
    }
}

void StopModel::reload() {
    AbstractModel::setLoading(true);
    AbstractModel::clear();
}

bool StopModel::updateFavourite(QString id, bool fav) {
    QModelIndex index = AbstractModel::getIndex(id);
    return AbstractModel::setData(index, fav, AbstractModel::favRole);
}
