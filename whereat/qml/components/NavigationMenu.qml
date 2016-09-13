import QtQuick 2.4
import Ubuntu.Components 1.3
import QtGraphicalEffects 1.0

Item { id: mainMenu;

    property int pageHeight;
    property int pageWidth;

    anchors.left: parent.left;
    anchors.top:parent.top;
    width: pageWidth;
    z: parent.z + 100;

    MouseArea {
        anchors.fill: parent;
        onClicked: mainMenu.close();
    }

    Rectangle { id: titleRectangle;
        height: units.gu(6);
        width: parent.width - units.gu(5);
        anchors.top: parent.top;
        anchors.right: parent.right;
        Row {
            anchors.fill: parent;
            spacing: units.gu(1);
            Item { width: height; height: parent.height;
                UbuntuShape {
                    anchors.centerIn: parent;
                    width: units.gu(4); height: units.gu(4); radius: "large";
                    source: Image {source: "qrc:/whereat.png";}
                    aspect: UbuntuShape.Flat;
                    color: theme.palette.normal.backgroundText;
                }
            }
            Label {
                anchors.verticalCenter: parent.verticalCenter;
                text: "Where AT?";
                fontSize: "large";
                width: parent.width;
                elide: Text.ElideRight;
                color: theme.palette.normal.backgroundText;
            }
        }
    }

    Rectangle { id: menuRectangle;
        height: parent.height*3/5;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.top;
        anchors.topMargin: units.gu(6);
        color: theme.palette.normal.background;
    }

    Rectangle { id: shadowBottom;
        width: menuRectangle.width;
        height: units.gu(0.75);
        opacity: Settings.themeIndex === 0 ? 0.1 : 0.6;
        anchors {top: menuRectangle.bottom; left: parent.left;}
        gradient: Gradient {
            GradientStop {position: 0.0; color: "black";}
            GradientStop {position: 1.0; color: "#00000000";}
        }
    }

    function close() {state = "closed";}
    function toggle() {state = (state == "open" ? "closed" : "open");}

    state: "closed";
    states: [
        State {
            name: "open"
            PropertyChanges {
                target: mainMenu;
                height: pageHeight;
                opacity: 1;
            }
        },
        State {
            name: "closed"
            PropertyChanges {
                target: mainMenu;
                height: 0;
                opacity: 0;
            }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation {properties: "height"; duration: 150;}
            NumberAnimation {properties: "opacity"; duration: 100;}
        }
    ]
}
