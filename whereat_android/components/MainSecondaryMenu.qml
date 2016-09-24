import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Popup { id: menu;

    property string item_id: "";
    property string ln0: "";
    property string ln1: "";
    property string type: "";
    property bool fav: false;

    x: parent.width/2 - menu.width/2;
    y: parent.height/2 - menu.width/2;

    closePolicy: Popup.CloseOnEscape |
                 Popup.CloseOnReleaseOutside
    modal: true;
}
