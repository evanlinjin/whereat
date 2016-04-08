import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Page {id: page;

    header: MainHeader { id: header;
        ln2: "Journey Planner";
        icon: "swap";
        tabbar.visible: false;
    }

    EmptyState {
        iconName: "swap";
        title: i18n.tr("Coming soon");
        subTitle: "Unfortunately I have not finished implementing this feature. Check this space for updates. 😁😝😊";
    }

//    property alias iconName: emptyIcon.name
//    property alias iconSource: emptyIcon.source
//    property alias iconColor: emptyIcon.color
//    property alias title: emptyLabel.text
//    property alias subTitle: emptySublabel.tex
}
