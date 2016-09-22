import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ListView {
    property alias esText: emptyState.text;

    anchors.fill: parent;

    delegate: Row {
        width: page.width;
        height: 65;
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
                //anchors.top: parent.top;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.verticalCenterOffset: -12;
                text: model.ln2;
                font.pixelSize: 12;
                font.weight: Font.Light;
            }
            Image {id: favourite_icon;
                anchors.right: parent.right;
                //anchors.bottom: parent.bottom;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.verticalCenterOffset: 10;
                width: 15;
                height: 15;
                source: model.fav ? "qrc:/icons/starred.svg" : "qrc:/icons/non-starred.svg";
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
        font.pixelSize: 24;
        font.weight: Font.ExtraLight;
        text: "Starred";
        visible: !busyIndicator.running && !model.count;
    }
}
