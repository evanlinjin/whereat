import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "pages"

ApplicationWindow {
    visible: true;
    width: 480;
    height: 640;
    title: qsTr("Where AT?");

    StackView { id: stack;
        anchors.fill: parent;
        initialItem: pageHome;
    }

    Component {id: pageHome; PageHome {}}

}
