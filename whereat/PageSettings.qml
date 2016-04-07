import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems
import Ubuntu.Components.Popups 1.3

Page { id: page_settings;

    //property alias pg : progress_bar.value;

    header: MainHeader {id: header;
        ln2: "Settings"; icon: "settings";
        tabbar.visible: false;
        topbar.actions: [
            //Action {iconName: "help"; text: "Information"; /*onTriggered: {download_some();}*/},
            Action{iconName: "security-alert"; text: "force_download_all()"; onTriggered: u1db_calendar.force_download_all();}

        ]
//        tabbar.actions: [
//            Action{iconName: "help"; text: "Help"; },
//            Action{iconName: "save"; text: "Save"; },
//            Action{iconName: "add"; text: "Add"; }
//        ]
    }

//    UbuntuListView { id: settings_listview;
//        anchors {top: header.bottom; bottom: parent.bottom; left: parent.left; right: parent.right;}
//        clip: true;

//        model: u1db_calendar.model;

//        delegate: ListItems.Standard {
//            text: model.service_id + ", " + model.start_date + ", " + model.end_date + ".";
//        }
//    }

//    ProgressBar {id: progress_bar;
//        anchors {top: header.bottom; left: parent.left; right: parent.right;}
//        height: units.gu(3);
//        indeterminate: false;
//        showProgressPercentage: true;
//        minimumValue: 0;
//        maximumValue: 100;
//        value: 0;
//        onValueChanged: console.log("VALUE CHANGED!");
//    }

    //Scrollbar {flickableItem: settings_listview;}

    Component.onCompleted: {
        u1db_calendar.reload_model();
    }

//    function download_some() {
//        u1db_calendar.re_download("18290010283-20160316100058_v39.6");
//        u1db_calendar.re_download("1982016673-20160316100058_v39.6");
//        u1db_calendar.re_download("1033026214-20160316100058_v39.6");
//        u1db_calendar.re_download("6009021235-20160316100058_v39.6");
//    }
}
