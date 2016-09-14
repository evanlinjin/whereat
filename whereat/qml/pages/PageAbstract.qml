import QtQuick 2.4
import Ubuntu.Components 1.3
import "../components"

Page {
    NumberAnimation on opacity {
        from: 0;
        to: 1;
        duration: UbuntuAnimation.SlowDuration;
    }
}
