import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0

import "pages"
import "components"

ApplicationWindow { id: main;

    visible: true;
    width: 480;
    height: 760;
    title: qsTr("Where AT?");

    property string accent: Settings.themeIndex ? "white" : "black";
    property string primary: Settings.themeIndex ? "black" : "white";
    property string select: Settings.themeIndex ? "dimgrey" : "lightgrey";
    Material.accent: Settings.themeIndex ? "white" : "black";
    Material.foreground: Settings.themeIndex ? "white" : "black";
    Material.theme: Settings.themeIndex ? Material.Dark : Material.Light;
    Material.primary: Material.Brown;
    property string primaryaccent: "white";

    StackView { id: stack;
        anchors.fill: parent;
        initialItem: pageHome;

        popEnter: Transition {
            XAnimator {
                from: -stack.width;
                to: 0;
                duration: 220
                easing.type: Easing.OutExpo
            }
        }

        popExit: Transition {
            XAnimator {
                from: 0;
                to: stack.width;
                duration: 220
                easing.type: Easing.OutSine
            }
        }

        pushEnter: Transition {
            XAnimator {
                from: stack.width;
                to: 0
                duration: 220
                easing.type: Easing.OutExpo
            }
        }

        pushExit: Transition {
            XAnimator {
                from: 0;
                to: -stack.width;
                duration: 220
                easing.type: Easing.OutSine
            }
        }

        replaceEnter: Transition {}
        replaceExit: Transition {}

        onDepthChanged: console.log("STACK DEPTH :", depth);
    }

    Component {id: pageHome; PageHome {} }
    Component {id: pageTimeboard; PageTimeboard {} }
    Component {id: pageSettings; PageSettings {} }
    Component {id: pageDbUpdate; PageDbUpdate {} }
    Component {id: pageAbout; PageAbout {} }

    NavigationMenu {id: mainMenu;
        width: 0.66 * main.width
        height: main.height;
    }
}
