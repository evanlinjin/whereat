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

    property list<Action> topbar;

    property list<Row> headerModeList;
    property int headerMode: 0; // 0:NORMAL, 1:SEARCH, 2:SELECT
    property bool dual_heading: false;

    property alias searchPlaceholderText: search_textfield.placeholderText;
    signal searchAccepted(string query);

    function focus_search_bar() {
        search_textfield.selectAll();
        search_textfield.forceActiveFocus();
    }

    // HEADER STYLING >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    StyleHints { id: style;
        foregroundColor: header.foregroundColor;
        backgroundColor: header.backgroundColor;
        dividerColor: header.backgroundColor;
    }

    contents: headerModeList[headerMode];

    extension: Sections { id: sections;
        height: visible ? units.gu(4) : 0;
        visible: actions.length > 0 && headerMode === 0;
        //anchors {left: parent.left; top: parent.top;}
        actions: tabbar;

        StyleHints {
            //sectionColor: header.foregroundColor;
            underlineColor: header.backgroundColor;
            selectedSectionColor: header.foregroundColor;
        }
    }

    trailingActionBar.actions: topbar;
    leadingActionBar.actions: leftbutton;

    // HEADER CONTENTS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    headerModeList: [
        Row { id: header_normal;
            anchors.fill: parent;
            Item { width: height; height: parent.height;
                Icon { id: icon;
                    height: units.gu(4);
                    anchors.centerIn: parent;
                    color: foregroundColor; //"#1E3D51"
                }
            }
            Loader { width: parent.width - units.gu(6); height: parent.height;
                sourceComponent: dual_heading ? head1 : head2;
            }

            Component { id: head1;
                ListItem {
                    width: parent.width; height: parent.height;
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
                Item {width: parent.width; height: parent.height;
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
        },

        Row { id: header_search;
            anchors.fill: parent;
            TextField { id: search_textfield;
                anchors.verticalCenter: parent.verticalCenter;
                width: parent.width; //height: units.gu(3.5);
                placeholderText: "Search...";
                highlighted: true;
                inputMethodHints: Qt.ImhNoPredictiveText;
                onAccepted: {searchAccepted(text);}
            }
        },

        Row { id: header_select;
            anchors.fill: parent;
        }
    ]

    Rectangle {
        width: parent.width;
        height: units.gu(0.75);
        opacity: settings_theme === 0 ? 0.1 : 0.6;
        anchors {top: header.bottom; left: parent.left; right: parent.right;}
        gradient: Gradient {
            GradientStop {position: 0.0; color: "black";}
            GradientStop {position: 1.0; color: "#00000000";}
        }
    }
}
