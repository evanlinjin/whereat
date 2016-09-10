#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>

class SettingsManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(double stopSearchRadius READ stopSearchRadius WRITE setStopSearchRadius NOTIFY stopSearchRadiusChanged)

public:
    explicit SettingsManager(QObject *parent = 0);
    ~SettingsManager();

    double stopSearchRadius() const;
    void setStopSearchRadius(const double &a);

signals:
    void stopSearchRadiusChanged(double a);

private:
    QSettings* settings;
};

#endif // SETTINGSMANAGER_H
