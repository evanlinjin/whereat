#ifndef ABSTRACTMODEL_H
#define ABSTRACTMODEL_H

#include <QObject>
#include <QAbstractListModel>
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

    QModelIndex getIndex(int i);
    QModelIndex getIndex(AbstractItem a);

    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex &index) const;

protected slots:
    bool removeRow(int row, const QModelIndex &index = QModelIndex());
    bool removeRows(int row, int count, const QModelIndex &index = QModelIndex());
    bool moveRow(const QModelIndex &sourceIndex = QModelIndex(), int sourceRow = 0,
                 const QModelIndex &destinationIndex = QModelIndex(), int destinationRow = 0);
    bool moveRows(const QModelIndex &sourceIndex = QModelIndex(), int sourceRow = 0,
                  int count = 0, const QModelIndex &destinationIndex = QModelIndex(), int destinationRow = 0);
    void append(AbstractItem item);
    void append(QList<AbstractItem> list);

private:
    QList<AbstractItem> m_list;
    bool m_loading;

signals:
    void countChanged();
    void loadingChanged();

public slots:
    bool clear();

};

#endif // ABSTRACTMODEL_H
