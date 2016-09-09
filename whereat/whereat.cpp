#include "whereat.h"

WhereAt::WhereAt(QObject *parent) : QObject(parent)
{
    locator = new Locator(this);
    listModel = new AbstractModel(this);
    favouritesModel = new StopModel(this);
}

WhereAt::~WhereAt() {
    locator->deleteLater();
    listModel->deleteLater();
    favouritesModel->deleteLater();
}
