#ifndef ABSTRACTMODEL_H
#define ABSTRACTMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QtSql>
#include <QList>
#include <QStandardPaths>
#include <QJsonObject>
#include <QDebug>

struct AbstractItem {
    QString id;     // Identifier String.
    QString type;   // Type (For determining icon type).
    QString ln0;    // [0] -- Display --
    QString ln1;    // [1] -------------
    QString ln2;    // [2] -------------
    QString ln3;    // [3] -------------
    QString color;  // Color.
    bool fav;       // Whether is favourte.
    bool header;    // Whether is header.
};

class AbstractModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
    Q_PROPERTY(QString emptyState READ emptyState NOTIFY emptyStateChanged)

public:
    explicit AbstractModel(QObject *parent = 0);
    ~AbstractModel();

    enum Roles {
        idRole = Qt::UserRole + 1,
        typeRole,
        ln0Role,
        ln1Role,
        ln2Role,
        ln3Role,
        colorRole,
        favRole,
        headerRole
    };

    QHash<int, QByteArray> roleNames() const;

    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int count() const;

    int loading() const;
    void setLoading(bool a);

    QString emptyState() const;
    void setEmptyState(QString state);

    QModelIndex getIndex(int i);
    QModelIndex getIndex(AbstractItem a);
    QModelIndex getIndex(QString id);
    int getIndex(QString id, bool force);

    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex &index) const;

    bool removeRow(int row, const QModelIndex &index = QModelIndex());
    bool removeRows(int row, int count, const QModelIndex &index = QModelIndex());
    bool moveRow(const QModelIndex &sourceIndex = QModelIndex(), int sourceRow = 0,
                 const QModelIndex &destinationIndex = QModelIndex(), int destinationRow = 0);
    bool moveRows(const QModelIndex &sourceIndex = QModelIndex(), int sourceRow = 0,
                  int count = 0, const QModelIndex &destinationIndex = QModelIndex(), int destinationRow = 0);

    void append(AbstractItem item);
    void append(QList<AbstractItem> list);
    void append(QList<AbstractItem> list, QStringList favList);

protected:
    QSqlDatabase openDB(QString name);
    void initTable(QString dbName, QString tableName, QStringList keys, QStringList keyTypes, int primaryIndex);

private:
    QList<AbstractItem> m_list;
    bool m_loading;
    QString m_emptyState;

    QString getIconUrl(QString stop_name);

signals:
    void countChanged();
    void loadingChanged();
    void emptyStateChanged(QString state);

public slots:
    bool clear();
    void reload();
    bool updateFavourite(QString id, bool fav);
    bool removeRowWithId(QString id, bool fav);

};

#endif // ABSTRACTMODEL_H
