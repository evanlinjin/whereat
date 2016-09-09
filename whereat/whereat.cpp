#include "whereat.h"

WhereAt::WhereAt(QObject *parent) : QObject(parent)
{
    locator = new Locator(this);
    downloader = new Downloader(this);
    listModel = new AbstractModel(this);
    favouritesModel = new StopModel(this);
}

WhereAt::~WhereAt() {
    locator->deleteLater();
    downloader->deleteLater();
    listModel->deleteLater();
    favouritesModel->deleteLater();
}
