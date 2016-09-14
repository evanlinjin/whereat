import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as LI

ListItem { id: toggle_item;

    property string title;
    property string subtitle;
    property alias checked: toggle_switch.checked;
    property var trigger;

    divider.visible: false;
    ListItemLayout { id: layout;
        title.text: toggle_item.title;
        subtitle.text: toggle_item.subtitle;
        Switch { id: toggle_switch;
            SlotsLayout.position: SlotsLayout.Trailing;
            onTriggered: toggle_item.trigger();
        }
    }
    onClicked: toggle_switch.trigger();
}
