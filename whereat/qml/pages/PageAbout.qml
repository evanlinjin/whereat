import QtQuick 2.4
import Ubuntu.Components 1.3
import "../components"
import "../components/listItems"
import "../../js/appInfo.js" as INFO

PageAbstract { id: page;
    header: MainHeader { id: header;
        ln0: "About";
        iconName: "info";
        leftbutton: Action {iconName: "back"; onTriggered: apl.removePages(page);}
    }

    Flickable { id: flickable;

        NumberAnimation on opacity {from: 0; to: 1; duration: 500;}
        NumberAnimation on opacity {from: 1; to: 0; duration: 500;}

        width: page.width; height: page.height - header.height; anchors.top: header.bottom;
        contentHeight: aboutapp_item.height; contentWidth: parent.width;


        Column { id: aboutapp_item;
            width: units.gu(40);
            spacing: units.gu(4);
            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: units.gu(3);}

            Item {
                width: units.gu(40);
                height: units.gu(5);
                anchors.horizontalCenter: parent.horizontalCenter;
                HeaderLI {text: "The App";}
            }

            Item {
                width: units.gu(40);
                anchors.horizontalCenter: parent.horizontalCenter;
                height: units.gu(12);
                UbuntuShape {
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.horizontalCenterOffset: units.gu(-8);
                    width: units.gu(12); height: units.gu(12); radius: "large";
                    source: Image {source: "qrc:/whereat.png";}
                    aspect: UbuntuShape.Flat;
                }

                Column {
                    width: parent.width;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.horizontalCenterOffset: units.gu(8);
                    anchors.verticalCenter: parent.verticalCenter;
                    spacing: units.gu(1);
                    Label {
                        width: parent.width
                        text: "<b>Where AT?</b>"
                        fontSize: "large"
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        width: parent.width
                        text: INFO.version
                        fontSize: "large"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            Column {
                anchors.horizontalCenter: parent.horizontalCenter;
                width: units.gu(40);
                spacing: units.gu(1);

                Label {
                    width: parent.width
                    text: INFO.description
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
            }

            Column {
                width: parent.width

                Label {
                    text: "(C) 2016 Evan Lin <a href=\"mailto://evan.linjin@gmail.com\">evan.linjin@gmail.com</a>"
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
                text: ("Source code available on %1").arg("<a href=\"https://github.com/evanlinjin/whereat2\">Github</a>")
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                linkColor: "#00C2FF"
                fontSize: "small"
                onLinkActivated: Qt.openUrlExternally(link)
            }



            Item {
                width: units.gu(40);
                height: units.gu(5);
                anchors.horizontalCenter: parent.horizontalCenter;
                HeaderLI {text: "Icons";}
            }

            ListItem {
                width: units.gu(40);
                anchors.horizontalCenter: parent.horizontalCenter;
                divider.visible: false;
                ListItemLayout {
                    title.text: "bus.svg";
                    subtitle.text: "Designed by " + author_icon_name + " from Flaticon";
                    Icon {SlotsLayout.position: SlotsLayout.Leading; source: "qrc:/icons/" + parent.title.text; width: units.gu(6);}
                }
            }

            ListItem {
                width: units.gu(40);
                anchors.horizontalCenter: parent.horizontalCenter;
                divider.visible: false;
                ListItemLayout {
                    title.text: "ferry.svg";
                    subtitle.text: "Designed by " + author_icon_name + " from Flaticon";
                    Icon {SlotsLayout.position: SlotsLayout.Leading; source: "qrc:/icons/" + parent.title.text; width: units.gu(6);}
                }
            }

            ListItem {
                width: units.gu(40);
                anchors.horizontalCenter: parent.horizontalCenter;
                divider.visible: false;
                ListItemLayout {
                    title.text: "train.svg";
                    subtitle.text: "Designed by " + author_icon_name + " from Flaticon";
                    Icon {SlotsLayout.position: SlotsLayout.Leading; source: "qrc:/icons/" + parent.title.text; width: units.gu(6);}
                }
            }

            ListItem {
                width: units.gu(40);
                anchors.horizontalCenter: parent.horizontalCenter;
                divider.visible: false;
                ListItemLayout {
                    title.text: "airplane.svg";
                    subtitle.text: "Designed by " + author_icon_name + " from Flaticon";
                    Icon {SlotsLayout.position: SlotsLayout.Leading; source: "qrc:/icons/" + parent.title.text; width: units.gu(6);}
                }
            }

            ListItem {
                width: units.gu(40);
                anchors.horizontalCenter: parent.horizontalCenter;
                divider.visible: false;
                ListItemLayout {
                    title.text: "bike.svg";
                    subtitle.text: "Designed by " + author_icon_name + " from Flaticon";
                    Icon {SlotsLayout.position: SlotsLayout.Leading; source: "qrc:/icons/" + parent.title.text; width: units.gu(6);}
                }
            }

            ListItem {
                width: units.gu(40);
                anchors.horizontalCenter: parent.horizontalCenter;
                divider.visible: false;
                ListItemLayout {
                    title.text: "car.svg";
                    subtitle.text: "Designed by " + author_icon_name + " from Flaticon";
                    Icon {SlotsLayout.position: SlotsLayout.Leading; source: "qrc:/icons/" + parent.title.text; width: units.gu(6);}
                }
            }

            ListItem {
                width: units.gu(40);
                anchors.horizontalCenter: parent.horizontalCenter;
                divider.visible: false;
                ListItemLayout {
                    title.text: "AT.png";
                    subtitle.text: "Icon by Auckland Transport";
                    Icon {SlotsLayout.position: SlotsLayout.Leading; source: "qrc:/icons/" + parent.title.text; width: units.gu(6);}
                }
            }


            Item {height: units.gu(2); width: parent.width;}
        }
    }

    Scrollbar {flickableItem: flickable;}

    property string author_icon_name: "Freepik";
}
