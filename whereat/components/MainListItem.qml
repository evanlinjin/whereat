import QtQuick 2.4
import Ubuntu.Components 1.3
import "../"

ListItem {
    NumberAnimation on opacity {from: 0; to: 1; duration: 200;}
    divider.visible: false
    height: units.gu(8)

    ListItemLayout {
        anchors.fill: parent
        title.text: model.ln0;
        subtitle.text: model.ln1;

        Icon {
            SlotsLayout.position: SlotsLayout.Leading;
            width: height; height: units.gu(4);
            //source: model.type;
            source: "bus.svg";
        }

        Item { id: icon_container;
            SlotsLayout.position: SlotsLayout.Trailing;
            width: units.gu(2.5); height: units.gu(4.5);
            anchors.verticalCenter: parent.verticalCenter;
            Label {
                anchors.right: parent.right;
                anchors.top: parent.top;
                text: model.ln2;
                textSize: Label.Small;
            }
            Icon {id: favourite_icon;
                anchors.right: parent.right;
                anchors.bottom: parent.bottom;
                width: units.gu(2);
                name: model.fav ? "starred" : "non-starred";
            }

        }
    }
}
