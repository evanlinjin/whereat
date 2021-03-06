QT += qml quick core positioning concurrent network sql xml svg quickcontrols2

CONFIG += c++11

INCLUDEPATH += whereat

SOURCES += whereat_android/main.cpp \
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

RESOURCES += whereat_android/qml.qrc \
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

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
