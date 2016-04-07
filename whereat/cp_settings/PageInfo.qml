import QtQuick 2.4
import Ubuntu.Components 1.3

Page { id: page_info;

    header: PageHeader { id: header; contents: CustomHeader {subTitle: "About"; iconName: "info";} }

    Column {
        spacing: units.gu(4);
        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: units.gu(2);}

        UbuntuShape {
            anchors.horizontalCenter: parent.horizontalCenter;
            width: units.gu(18); height: units.gu(18); radius: "large";
            source: Image {source: "whereat.png";}
            aspect: UbuntuShape.Flat;
        }

        Column {
            width: parent.width

            Label {
                width: parent.width
                text: "<b>Where AT?</b> (" + app_version + ")"
                fontSize: "large"
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                width: parent.width
                text: app_description
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
        }

        Column {
            width: parent.width

            Label {
                text: "(C) 2015 Evan Lin <a href=\"mailto://evan.linjin@gmail.com\">evan.linjin@gmail.com</a>"
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                linkColor: "#00C2FF"
                fontSize: "small"
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                text: "Released under the terms of GNU GPL v3 or higher"
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                fontSize: "small"
            }
        }

        Label {
            text: ("Source code available on %1").arg("<a href=\"https://github.com/evanlinjin/whereat\">Github</a>")
            width: parent.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            linkColor: "#00C2FF"
            fontSize: "small"
            onLinkActivated: Qt.openUrlExternally(link)

        }
    }
}

