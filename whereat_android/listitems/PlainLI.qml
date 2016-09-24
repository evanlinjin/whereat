import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Rectangle { id: switchLi;
    property alias text: label.text;
    property var trigger;

    width: parent.width;
    height: 65;
    color: mouseArea.pressed ? main.select : "transparent";

    Row {
        anchors.fill: parent;
        anchors.rightMargin: 20;
        anchors.leftMargin: 20;

        Label { id: label;
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: 14;
            font.weight: Font.Normal;
        }

        Item {
            height: parent.height;
            width: parent.width - label.width;

            Image { id: image;
                source: "qrc:/icons/next.svg";
                anchors.verticalCenter: parent.verticalCenter;
                anchors.right: parent.right;
                width: height;
                height: 20;
                mipmap: true;
                smooth: true;
            }
        }
    }

    MouseArea { id: mouseArea;
        anchors.fill: parent;
        onClicked: trigger();
    }
}
