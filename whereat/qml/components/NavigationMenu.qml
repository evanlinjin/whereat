import QtQuick 2.4
import Ubuntu.Components 1.3
import QtGraphicalEffects 1.0

Item { id: mainMenu;

    property int pageHeight;
    property int pageWidth;
    property int gap;

    anchors.left: parent.left;
    anchors.top:parent.top;
    z: parent.z + 100;

    MouseArea {
        anchors.fill: parent;
        onClicked: mainMenu.close();
    }

    Rectangle { id: menuRectangle;
        height: parent.height*3/5;
        width: parent.width*4/5;
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.topMargin: gap;
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

//    Rectangle { id: shadowTop;
//        width: menuRectangle.width;
//        height: units.gu(0.75);
//        opacity: Settings.themeIndex === 0 ? 0.1 : 0.6;
//        anchors {bottom: menuRectangle.top; left: parent.left;}
//        gradient: Gradient {
//            GradientStop {position: 0.0; color: "#00000000";}
//            GradientStop {position: 1.0; color: "black";}
//        }
//    }

    Rectangle { id: shadowRight;
        width: menuRectangle.height;
        height: units.gu(0.75);
        opacity: Settings.themeIndex === 0 ? 0.1 : 0.6;
        anchors {
            left: menuRectangle.right;
            leftMargin: units.gu(0.75);
            top: menuRectangle.top;
        }
        gradient: Gradient {
            GradientStop {position: 0.0; color: "#00000000";}
            GradientStop {position: 1.0; color: "black";}
        }
        transform: Rotation {
            origin.x: shadowRight.horizontalCenter;
            origin.y: shadowRight.verticalCenter;
            angle: 90;
        }
    }

    function close() {
        state = "closed";
        header.hide_tabbar = false;
    }
    function toggle() {state = (state == "open" ? "closed" : "open");}

    state: "closed";
    states: [
        State {
            name: "open"
            PropertyChanges {
                target: mainMenu;
                width: pageWidth;
                height: pageHeight;
                opacity: 1;
            }
        },
        State {
            name: "closed"
            PropertyChanges {
                target: mainMenu;
                width: pageWidth;
                height: 0;
                opacity: 0;
            }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation {
                properties: "width,height,opacity";
                duration: 150;
            }
        }
    ]
}
