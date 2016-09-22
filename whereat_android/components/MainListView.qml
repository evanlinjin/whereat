import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ListView { id: listView;
    property alias esText: emptyState.text;
    property string listItemType: "Stop";

    anchors.fill: parent;

    delegate: Rectangle {
        width: page.width;
        height: 65;
        color: mouseArea.pressed ? "whitesmoke" : "transparent";
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
                menu.x = mouse.x;
                menu.y = mouse.y;
                menu.open();
            }
        }

        Menu { id: menu;
            MenuItem {
                text: "Open " +  listItemType + " (" + model.ln0 + ")";
                onTriggered: open0(model.id);
            }
            MenuItem {
                text: model.fav ? "Remove from Favourites" : "Add to Favourites";
                onTriggered: updateFavourite(model.id, !model.fav);
            }
            MenuItem {
                text: listItemType + " Information";
            }
        }
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
        case "Stop": break;
        }
    }

    //    SwipeView.isCurrentItem;
//    onFocusChanged: {
//        if (SwipeView.isCurrentItem === true) {
//            switch (swipeView.currentIndex) {
//            case 0: FavouriteStopsModel.reload(); break;
//            case 1: NearbyStopsModel.update(); break;
//            case 2: break;
//            }
//        }
//    }
}
