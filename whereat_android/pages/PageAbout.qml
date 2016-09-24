import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0


import "../components"
import "../listitems"
import "../js/appInfo.js" as INFO

Page { id: page;

    header: MainPageHeader { id: header;
        ln0: "About";
        titleIcon: "qrc:/icons/info.svg";
        menuIcon: "qrc:/icons/back.svg";
        actionNavMenu: function() {stack.pop();}
        currentIndex: 0;
        searchMode: false;
        showReload: false;
        showTabBar: false;
    }

    ListView { id: list;
        anchors.fill: parent;

        model: VisualItemModel {

            HeaderLI {text: "The App";}

            Item {
                width: parent.width - 40;
                height: 160
                anchors.horizontalCenter: parent.horizontalCenter
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.horizontalCenterOffset: -width/2;
                    width: parent.height; height: parent.height;
                    Image { id: iconImg;
                        anchors.fill: parent;
                        anchors.margins: 30;
                        source: "qrc:/whereat.png";
                    }
                    DropShadow {
                        anchors.fill: iconImg;
                        samples: 14
                        color: "#50000000"
                        source: iconImg;
                    }
                }
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.horizontalCenterOffset: width/2 - 15;
                    width: parent.height; height: parent.height;

                    Label {
                        anchors.centerIn: parent;
                        anchors.verticalCenterOffset: -15;
                        text: "<b>Where AT?</b>"
                        font.pixelSize: 18;
                    }
                    Label {
                        anchors.centerIn: parent;
                        anchors.verticalCenterOffset: 15;
                        text: INFO.version
                        font.pixelSize: 14;
                    }
                }
            }

            Column {
//                width: parent.width;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.leftMargin: 20;
                anchors.rightMargin: 20;
                spacing: 5;

                Label {
                    width: parent.width;
                    text: INFO.description
                    font.pixelSize: 14;
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Item {width: parent.width; height: 20;}

                Label {
                    text: "(C) 2016 Evan Lin <a href=\"mailto://evan.linjin@gmail.com\">evan.linjin@gmail.com</a>"
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    linkColor: "#00C2FF"
                    font.pixelSize: 12;
                    onLinkActivated: Qt.openUrlExternally(link)
                }

                Label {
                    text: "Released under the terms of GNU GPL v3 or higher"
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 12;
                }

                Item {width: parent.width; height: 20;}

                Label {
                    text: ("Source code available on %1").arg("<a href=\"https://github.com/evanlinjin/whereat\">Github</a>")
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    linkColor: "#00C2FF"
                    font.pixelSize: 12;
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }

            Item {width: parent.width; height: 40;}
            HeaderLI {text: "Icons by Freepik from Flaticon";}
            Item {width: parent.width; height: 40;}

            ListView {
                width: parent.width;
                height: 100;
                orientation: ListView.Horizontal;
                clip: true;
                model: ListModel {
                    ListElement {src: "airplane.svg"}
                    ListElement {src: "bike.svg"}
                    ListElement {src: "bus.svg"}
                    ListElement {src: "car.svg"}
                    ListElement {src: "ferry.svg"}
                    ListElement {src: "train.svg"}
                }
                delegate: Column {
                    height: 80;
                    width: 110;
                    spacing: 10;
                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 60; height: 60
                        source: "qrc:/icons/" + model.src;
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: model.src
                        font.pixelSize: 12
                    }
                }
                ScrollIndicator.horizontal: ScrollIndicator {active: true;}
            }

            Item {width: parent.width; height: 40;}
            HeaderLI {text: "Icons from Suru Icon Pack by Canonical";}
            Item {width: parent.width; height: 40;}

            ListView {
                width: parent.width;
                height: 100;
                orientation: ListView.Horizontal;
                clip: true;
                model: ListModel {
                    ListElement {src: "back.svg"}
                    ListElement {src: "clock.svg"}
                    ListElement {src: "info.svg"}
                    ListElement {src: "starred.svg"}
                    ListElement {src: "non-starred.svg"}
                    ListElement {src: "navigation-menu.svg"}
                    ListElement {src: "back.svg"}
                    ListElement {src: "reload.svg"}
                    ListElement {src: "find.svg"}
                    ListElement {src: "location.svg"}
                    ListElement {src: "swap.svg"}
                    ListElement {src: "settings.svg"}
                    ListElement {src: "tick.svg"}
                    ListElement {src: "security-alert.svg"}
                }
                delegate: Column {
                    height: 80;
                    width: 110;
                    spacing: 10;
                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 60; height: 60
                        source: "qrc:/icons/" + model.src;
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: model.src
                        font.pixelSize: 12
                    }
                }
                ScrollIndicator.horizontal: ScrollIndicator {active: true;}
            }

            Item {width: parent.width; height: 40;}
        }

        ScrollBar.vertical: ScrollBar {}
    }
}
