import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item { id: tb_label;

    property alias text: label.text;
    property alias bold: label.font.bold;
    property alias color: label.color;
    property alias fontSize: label.font.pixelSize;
    property bool al_r: false;

    height: parent.height;
    width: 60;

    Label { id: label;
        anchors.fill: parent;
        text: "";
        verticalAlignment: Text.AlignVCenter;
        horizontalAlignment: al_r ? Text.AlignRight : Text.AlignLeft;
        elide: Text.ElideRight;
        maximumLineCount: 2;
        font.pixelSize: 12;
        font.bold: false;
    }
}
