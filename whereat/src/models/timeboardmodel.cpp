#include "timeboardmodel.h"

TimeboardModel::TimeboardModel(QObject *parent) : AbstractModel(parent) {

}

void TimeboardModel::append(QList<AbstractItem> list) {
    AbstractModel::append(list);
}

void TimeboardModel::reload() {
    AbstractModel::setLoading(true);
    AbstractModel::clear();
}
