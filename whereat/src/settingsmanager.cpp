#include "settingsmanager.h"

SettingsManager::SettingsManager(QObject *parent) : QObject(parent) {
    settings = new QSettings("whereat.evanlinjin", "whereat", this);
}

SettingsManager::~SettingsManager() {
    settings->deleteLater();
}

int SettingsManager::themeIndex() const {
    return settings->value("appearance/themeIndex", 0).toInt();
}
void SettingsManager::setThemeIndex(const int &a) {
    settings->setValue("appearance/themeIndex", a);
    emit themeIndexChanged(a);
}

double SettingsManager::stopSearchRadius() const {
    return settings->value("stops/searchRadius", 1000.0).toDouble();
}
void SettingsManager::setStopSearchRadius(const double &a) {
    settings->setValue("stops/searchRadius", a);
    emit stopSearchRadiusChanged(a);
}
