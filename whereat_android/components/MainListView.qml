import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "../listitems"

ListView { id: listView;
    property alias esText: emptyState.text;
    property string listItemType: "Stop";

    anchors.fill: parent;

    delegate: Rectangle {
        width: page.width;
        height: 65;
        color: mouseArea.pressed ?
                   "whitesmoke" :
                   menu.item_id === model.id ? "whitesmoke" : "transparent";
        Row {
            anchors.fill: parent;
            spacing: 5;
            Item {width: 5;}
            Item {
                height: parent.height;
                width: parent.height;
                Image {
                    source: model.type;
                    anchors.fill: parent;
                    anchors.margins: 16;
                }
            }
            Item {
                height: parent.height;
                width: parent.width - parent.height*2 - 25;
                Label {
                    anchors.left: parent.left;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.verticalCenterOffset: -10;
                    text: model.ln0;
                    font.pixelSize: 14;
                    font.weight: Font.Normal;
                }
                Label {
                    anchors.left: parent.left;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.verticalCenterOffset: 10;
                    text: model.ln1;
                    font.pixelSize: 12;
                    font.weight: Font.Light;
                }
            }
            Item { id: icon_container;
                width: parent.height;
                height: parent.height;
                Label {
                    anchors.right: parent.right;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.verticalCenterOffset: -12;
                    text: model.ln2;
                    font.pixelSize: 12;
                    font.weight: Font.Light;
                }
                Image {id: favourite_icon;
                    anchors.right: parent.right;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.verticalCenterOffset: 10;
                    width: 15;
                    height: 15;
                    source: model.fav ? "qrc:/icons/starred.svg" : "qrc:/icons/non-starred.svg";
                }
            }
        }

        MouseArea { id: mouseArea;
            anchors.fill: parent;
            onPressAndHold: {
                menu.item_id = model.id;
                menu.ln0 = model.ln0;
                menu.ln1 = model.ln1;
                menu.type = model.type;
                menu.fav = model.fav;
                menu.open();
            }
            onClicked: open0(model.id);
        }
    }

    MainSecondaryMenu { id: menu;
        y: parent.height/2 - menu.width/2 - 45;

        ColumnLayout {
            MainSecondaryMenuHeader {
                ln0: menu.ln0;
                ln1: menu.ln1;
                type: menu.type;
            }
            MenuItem {
                text: "Open " +  listItemType;
                onTriggered: {
                    open0(menu.item_id);
                    menu.close();
                }
            }
            MenuItem {
                text: menu.fav ? "Remove from Favourites" : "Add to Favourites";
                onTriggered: {
                    updateFavourite(menu.item_id, !menu.fav);
                    menu.close();
                }
            }
            MenuItem {
                text: "Close";
                onTriggered: {
                    menu.close();
                }
            }
        }

        onClosed: {item_id = "";}
    }

    ScrollBar.vertical: ScrollBar {}

    BusyIndicator { id: busyIndicator;
        running: model.loading && model.count === 0;
        anchors.centerIn: parent;

        Component.onCompleted: {
            model.endReload();
        }
    }

    Label { id: emptyState;
        anchors.centerIn: parent;
        font.pixelSize: 18;
        font.weight: Font.ExtraLight;
        text: "Starred";
        visible: !busyIndicator.running && !model.count;
    }

    // LOGIC >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    function updateFavourite(id,fav) {
        switch (listView.listItemType) {
        case "Stop": DbManager.updateSavedStopFavourite(id, fav); break;
        }
    }

    function open0(id) {
        switch (listView.listItemType) {
        case "Stop": stack.push(pageTimeboard, {id: id}, StackView.Immediate); break;
        }
    }
}
