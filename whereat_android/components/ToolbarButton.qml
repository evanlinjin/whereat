import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

ToolButton {
    property alias src: image.source;
    property alias color: overlay.color;
    Image { id: image;
        source: "qrc:/icons/navigation-menu.svg";
        anchors.fill: parent;
        anchors.margins: 10;
        mipmap: true;
        smooth: true;
    }
    ColorOverlay { id: overlay;
        anchors.fill: image;
        source: image;
        color: "black";
    }
}
