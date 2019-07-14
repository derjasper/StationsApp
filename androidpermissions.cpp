#include "androidpermissions.h"

#ifdef ANDROID
    #include <QtAndroid>
#endif

AndroidPermissions::AndroidPermissions(QObject *parent) : QObject(parent) {

}


void AndroidPermissions::request(const QStringList& permissions) {
    #ifdef ANDROID
        QtAndroid::requestPermissionsSync(permissions);
    #endif
}

void AndroidPermissions::requestWriteExternalStorage() {
    QStringList l;
    l << "android.permission.WRITE_EXTERNAL_STORAGE";
    request(l);
}

bool AndroidPermissions::check(const QString& permission) {
    #ifdef ANDROID
        QtAndroid::PermissionResult r = QtAndroid::checkPermission(permission);
        return r != QtAndroid::PermissionResult::Denied;
    #else
        return true;
    #endif
}

bool AndroidPermissions::checkWriteExternalStorage() {
    return check("android.permission.WRITE_EXTERNAL_STORAGE");
}
