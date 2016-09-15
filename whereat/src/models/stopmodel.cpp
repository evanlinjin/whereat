#include "stopmodel.h"

StopModel::StopModel(QObject *parent) : AbstractModel(parent) {

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
