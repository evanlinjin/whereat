TEMPLATE = app
TARGET = whereat

load(ubuntu-click)

QT += qml quick core positioning concurrent network sql

SOURCES += main.cpp \
    src/whereat.cpp \
    src/models/abstractmodel.cpp \
    src/models/stopmodel.cpp \
    src/locator.cpp \
    src/downloader.cpp \
    src/settingsmanager.cpp \
    src/jsonparser.cpp \
    src/db/dbabstract.cpp \
    src/db/dbversions.cpp \
    src/db/dbagency.cpp \
    src/db/dbroutes.cpp \
    src/db/dbcalendar.cpp \
    src/db/dbstops.cpp \
    src/db/dbtrips.cpp

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
    src/whereat.h \
    src/models/abstractmodel.h \
    src/models/stopmodel.h \
    src/locator.h \
    src/downloader.h \
    src/settingsmanager.h \
    src/jsonparser.h \
    src/db/dbabstract.h \
    src/db/dbversions.h \
    src/db/dbagency.h \
    src/db/dbroutes.h \
    src/db/dbcalendar.h \
    src/db/dbstops.h \
    src/db/dbtrips.h \
    src/db/all.h

DISTFILES += \
    qml/components/NavigationMenu.qml \
    qml/components/listItems/SwitchLI.qml
