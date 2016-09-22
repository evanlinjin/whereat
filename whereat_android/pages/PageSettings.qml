import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import "../components"
import "../listitems"

Page { id: page;

    header: MainPageHeader { id: header;
        ln0: "Settings";
        titleIcon: "qrc:/icons/settings.svg";
        actionNavMenu: function() {mainMenu.toggle();}
        currentIndex: 0;
        searchMode: false;
        showReload: false;
        showTabBar: false;
    }

    ListView { id: list;

        anchors.fill: parent;
        model: VisualItemModel {
            HeaderLI {text: "Appearance";}
            SwitchLI {
                text: "Use Dark Theme";
                checked: Settings.themeIndex;
                trigger: function() {Settings.themeIndex = !Settings.themeIndex;}
            }
            HeaderLI {text: "Backend";}
            PlainLI {
                text: "Update Database...";
                trigger: function() {}
            }
            HeaderLI {text: "Miscellaneous";}
            PlainLI {
                text: "About 'Where AT?'";
                trigger: function() {}
            }
        }
    }
}
