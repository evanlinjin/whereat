import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

TabButton {
    property alias src: image.source;
    property alias color: overlay.color;
    height: parent.height;
    Image { id: image;
        source: "qrc:/icons/location.svg";
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        anchors.margins: 10;
        width: height;
        mipmap: true;
        smooth: true;
        opacity: checked ? 1 : 0.3;
    }
    ColorOverlay { id: overlay;
        anchors.fill: image;
        source: image;
        color: primaryaccent;
        opacity: image.opacity;
    }
}
