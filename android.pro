QT += qml quick core positioning concurrent network sql

CONFIG += c++11

INCLUDEPATH += whereat

SOURCES += android/main.cpp \
    whereat/src/whereat.cpp \
    whereat/src/models/abstractmodel.cpp \
    whereat/src/locator.cpp \
    whereat/src/downloader.cpp \
    whereat/src/settingsmanager.cpp \
    whereat/src/jsonparser.cpp \
    whereat/src/db/dbabstract.cpp \
    whereat/src/models/timeboardmodel.cpp \
    whereat/src/models/favouritestopsmodel.cpp \
    whereat/src/db/dbmanager.cpp \
    whereat/src/models/nearbystopsmodel.cpp \
    whereat/src/models/searchstopsmodel.cpp

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

RESOURCES += android_qml.qrc \
    whereat/whereat.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    whereat/keys.h \
    whereat/src/whereat.h \
    whereat/src/models/abstractmodel.h \
    whereat/src/locator.h \
    whereat/src/downloader.h \
    whereat/src/settingsmanager.h \
    whereat/src/jsonparser.h \
    whereat/src/db/dbabstract.h \
    whereat/src/db/all.h \
    whereat/src/models/timeboardmodel.h \
    whereat/src/models/favouritestopsmodel.h \
    whereat/src/db/dbmanager.h \
    whereat/src/models/nearbystopsmodel.h \
    whereat/src/models/searchstopsmodel.h
