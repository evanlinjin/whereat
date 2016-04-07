import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

Row {
    id: main
    width: parent.width
    height: parent.height

    property string mainTitle: i18n.tr("Where AT?")
    property string subTitle: i18n.tr("Home")
    property string iconName: "stock_website"
    //property bool tickerTrigger: false

    Rectangle {
        width: height;
        height: parent.height;
        color: "transparent";

        Icon {
            id: icon
            height: units.gu(4)
            anchors.centerIn: parent
            name: iconName
            color: "#1E3D51"
        }
    }

    Rectangle {
        width: parent.width;
        height: parent.height;
        color: "transparent";

        Label {
            anchors.left: parent.left
            anchors.leftMargin: units.gu(1)
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -(subheading.height / 2)

            text: main.mainTitle
            fontSize: "medium"
            width: parent.width
            elide: Text.ElideRight

            Label {
                id: subheading
                anchors.top: parent.bottom
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "<b>" + subTitle + "</b>"
                fontSize: "x-small"
                width: parent.width
                elide: Text.ElideRight
            }
        }
    }
}
