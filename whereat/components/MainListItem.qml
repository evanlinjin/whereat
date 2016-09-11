import QtQuick 2.4
import Ubuntu.Components 1.3

ListItem {
    NumberAnimation on opacity {from: 0; to: 1; duration: 200;}
    divider.visible: false
    height: units.gu(8)
    ListItemLayout {
        anchors.fill: parent
        title.text: model.ln0;
        subtitle.text: model.ln1 + " " + model.ln2;
    }
}
