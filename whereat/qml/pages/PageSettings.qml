import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as LI
import "../components"
import "../components/listItems"

Page { id: page;

    header: MainHeader { id: header;
        ln0: "Settings";
        iconName: "settings";
        leftbutton: Action { id: navButton;
            text: "Menu"; iconName: "navigation-menu";
            onTriggered: mainMenu.toggle();
        }
        tabbar: [
            Action {text: "General";
                onTriggered: {
                    header.headerMode = 0;
                }
            },
            Action {text: "Advanced";
                onTriggered: {
                    header.headerMode = 0;
                }
            }
        ]
    }

    UbuntuListView { id: list;
        property int model_mode: 0;

        anchors.fill: parent;
        anchors.topMargin: header.height;
        clip: true;
        Component.onCompleted: currentIndex = -1;
        onCountChanged: currentIndex = -1;
        model: switch(header.tabbar_currentIndex) {
               case 0: return list_general;
               case 1: return list_advanced;
               }

        property VisualItemModel list_general: VisualItemModel {

            HeaderLI {text: "Appearance";}

            SwitchLI {
                title: "Use Dark Theme";
                checked: Settings.themeIndex;
                trigger: function() {Settings.themeIndex = !Settings.themeIndex;}
            }

            SwitchLI {
                title: "Use Cluttered Headers";
                checked: Settings.themeIndex;
                trigger: function() {Settings.themeIndex = !Settings.themeIndex;}
            }

            HeaderLI {text: "Backend";}

            PlainLI {
                title: "Update Database...";
                trigger: function() {apl.addPageToNextColumn(apl.primaryPage, pageDbUpdate, {update_method:0});}
            }

            HeaderLI {text: "Miscellaneous";}

            PlainLI {
                title: "About 'Where AT?'";
                subtitle: "Version: 1.0 Pre-Alpha";
                trigger: function() {apl.addPageToNextColumn(apl.primaryPage, pageAbout);}
            }
        }

        property VisualItemModel list_advanced: VisualItemModel {

            PlainLI {
                title: "Update Database Manually (Very Slow)";
                subtitle: "Locally compiles database from AT api data.";
                trigger: function() {apl.addPageToNextColumn(apl.primaryPage, pageDbUpdate, {update_method:1});}
            }
        }
    }
}
