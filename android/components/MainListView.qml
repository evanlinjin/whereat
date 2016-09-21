import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ListView {
    anchors.fill: parent;
    anchors.leftMargin: 5;
    anchors.rightMargin: 5;

    delegate: Row {
        width: page.width;
        height: 50;
        spacing: 5;
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
            width: parent.width - parent.height*2;
            Label {
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.verticalCenterOffset: -7.5;
                text: model.ln0;
                font.pixelSize: 12;
            }
            Label {
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.verticalCenterOffset: 7.5;
                text: model.ln1;
                font.pixelSize: 10;
            }
        }

    }
}
