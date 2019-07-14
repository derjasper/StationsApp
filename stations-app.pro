QT += core quick quickcontrols2 svg
CONFIG += c++11 #qtquickcompiler

DEFINES += QT_DEPRECATED_WARNINGS

DEFINES += APPLICATION_NAME=\\\"stations-app\\\"
DEFINES += ORGANIZATION_NAME=\\\"de.jaspernalbach\\\"

HEADERS += fslistmodel.h \
    launcher.h \
    androidpermissions.h

SOURCES += main.cpp \
    fslistmodel.cpp \
    launcher.cpp \
    androidpermissions.cpp

RESOURCES += qml.qrc \
    icons.qrc

android {
    QT += androidextras
    DEFINES += ANDROID
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
}
contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
}
