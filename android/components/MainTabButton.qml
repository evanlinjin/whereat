import QtQuick 2.7
import QtQuick.Controls 2.0

TabButton {
    property alias src: image.source;
    text: qsTr("Nearby");
    Image { id: image;
        source: "qrc:/android/icons/location.svg";
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        anchors.margins: 10;
        width: height;
        mipmap: true;
        smooth: true;
    }
}
