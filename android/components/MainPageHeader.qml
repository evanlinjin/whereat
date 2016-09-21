import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ToolBar { id: toolbar;
    property string ln0;
    property var actionNavMenu;
    property var actionReload;
    property var actionSearch;
    property bool searchMode: true;

    width: parent.width;
    background: Rectangle {
        //color: "white";
        gradient: Gradient {
            GradientStop {position: 0.0; color: "white";}
            GradientStop {position: 0.9; color: "white";}
            GradientStop {position: 1.0; color: "#00000000";}
        }
        anchors.fill: parent;
    }
    RowLayout {
        anchors.fill: parent;
        ToolbarButton {
            src: "qrc:/android/icons/navigation-menu.svg";
            onClicked: actionNavMenu();
        }

        Loader {
            height: parent.height - 10;
            Layout.fillWidth: true;
            sourceComponent: searchMode ? head1 : head0;
        }


        ToolbarButton {
            src: "qrc:/android/icons/reload.svg";
            onClicked: actionReload();
            visible: !searchMode;
        }
    }

    Component { id: head0;
        Label { id: title;
            text: ln0;
            font.pixelSize: 16;
        }
    }

    Component { id: head1;
        Row {
            anchors.fill: parent;
            spacing: 5;
            TextField { id: textField;
                width: parent.width - searchButton.width - spacing;
                placeholderText: qsTr("Enter query");
                onAccepted: actionSearch(text);
            }
            ToolbarButton { id: searchButton;
                src: "qrc:/android/icons/find.svg";
                onClicked: textField.accepted();
            }
        }
    }
}
