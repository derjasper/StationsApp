#ifndef FSLISTMODEL_H
#define FSLISTMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QUuid>
#include <QFile>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>

struct Entry {
    QUuid identifier;
    QVariantMap data;
};

class FsListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap schema READ schema WRITE setSchema) // TODO make static
    Q_PROPERTY(QString storageLocation READ storageLocation WRITE setStorageLocation NOTIFY storageLocationChanged)

private:
    QVariantMap m_schema;
    QHash<int, QByteArray> m_roles;
    QList<Entry> m_data;
    QString m_storageLocation;

    QString storageLocation(QUuid identifier) const;
    void loadFromStorage();
    void loadFromStorage(QUuid identifier);
    void storeToStorage(int idx) const;
    void removeFromStorage(int idx) const;

signals:
    void storageLocationChanged();


public:
    explicit FsListModel(QObject *parent = 0);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    bool setData(const QModelIndex &index, const QVariant &value, int role);

    QVariantMap schema() const;
    void setSchema(const QVariantMap &schema);

    Q_INVOKABLE bool append(QVariantMap entry);

    Q_INVOKABLE bool remove(int row);

    QString storageLocation() const;
    void setStorageLocation(const QString &storageLocation);

    Q_INVOKABLE void reload();

protected:
    QHash<int, QByteArray> roleNames() const;

};

#endif // FSLISTMODEL_H

