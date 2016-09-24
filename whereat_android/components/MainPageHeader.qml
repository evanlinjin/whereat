import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

ToolBar { id: toolbar;
    property string ln0;
    property var actionNavMenu;
    property var actionReload;
    property var actionSearch;
    property bool searchMode: true;
    property bool showReload: true;
    property alias currentIndex: tabBar.currentIndex;
    property bool showTabBar: true;
    property alias menuIcon: menuButton.src;
    property bool showShadow: true;
    property alias titleIcon: titleIconImg.source;
    property alias showTitleIconOverlay: overlay.visible;
    property alias showTitleIcon: iconItem.visible;
    property string query: "";

    width: parent.width;
    height: row0.height + tabBar.height;
    background: Rectangle {id: rect;
        color: "white";
        anchors.fill: parent;
    }

    DropShadow {
        anchors.fill: parent;
        samples: 14
        color: "#50000000"
        source: rect;
        visible: showShadow;
    }

    Column {
        anchors.fill: parent;
        RowLayout { id: row0;
            width: parent.width;
            height: showTabBar ? 50 : 55;
            anchors.left: parent.left;
            anchors.right: parent.right;
            Item {width: 5;}
            ToolbarButton { id: menuButton;
                src: "qrc:/icons/navigation-menu.svg";
                onClicked: actionNavMenu();
            }
            //Item {width: 5; visible: !iconItem.visible;}
            Item { id: iconItem;
                height: 50;
                width: 50;
                Image { id: titleIconImg;
                    height: 30;
                    width: 30;
                    anchors.centerIn: parent;
                    anchors.horizontalCenterOffset: -5;
                    mipmap: true;
                    smooth: true;
                }
                ColorOverlay { id: overlay;
                    Component.onCompleted: {
                        source = titleIconImg;
                        anchors.fill = titleIconImg;
                        color = "black";
                    }
                }
            }
            Loader {
                height: parent.height - 10;
                Layout.fillWidth: true;
                sourceComponent: searchMode ? head1 : head0;
            }
            Item {width: 5;}
            ToolbarButton {
                src: "qrc:/icons/reload.svg";
                onClicked: actionReload();
                visible: !searchMode && showReload;
            }
            Item {width: 5;}
        }
        TabBar { id: tabBar;
            width: parent.width;
            height: showTabBar ? 40 : 0;
            visible: showTabBar;
            currentIndex: 0;
            background: Rectangle {
                color: "white";
                anchors.fill: parent;
            }
            MainTabButton {src: "qrc:/icons/starred.svg";}
            MainTabButton {src: "qrc:/icons/location.svg";}
            MainTabButton {src: "qrc:/icons/find.svg";}
        }
    }

    Component { id: head0;
        Label { id: title;
            text: ln0;
            font.pixelSize: 18;
            color: "black";
        }
    }

    Component { id: head1;
        Row {
            anchors.fill: parent;
            //spacing: 5;
            TextField { id: textField;
                width: parent.width - spacing;
                height: 35
                placeholderText: qsTr("Enter query");
                onAccepted: {
                    actionSearch(text);
                    query = text;
                }
                color: "black";

                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 40
                    color: "transparent";
                    border.color: "lightgrey";
                    border.width: 0.5;
                    radius: 2.5;
                }

                Component.onCompleted: textField.forceActiveFocus();
            }
        }
    }
}
