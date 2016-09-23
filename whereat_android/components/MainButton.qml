import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Button {
    //anchors.horizontalCenter: parent.horizontalCenter;
    //text: "Begin Update";
    font.pixelSize: 14;
    //onClicked: begin_update();
    property alias buttonColor: text.color;

    contentItem: Text { id: text;
        text: parent.text
        font: parent.font
        opacity: parent.pressed ? 0.3 : 1.0;
        color: "black";
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle { id: buttonBg;
        implicitWidth: 120
        implicitHeight: 40
        opacity: text.opacity;
        border.color: text.color;
        color: "transparent";
        border.width: 1
        radius: 2.5;
    }
}
