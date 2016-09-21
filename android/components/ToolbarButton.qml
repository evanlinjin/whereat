import QtQuick 2.7
import QtQuick.Controls 2.0

ToolButton {
    property alias src: image.source;
    Image { id: image;
        source: "qrc:/android/icons/navigation-menu.svg";
        anchors.fill: parent;
        anchors.margins: 10;
    }
}
