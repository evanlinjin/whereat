#ifndef LOCATOR_H
#define LOCATOR_H

#include <QObject>
#include <QGeoPositionInfoSource>

class Locator : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)

public:
    explicit Locator(QObject *parent = 0);
    ~Locator();

    bool busy() const {return busy;}

private:
    QGeoPositionInfoSource *source;
    bool m_busy;
    void setBusy(bool a) {if (a != busy) {busy = a; emit busyChanged(busy);}}

signals:
    busyChanged(bool busy);

public slots:
    void request(int ms, QString id);
};

#endif // LOCATOR_H
