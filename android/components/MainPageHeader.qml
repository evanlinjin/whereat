import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ToolBar { id: toolbar;
    property alias ln0: title.text;
    property var actionNavMenu;
    property var actionReload;

    width: parent.width;
    background: Rectangle {color: "white"; anchors.fill: parent;}
    RowLayout {
        anchors.fill: parent;
        ToolbarButton {
            src: "qrc:/android/icons/navigation-menu.svg";
            onClicked: actionNavMenu();
        }
        Item {
            height: parent.height;
            Layout.fillWidth: true;

            Label { id: title;
                text: qsTr("Where AT?");
                font.pixelSize: 16;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: parent.left;
                anchors.rightMargin: 5;
            }
        }

        ToolbarButton {
            src: "qrc:/android/icons/reload.svg";
            onClicked: actionReload();
        }
    }
}
