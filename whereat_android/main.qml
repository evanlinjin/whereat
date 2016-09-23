import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "pages"
import "components"

ApplicationWindow { id: main;
    visible: true;
    width: 480;
    height: 760;
    title: qsTr("Where AT?");

    StackView { id: stack;
        anchors.fill: parent;
        initialItem: pageHome;
    }

    Component {id: pageHome; PageHome {}}
    Component {id: pageSettings; PageSettings {}}
    Component {id: pageDbUpdate; PageDbUpdate {}}

    NavigationMenu {id: mainMenu;
        width: 0.66 * main.width
        height: main.height;
    }
}
