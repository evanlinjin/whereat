import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems
import Ubuntu.Components.Popups 1.3

Page { id: page_settings;

    //property alias pg : progress_bar.value;

    header: PageHeader { id: header;
        contents: CustomHeader {subTitle: "Settings"; iconName: "settings";}
        trailingActionBar.actions: [
            Action {iconName: "info"; text: "About";
                onTriggered: {page_settings.pageStack.addPageToNextColumn(page_settings, Qt.resolvedUrl("PageInfo.qml"));}
            }
        ]
    }


    UbuntuListView { id: settings_listview;
        anchors {top: header.bottom; bottom: parent.bottom; left: parent.left; right: parent.right;}
        clip: true;

        model: VisualItemModel {

            // BACKEND SECTION >>>

            ListItems.Divider {}
            ListItems.Header { text: "Backend"; }

            ListItems.Subtitled { text: "Service Provider"; subText: "Auckland Transport"; progression: true;
                onClicked: {}
            }
            ListItems.Standard {text: "Update Database..."; showDivider: false;
                onClicked: {PopupUtils.open(Qt.resolvedUrl("DialogueUpdateDB.qml"));}
            }

            // MISCELLANEOUS SECTION >>>

            ListItems.Divider {}
            ListItems.Header { text: "Miscellaneous"; }

            ListItems.Subtitled {text: "About 'Where AT?'"; subText: "Version: " + app_version; progression: true;
                onClicked: {page_settings.pageStack.addPageToNextColumn(page_settings, Qt.resolvedUrl("PageInfo.qml"));}
            }
        }
    }

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

    //    Component.onCompleted: {
    //        u1db_calendar.reload_model();
    //    }

    //    function download_some() {
    //        u1db_calendar.re_download("18290010283-20160316100058_v39.6");
    //        u1db_calendar.re_download("1982016673-20160316100058_v39.6");
    //        u1db_calendar.re_download("1033026214-20160316100058_v39.6");
    //        u1db_calendar.re_download("6009021235-20160316100058_v39.6");
    //    }
}
