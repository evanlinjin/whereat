import QtQuick 2.4
import Ubuntu.Components 1.3

ListItem { id: item;

    property string title;
    property string subtitle;
    property alias showTrailer: trailer.visible;
    property var trigger;

    divider.visible: false;
    ListItemLayout {
        title.text: item.title;
        subtitle.text: item.subtitle;
        Icon { id: trailer;
            visible: true;
            SlotsLayout.position: SlotsLayout.Trailing;
            name: "next";
            width: units.gu(3);
        }
    }
    onClicked: item.trigger();
}
