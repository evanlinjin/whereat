#include "whereat.h"

WhereAt::WhereAt(QObject *parent) : QObject(parent)
{
    listModel = new AbstractModel(this);
    favouritesModel = new StopModel(this);
}
