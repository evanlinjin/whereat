TEMPLATE = app
TARGET = whereat

load(ubuntu-click)

QT += qml quick core positioning concurrent network sql

SOURCES += main.cpp \
    whereat.cpp \
    models/abstractmodel.cpp \
    models/stopmodel.cpp \
    misc/locator.cpp \
    misc/downloader.cpp \
    misc/settingsmanager.cpp \
    logic/jsonparser.cpp

RESOURCES += whereat.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  whereat.apparmor \
               whereat.png \
               $$files(icons/*.svg,true) \
               $$files(icons/*.png,true)

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

#show all the files in QtCreator
OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               whereat.desktop

#specify where the config files are installed to
config_files.path = /whereat
config_files.files += $${CONF_FILES}
INSTALLS+=config_files

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /whereat
desktop_file.files = $$OUT_PWD/whereat.desktop
desktop_file.CONFIG += no_check_exist
INSTALLS+=desktop_file

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

HEADERS += \
    keys.h \
    whereat.h \
    models/abstractmodel.h \
    models/stopmodel.h \
    misc/locator.h \
    misc/downloader.h \
    misc/settingsmanager.h \
    logic/jsonparser.h
