import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.0

ToolBar { id: toolbar;
    property string ln0;
    property var actionNavMenu;
    property var actionReload;
    property bool showReload: true;
    property alias currentIndex: tabBar.currentIndex;
    property bool showTabBar: true;
    property alias menuIcon: menuButton.src;
    property bool showShadow: true;
    property alias titleIcon: titleIconImg.source;
    property alias showTitleIconOverlay: overlay.visible;
    property alias showTitleIcon: iconItem.visible;

    width: parent.width;
    height: row0.height + tabBar.height;

    Column {
        anchors.fill: parent;
        RowLayout { id: row0;
            width: parent.width;
            height: showTabBar ? 50 : 55;
            anchors.left: parent.left;
            anchors.right: parent.right;
            spacing: 0;
            Item {width: 5;}
            ToolbarButton { id: menuButton;
                src: "qrc:/icons/navigation-menu.svg";
                onClicked: actionNavMenu();
            }
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
                    source: titleIconImg;
                    anchors.fill: titleIconImg;
                    color: primaryaccent;
                }
            }
            Label {
                height: parent.height - 10;
                Layout.fillWidth: true;
                text: ln0;
                font.pixelSize: 18;
                color: primaryaccent;

            }
            Item {width: 5;}
            ToolbarButton {
                src: "qrc:/icons/reload.svg";
                onClicked: actionReload();
                visible: showReload;
            }
            Item {width: 5;}
        }
        TabBar { id: tabBar;
            width: parent.width;
            height: showTabBar ? 40 : 0;
            visible: showTabBar;
            currentIndex: 0;
            background: Rectangle {
                color: "transparent"
                anchors.fill: parent;
            }
            MainTabButton {src: "qrc:/icons/starred.svg";}
            MainTabButton {src: "qrc:/icons/location.svg";}
            MainTabButton {src: "qrc:/icons/find.svg";}
            Material.accent: primaryaccent;
        }
    }
}
