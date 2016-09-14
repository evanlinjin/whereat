import QtQuick 2.4
import Ubuntu.Components 1.3
import "pages"
import "components"

MainView { id: main;

    objectName: "mainView";
    applicationName: "whereat.evanlinjin";

    theme.name: { switch(Settings.themeIndex) {
        case 0: return "Ubuntu.Components.Themes.Ambiance";
        case 1: return "Ubuntu.Components.Themes.SuruDark";
        }
    }

    // GLOBAL PARAMETERS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


    // PAGE LAYOUT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    width: units.gu(100);
    height: units.gu(70);

    AdaptivePageLayout { id: apl;

        anchors.fill: parent;
        primaryPageSource: pageHome;

        layouts: PageColumnsLayout {
            when: width > units.gu(87.5);
            PageColumn {
                minimumWidth: preferredWidth;
                maximumWidth: preferredWidth;
                preferredWidth: units.gu(30) + width/7.5;
            }
            PageColumn {fillWidth: true;}
        }
    }

    Component {id: pageHome;
        PageHome {
            NumberAnimation on opacity {from: 0; to: 1; duration: UbuntuAnimation.SlowDuration;}
        }
    }
    Component {id: pageSettings;
        PageSettings {
            NumberAnimation on opacity {from: 0; to: 1; duration: UbuntuAnimation.SlowDuration;}
        }
    }
    Component { id: pageDbUpdate;
        PageDbUpdate {
            NumberAnimation on opacity {from: 0; to: 1; duration: UbuntuAnimation.SlowDuration;}
        }
    }

    NavigationMenu {id: mainMenu;
        pageWidth: main.width;
        pageHeight: main.height;
    }
}
