import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

TabButton {
    property alias src: image.source;
    property alias color: overlay.color;
    //text
    height: parent.height;
    background: Rectangle { id: backGrd;
        color: pressed ? "whitesmoke" : "white";
        anchors.fill: parent;
    }
    Image { id: image;
        source: "qrc:/icons/location.svg";
        //anchors.left: parent.left;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        anchors.margins: 10;
        width: height;
        mipmap: true;
        smooth: true;
    }
    ColorOverlay { id: overlay;
        anchors.fill: image;
        source: image;
        color: checked ? "black" : "dimgrey";
    }
    Rectangle {
        width: parent.width;
        height: 3;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottom: parent.bottom;
        color: checked ? "black" : "white";
    }
}
