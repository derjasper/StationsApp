#ifndef ANDROIDPERMISSIONS_H
#define ANDROIDPERMISSIONS_H

#include <QObject>

class AndroidPermissions : public QObject
{
    Q_OBJECT
public:
    explicit AndroidPermissions(QObject *parent = nullptr);
    Q_INVOKABLE void request(const QStringList& permissions);
    Q_INVOKABLE void requestWriteExternalStorage();

    Q_INVOKABLE bool check(const QString& permission);
    Q_INVOKABLE bool checkWriteExternalStorage();

Q_SIGNALS:
    void finished(QString result);
    void failed();

};

#endif // ANDROIDPERMISSIONS_H

