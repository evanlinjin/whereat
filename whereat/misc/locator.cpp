#include "locator.h"

Locator::Locator(QObject *parent) : QObject(parent) {
    source = QGeoPositionInfoSource::createDefaultSource(this);
    if (source) {
        qDebug() << this << "QGeoPositionInfoSource" << "[OK]";
    } else {
        qDebug() << this << "QGeoPositionInfoSource" << "[FAIL]";
    }

    busy = false;
}

Locator::~Locator() {
    source->deleteLater();
}
