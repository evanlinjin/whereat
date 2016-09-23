import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Row { id: row;
    property alias ln0: menuLabel1.text;
    property alias ln1: menuLabel2.text;
    property alias type: img.source;
    width: parent.width;
    height: 65;
    spacing: 5;
    Item {
        height: parent.height;
        width: parent.height;
        Image { id: img;
            anchors.fill: parent;
            anchors.margins: 16;
        }
    }
    Item {
        height: parent.height;
        width: menuLabel2.width;
        Label { id: menuLabel1;
            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.verticalCenterOffset: -10;
            font.pixelSize: 14;
            font.weight: Font.Normal;
        }
        Label { id: menuLabel2;
            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.verticalCenterOffset: 10;
            font.pixelSize: 12;
            font.weight: Font.Light;
        }
    }
    Item {width: 10; height: 5;}
}
