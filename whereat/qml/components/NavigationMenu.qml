import QtQuick 2.4
import Ubuntu.Components 1.3
import QtGraphicalEffects 1.0

Item { id: mainMenu;

    property int pageHeight;
    property int pageWidth;

    anchors.left: parent.left;
    anchors.top:parent.top;
    height: pageHeight;
    width: pageWidth;

    MouseArea {
        anchors.fill: parent;
        onClicked: mainMenu.close();
    }

    Rectangle { id: titleRectangle;
        height: units.gu(6);
        anchors.top: parent.top;
        anchors.left: menuRectangle.left;
        anchors.right: menuRectangle.right;
        anchors.leftMargin: units.gu(6);
        color: theme.palette.normal.background;

        Label {
            anchors.verticalCenter: parent.verticalCenter;
            text: "Where AT?";
            fontSize: "large";
            width: parent.width;
            elide: Text.ElideRight;
            color: theme.palette.normal.backgroundText;
        }
    }

    Rectangle { id: menuRectangle;
        height: listView.count * units.gu(7) + units.gu(2);
        width: units.gu(25);
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.topMargin: units.gu(6);
        color: theme.palette.normal.background;

        ListView { id: listView
            anchors.fill: parent;
            clip: true;
            delegate: ListItem {
                height: units.gu(7);
                divider.visible: false;
                ListItemLayout {
                    anchors.fill: parent
                    title.text: model.text;
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading;
                        color: theme.palette.normal.backgroundText;
                        width: units.gu(3); height: units.gu(3);
                        name: model.icon;
                    }
                }
                onClicked: {close(); listModel.actions[model.i]();}
            }

            model: ListModel { id: listModel
                ListElement {i: 0; text: "Stops"; icon: "clock-app-symbolic";}
                ListElement {i: 1; text: "Journey Planner"; icon: "swap";}
                ListElement {i: 2; text: "Settings"; icon: "settings";}
                ListElement {i: 3; text: "About"; icon: "info";}
                property var actions: {
                    0: function() {apl.primaryPageSource = pageHome;},
                    1: function() {apl.primaryPageSource = pageHome;},
                    2: function() {apl.primaryPageSource = pageSettings;},
                    3: function() {apl.primaryPageSource = pageHome;}
                }
            }
        }
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

    Rectangle { id: shadowRight;
        width: menuRectangle.height + units.gu(6);
        height: units.gu(0.75);
        opacity: Settings.themeIndex === 0 ? 0.1 : 0.6;
        anchors {
            top: parent.top;
            left: menuRectangle.right;
            leftMargin: units.gu(0.75);
        }
        gradient: Gradient {
            GradientStop {position: 0.0; color: "#00000000";}
            GradientStop {position: 1.0; color: "black";}
        }
        transform: Rotation {angle: 90;}
    }

    function close() {state = "closed";}
    function toggle() {state = (state == "open" ? "closed" : "open");}

    state: "closed";
    states: [
        State {name: "open";},
        State {
            name: "closed";
            PropertyChanges {target: mainMenu; width: 0;}
            PropertyChanges {target: menuRectangle; width: 0;}
            PropertyChanges {target: shadowRight; opacity: 0;}
            PropertyChanges {target: shadowBottom; opacity: 0;}
        }
    ]
    transitions: [
        Transition {
            NumberAnimation {properties: "width, opacity"; duration: UbuntuAnimation.FastDuration;}
        }
    ]
}
