import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Rectangle { id: switchLi;
    property alias text: label.text;
    property alias checked: toggle.checked;
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
            opacity: switchLi.enabled ? 1 : 0.3;
        }

        Item {
            height: parent.height;
            width: parent.width - label.width;

            Switch { id: toggle;
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter;
            }
        }
    }

    MouseArea { id: mouseArea;
        anchors.fill: parent;
        onClicked: {toggle.toggle(); trigger();}
    }
}
