import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.Components.Popups 1.3

Component { id: popover_component;
    Popover { id: popover;
        Column { id: layout_container;
            anchors {left: parent.left; right: parent.right; top: parent.top;}
            ListItem.Header { text: "Pages" }
            ListItem.Standard { text: "Timeboards" }
            ListItem.Standard { text: "Journey Planner" }
            ListItem.Standard { text: "AT Hop Card" }
            ListItem.Standard { text: "Service Announcements" }
        }
    }
}
