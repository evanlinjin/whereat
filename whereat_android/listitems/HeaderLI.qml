import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias text: label.text;

    width: parent.width;
    height: 40;

    Label { id: label;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.left: parent.left;
        anchors.leftMargin: 20;
        anchors.rightMargin: 20;
        font.pixelSize: 14;
        font.weight: Font.Medium;
    }

    Rectangle {
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: 1;
        color: "whitesmoke";
    }
}
