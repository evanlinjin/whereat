import QtQuick 2.4
import Ubuntu.Components 1.3

PageHeader { id: header;

    // PUBLIC API >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    property string ln0: "Where AT?";
    property string ln1: "Where AT?";
    property alias iconName: icon.name;
    property alias iconSource: icon.source;
    property color foregroundColor: theme.palette.normal.backgroundText;
    property color backgroundColor: theme.palette.normal.background;

    property list<Action> tabbar;
    property alias tabbar_currentIndex: sections.selectedIndex;
    property list<Action> leftbutton;
    property bool hide_tabbar: false;

    property list<Action> topbar;

    property list<Row> headerModeList;
    property int headerMode: 0; // 0:NORMAL, 1:SEARCH, 2:SELECT, 3: RADIUS
    property bool dual_heading: false;

    property string searchPlaceholderText;
    property string searchQuery;
    signal searchAccepted(string query);

    // HEADER STYLING >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    StyleHints { id: style;
        foregroundColor: header.foregroundColor;
        backgroundColor: header.backgroundColor;
        dividerColor: header.backgroundColor;
    }

    contents: headerModeList;

    extension: Sections { id: sections;
        actions: tabbar;

        height: hide_tabbar ? 0 : units.gu(4);
        StyleHints {
            underlineColor: header.backgroundColor;
            selectedSectionColor: header.foregroundColor;
        }
    }

    trailingActionBar.actions: topbar;
    leadingActionBar.actions: leftbutton;

    // HEADER CONTENTS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    Row { id:headerModeList;
        anchors.fill: parent;
        Item { width: height; height: parent.height;
            Icon { id: icon;
                height: units.gu(4);
                anchors.centerIn: parent;
                color: foregroundColor; //"#1E3D51"
            }
        }
        Loader { width: parent.width - units.gu(6); height: parent.height;
            sourceComponent: switch(headerMode) {
                             case 1: return head1_search;
                             default: return dual_heading ? head1 : head2;
                             }
        }

        Component { id: head1;
            ListItem {
                //width: parent.width; height: parent.height;
                anchors.centerIn: parent;
                divider.visible: false;
                color: backgroundColor;

                ListItemLayout { id: lil;
                    anchors.centerIn: parent;
                    anchors.horizontalCenterOffset: units.gu(-1);
                    title.text: ln0;
                    subtitle.text: ln1;
                }
            }
        }

        Component { id: head2;
            Item {//width: parent.width; height: parent.height;
                Label { //visible: dual_heading;
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(1)
                    anchors.verticalCenter: parent.verticalCenter
                    text: ln0;
                    fontSize: "large";
                    width: parent.width;
                    elide: Text.ElideRight;
                    color: foregroundColor;
                }
            }
        }

        Component { id: head1_search;
            Item {
                TextField {  id: text_field
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(1)
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width; //height: units.gu(3.5);
                    placeholderText: searchPlaceholderText;
                    text: searchQuery;
                    onTextChanged: searchQuery = text;
                    highlighted: true;
                    inputMethodHints: Qt.ImhNoPredictiveText;
                    onAccepted: searchAccepted(text);
                    Component.onCompleted: text_field_timer.start();
                }
                Timer { id: text_field_timer;
                    running: false; repeat: false; interval: 10;
                    onTriggered: {
                        text_field.text = "";
                        text_field.forceActiveFocus();
                    }
                }
            }
        }
    }

    Rectangle { id: shadow;
        width: parent.width;
        height: units.gu(0.75);
        opacity: Settings.themeIndex === 0 ? 0.1 : 0.6;
        anchors {top: header.bottom; left: parent.left; right: parent.right;}
        gradient: Gradient {
            GradientStop {position: 0.0; color: "black";}
            GradientStop {position: 1.0; color: "#00000000";}
        }
    }
}
