#include "fslistmodel.h"

FsListModel::FsListModel(QObject *parent) :
    QAbstractListModel(parent) {

}

QVariantMap FsListModel::schema() const {
    return m_schema;
}

void FsListModel::setSchema(const QVariantMap &schema) {
    if (m_schema != QVariantMap())
        return;

    m_schema = schema;

    m_roles.clear();
    QMapIterator<QString, QVariant> it(m_schema);
    int i = 0;
    while (it.hasNext()) {
        it.next();
        m_roles[Qt::UserRole+1+i] = it.key().toUtf8();
        i++;
    }
}

int FsListModel::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return m_data.count();
}

QVariant FsListModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= m_data.count())
        return QVariant();

    const QVariantMap& entry = m_data[index.row()].data;

    if (!m_roles.contains(role))
        return QVariant();
    QString roleName = QString::fromStdString(m_roles.value(role).toStdString());

    if (entry.contains(roleName)) {
        return entry.value(roleName);
    }

    return QVariant();
}

bool FsListModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (!index.isValid()) return false;

    if (!m_roles.contains(role))
        return false;
    QString roleName(m_roles.value(role));
    if (m_data[index.row()].data.value(roleName) != value) {
        m_data[index.row()].data.insert(roleName, value);
        emit dataChanged(index, index, { role });

        storeToStorage(index.row());

        return true;
    }
    else {
        return false;
    }
}

QHash<int, QByteArray> FsListModel::roleNames() const {
    return m_roles;
}

QString replaceUserPath(QString s) {
    if (s.startsWith ("~/"))
        s.replace (0, 1, QDir::homePath());
    return s;
}

QString FsListModel::storageLocation() const {
    return m_storageLocation;
}

void FsListModel::setStorageLocation(const QString &storageLocation) {
    m_storageLocation = replaceUserPath(storageLocation);

    emit storageLocationChanged();
    reload();
}

void FsListModel::reload() {
    beginRemoveRows(QModelIndex(), 0, m_data.size()-1);
    m_data.clear();
    endRemoveRows();

    loadFromStorage();
}

bool FsListModel::append(QVariantMap data) {
    Entry entry;
    entry.identifier = QUuid::createUuid();
    entry.data = data;

    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_data.append(entry);
    endInsertRows();

    storeToStorage(rowCount()-1);

    return true;
}

bool FsListModel::remove(int row) {
    removeFromStorage(row);

    beginRemoveRows(QModelIndex(), row, row);
    m_data.removeAt(row);
    endRemoveRows();

    return true;
}

QString FsListModel::storageLocation(QUuid identifier) const {
    return QDir(m_storageLocation).absolutePath() + "/" + identifier.toString() + ".json";
}

void FsListModel::loadFromStorage() {
    QDir directory(m_storageLocation);
    if (!directory.exists())
        directory.mkpath(".");

    QStringList entryFiles = directory.entryList(QStringList() << "*.json", QDir::Files);
    foreach(const QString& filename, entryFiles) {
        QUuid identifier = QUuid(filename.split("/").last().split(".").first());
        loadFromStorage(identifier);
    }
}

void FsListModel::loadFromStorage(QUuid identifier) {
    QFile file(storageLocation(identifier));
    file.open(QFile::ReadOnly);
    QJsonDocument json = QJsonDocument::fromJson(file.readAll());
    QVariantMap data = json.object().toVariantMap();

    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    Entry entry;
    entry.identifier = identifier;
    entry.data = data;
    m_data.append(entry);
    endInsertRows();
}

void FsListModel::storeToStorage(int idx) const {
    QJsonDocument json = QJsonDocument::fromVariant(m_data[idx].data);
    QFile file(storageLocation(m_data[idx].identifier));
    file.open(QFile::WriteOnly);
    file.write(json.toJson());
}

void FsListModel::removeFromStorage(int idx) const {
    QFile file(storageLocation(m_data[idx].identifier));
    file.remove();
}
