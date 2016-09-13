import QtQuick 2.4
import Ubuntu.Components 1.3
import "pages"

MainView { id: main;

    objectName: "mainView";
    applicationName: "whereat.evanlinjin";

    // PAGE LAYOUT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    width: units.gu(100);
    height: units.gu(70);

    AdaptivePageLayout { id: apl;

        anchors.fill: parent;
        primaryPage: PageHome {id: pageHome;}

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
}
