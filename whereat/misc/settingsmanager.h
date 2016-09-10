#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>

class SettingsManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(int themeIndex READ themeIndex WRITE setThemeIndex NOTIFY themeIndexChanged)
    Q_PROPERTY(double stopSearchRadius READ stopSearchRadius WRITE setStopSearchRadius NOTIFY stopSearchRadiusChanged)

public:
    explicit SettingsManager(QObject *parent = 0);
    ~SettingsManager();

    int themeIndex() const;
    void setThemeIndex(const int &a);

    double stopSearchRadius() const;
    void setStopSearchRadius(const double &a);

signals:
    void themeIndexChanged(int a);
    void stopSearchRadiusChanged(double a);

private:
    QSettings* settings;
};

#endif // SETTINGSMANAGER_H
