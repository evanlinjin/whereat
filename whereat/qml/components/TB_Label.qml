import QtQuick 2.4
import Ubuntu.Components 1.3

Item { id: tb_label;

    property alias text: label.text;
    property alias bold: label.font.bold;
    property alias color: label.color;
    property alias fontSize: label.fontSize;
    property bool al_r: false;

    height: parent.height;
    width: units.gu(5);

    Label { id: label;
        anchors.fill: parent;
        text: "";
        verticalAlignment: Text.AlignVCenter;
        horizontalAlignment: al_r ? Text.AlignRight : Text.AlignLeft;
        elide: Text.ElideRight;
        maximumLineCount: 2;
        fontSize: tb_label.fontSize;
        font.bold: false;
    }
}
