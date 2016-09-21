import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ListView {
    anchors.fill: parent;

    delegate: Row {
        width: page.width;
        height: 50;
        spacing: 5;
        Item {width: 5;}
        Item {
            height: parent.height;
            width: parent.height;
            Image {
                source: model.type;
                anchors.fill: parent;
                anchors.margins: 10;
            }
        }
        Item {
            height: parent.height;
            width: parent.width - parent.height*2 - 20;
            Label {
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.verticalCenterOffset: -7.5;
                text: model.ln0;
                font.pixelSize: 12;
                font.weight: Font.Normal;
            }
            Label {
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.verticalCenterOffset: 7.5;
                text: model.ln1;
                font.pixelSize: 10;
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
                anchors.verticalCenterOffset: -9;
                text: "500m" //model.ln2;
                font.pixelSize: 10;
                font.weight: Font.Light;
            }
            Image {id: favourite_icon;
                anchors.right: parent.right;
                //anchors.bottom: parent.bottom;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.verticalCenterOffset: 7.5;
                width: 12;
                height: 12;
                source: model.fav ? "qrc:/android/icons/starred.svg" : "qrc:/android/icons/non-starred.svg";
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
}
