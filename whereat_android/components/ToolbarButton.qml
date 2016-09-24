import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

ToolButton {
    property alias src: image.source;
    property alias color: overlay.color;
    width: height*2/3;
    Image { id: image;
        source: "qrc:/icons/navigation-menu.svg";
//        anchors.fill: parent;
//        anchors.margins: 15;
        anchors.centerIn: parent;
        height: 20;
        width: 20;
        mipmap: true;
        smooth: true;
    }
    ColorOverlay { id: overlay;
        anchors.fill: image;
        source: image;
        color: primaryaccent;
    }
}
