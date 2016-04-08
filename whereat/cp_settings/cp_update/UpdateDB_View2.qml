import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Column {
    spacing: units.gu(1);

    Button { id: b1;
        text: "Close";
        onClicked: PopupUtils.close(dialogue);
        width: parent.width;
    }
}
