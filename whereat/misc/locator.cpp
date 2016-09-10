#include "locator.h"

Locator::Locator(QObject *parent) : QObject(parent) {
    source = QGeoPositionInfoSource::createDefaultSource(this);
    if (source) {
        qDebug() << this << "QGeoPositionInfoSource" << "[OK]";
    } else {
        qDebug() << this << "QGeoPositionInfoSource" << "[FAIL]";
    }

    // SIGNALS & SLOTS >>>
    connect(source, SIGNAL(positionUpdated(QGeoPositionInfo)),
            this, SLOT(getPositionUpdateSuccess(QGeoPositionInfo)));
    connect(source, SIGNAL(updateTimeout()),
            this, SLOT(getPositionUpdateFail()));
}

Locator::~Locator() {
    source->deleteLater();
}

void Locator::request() {
    source->requestUpdate(5000); // 5s timeout.
}

void Locator::getPositionUpdateSuccess(QGeoPositionInfo info) {
    QGeoCoordinate coord = info.coordinate();
    lat = coord.latitude();
    lon = coord.longitude();
    qDebug() << this << "getPositionUpdateSuccess" << lat << lon;
    emit response(true, lat, lon);
    source->stopUpdates();
}

void Locator::getPositionUpdateFail() {
    qDebug() << this << "getPositionUpdateFail" << lat << lon;
    emit response(false, lat, lon);
    source->stopUpdates();
}
