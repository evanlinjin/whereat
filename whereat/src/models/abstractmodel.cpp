#include "abstractmodel.h"

AbstractModel::AbstractModel(QObject *parent) : QAbstractListModel(parent) {

}

AbstractModel::~AbstractModel() {
    this->clear();
}

// *** START : ROLES DEFINITION ***

QHash<int, QByteArray> AbstractModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[idRole] = "id";
    roles[typeRole] = "type";
    roles[ln0Role] = "ln0";
    roles[ln1Role] = "ln1";
    roles[ln2Role] = "ln2";
    roles[ln3Role] = "ln3";
    roles[colorRole] = "color";
    roles[favRole] = "fav";
    roles[headerRole] = "header";
    return roles;
}

QVariant AbstractModel::data(const QModelIndex &index, int role) const {
    if (index.row() < 0 || index.row() >= m_list.size()) {
        return QVariant();
    }
    int i = index.row();
    switch (role) {
    case idRole: return m_list[i].id;
    case typeRole: return m_list[i].type;
    case ln0Role: return m_list[i].ln0;
    case ln1Role: return m_list[i].ln1;
    case ln2Role: return m_list[i].ln2;
    case ln3Role: return m_list[i].ln3;
    case colorRole: return m_list[i].color;
    case favRole: return m_list[i].fav;
    case headerRole: return m_list[i].header;
    }
    return QVariant();
}

// *** END : ROLES DEFINITION ***

int AbstractModel::rowCount(const QModelIndex &) const {
    return m_list.size();
}

int AbstractModel::count() const {
    return m_list.size();
}

int AbstractModel::loading() const {
    return m_loading;
}

void AbstractModel::setLoading(bool a) {
    if (m_loading != a) {
        m_loading = a;
        emit loadingChanged();
    }
}

QString AbstractModel::emptyState() const {
    return m_emptyState;
}

void AbstractModel::setEmptyState(QString state) {
    if (m_emptyState != state) {
        m_emptyState = state;
        emit emptyStateChanged(state);
    }
}

QModelIndex AbstractModel::getIndex(int i) {
    return index(i);
}

QModelIndex AbstractModel::getIndex(AbstractItem a) {
    for (int i = 0; i < this->count(); i++) {
        if (a.id == m_list[i].id && a.type == m_list[i].type) {
            return index(i);
        }
    }
    return QModelIndex();
}

QModelIndex AbstractModel::getIndex(QString id) {
    for (int i = 0; i < this->count(); i++) {
        if (m_list[i].id == id) {
            return index(i);
        }
    }
    return QModelIndex();
}

int AbstractModel::getIndex(QString id, bool force) {
    for (int i = 0; i < this->count(); i++) {
        if (m_list[i].id == id) {
            return i;
        }
    }
    return force ? 0 : -1;
}

bool AbstractModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (index.row() < 0 || index.row() >= m_list.size()) {
        return false;
    }
    int i = index.row();
    switch (role) {
    case idRole: m_list[i].id = value.toString(); break;
    case typeRole: m_list[i].type = value.toString(); break;
    case ln0Role: m_list[i].ln0 = value.toString(); break;
    case ln1Role: m_list[i].ln1 = value.toString(); break;
    case ln2Role: m_list[i].ln2 = value.toString(); break;
    case ln3Role: m_list[i].ln3 = value.toString(); break;
    case colorRole: m_list[i].color = value.toString(); break;
    case favRole: m_list[i].fav = value.toBool(); break;
    case headerRole: m_list[i].header = value.toBool(); break;
    default:
        return false;
    }
    emit dataChanged(index, index);
    return true;
}

Qt::ItemFlags AbstractModel::flags(const QModelIndex &index) const {
    if (index.row() < 0 || index.row() >= m_list.size()) {
        return Qt::NoItemFlags;
    }
    return Qt::ItemIsEditable;
}

bool AbstractModel::removeRow(int row, const QModelIndex &index) {
    return this->removeRows(row, 1, index);
}

bool AbstractModel::removeRows(int row, int count, const QModelIndex &index) {
    if (row < 0 || (row+count-1) > this->count()) {return false;}
    beginRemoveRows(index, row, row+count-1);
    for (int i = (row+count-1); i >= row; i--) {
        m_list.removeAt(i);
    }
    emit countChanged();
    endRemoveRows();
    return true;
}

bool AbstractModel::moveRow(const QModelIndex &sourceIndex, int sourceRow,
                            const QModelIndex &destinationIndex, int destinationRow) {
    return this->moveRows(sourceIndex, sourceRow, 1, destinationIndex, destinationRow);
}

bool AbstractModel::moveRows(const QModelIndex &sourceIndex, int sourceRow,
                             int count, const QModelIndex &destinationIndex, int destinationRow) {
    if (sourceRow < 0 || destinationRow < 0 ||
            (sourceRow+count-1) > this->count() || destinationRow > this->count()) {
        return false;
    } else if (sourceRow == destinationRow || count == 0) {
        return true;
    }
    QList<AbstractItem> temp;
    temp.reserve(count);
    beginMoveRows(sourceIndex, sourceRow, sourceRow+count-1, destinationIndex, destinationRow);
    for (int i = 0; i < count; i++) {
        temp.append(m_list.takeAt(sourceRow));
    }
    for (int i = 0; i < count; i++) {
        m_list.insert(destinationRow, temp.takeLast());
    }
    endMoveRows();
    return true;
}


bool AbstractModel::clear() {
    return this->removeRows(0, this->count(), QModelIndex());
}

void AbstractModel::startReload() {
    this->setLoading(true);
    this->clear();
    eventLoop.processEvents();
}

void AbstractModel::endReload() {
    this->setLoading(false);
    eventLoop.processEvents();
}

bool AbstractModel::updateFavourite(QString id, bool fav) {
    QModelIndex index = this->getIndex(id);
    return this->setData(index, fav, AbstractModel::favRole);
}

bool AbstractModel::removeRowWithId(QString id, bool fav) {
    if (fav == true) {return -1;}
    int index = this->getIndex(id, false);
    return this->removeRow(index);
}


void AbstractModel::append(AbstractItem item) {
    beginInsertRows(QModelIndex(), this->count(), this->count());
    m_list.append(item);
    emit countChanged();
    endInsertRows();
}

void AbstractModel::append(QList<AbstractItem> list) {
    beginInsertRows(QModelIndex(), this->count(), this->count()+list.size()-1);
    for (int i = 0; i < list.size(); i++) {
        m_list.append(list[i]);
    }
    emit countChanged();
    endInsertRows();
}

void AbstractModel::append(QList<AbstractItem> list, QStringList favList) {
    this->append(list);
    for (int i = 0; i < favList.size(); i++) {
        this->updateFavourite(favList.at(i), true);
    }
}

QString AbstractModel::getIconUrl(QString stop_name) {
    if (stop_name.contains("Train Station", Qt::CaseSensitive)) {
        return QString("qrc:/icons/train.svg");
    }
    if (stop_name.contains("Ferry Terminal", Qt::CaseSensitive)) {
        return QString("qrc:/icons/ferry.svg");
    }
    return QString("qrc:/icons/bus.svg");
}

AbstractItem AbstractModel::getEmptyItem() {
    AbstractItem item;
    item.color = "";
    item.fav = false;
    item.header = false;
    item.id = "";
    item.ln0 = "";
    item.ln1 = "";
    item.ln2 = "";
    item.ln3 = "";
    item.type = "";
    return item;
}

QJsonArray AbstractModel::takeResponseArray(QNetworkReply* reply) {
    QJsonObject object = QJsonDocument::fromJson(reply->readAll()).object();
    reply->deleteLater();
    return object["response"].toArray();
}

bool AbstractModel::ifContains(QString id) {
    for (int i = 0; i < count(); i++) {
        if (id == data(getIndex(i), idRole).toString()) {
            return true;
        }
    }
    return false;
}
