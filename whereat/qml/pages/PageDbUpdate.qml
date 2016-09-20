import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.Window 2.2
import WhereAt 1.0
import "../../js/appInfo.js" as INFO
import "../components"

PageAbstract { id: page;

    property int update_method: 0; // 0:NORMAL, 1:MANUAL

    header: MainHeader { id: header;
        ln0: "Update Database";
        iconName: "sync";
        leftbutton: Action {iconName: "back"; onTriggered: apl.removePages(page);}
    }

    Column {
        anchors.centerIn: parent;
        anchors.verticalCenterOffset: units.gu(0);
        spacing: units.gu(5);

        Label {
            width: page.width - units.gu(4);
            text: update_method == 0 ? INFO.desc_nud : INFO.desc_mcd;
            horizontalAlignment: Text.AlignHCenter;
            wrapMode: Text.WordWrap;
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter;
            strokeColor: theme.palette.normal.backgroundSecondaryText;
            text: update_method === 1 ? "Begin Manual Update" : "Begin Update";
            color: theme.palette.normal.foreground;
            onClicked: begin_update();
        }

        NumberAnimation on opacity {from: 0; to: 1; duration: 200;}
        NumberAnimation on opacity {from: 1; to: 0; duration: 200;}
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: units.gu(3);
        spacing: units.gu(1);

        Icon {
            height: units.gu(2.1);
            name: update_method === 1 ? "security-alert" : "tick";
            color: update_method === 1 ? UbuntuColors.red : UbuntuColors.green;
        }
        Label {
            text: update_method === 1 ? "Maunal mode selected." : "Normal mode selected.";
            color: update_method === 1 ? UbuntuColors.red : UbuntuColors.green;
            horizontalAlignment: Text.AlignHCenter;
        }

        NumberAnimation on opacity {from: 0; to: 1; duration: 200;}
        NumberAnimation on opacity {from: 1; to: 0; duration: 200;}
    }

    function begin_update() {
        if (update_method === 1) {
            PopupUtils.open(manual_update_dialog);
            whereat.updateDbManual();
        }
    }

    function cancel_update() {
        if (update_method === 1) {
        }
    }

    property bool show_finish: false;

    Component {id: manual_update_dialog;
        Dialog { id: dialog;
            text: "";
            ProgressBar { id: progressBar0;
                minimumValue: 0;
                maximumValue: 1;
                value: 0;
                visible: false;
                height: visible ? units.gu(2.5) : 0;
            }
            ProgressBar { id: progressBar;
                minimumValue: 0;
                maximumValue: 1;
                value: 0;
                visible: !show_finish;
                height: visible ? units.gu(2.5) : 0;
            }
            Button {
                strokeColor: theme.palette.normal.backgroundSecondaryText;
                text: show_finish ? "Close" : "Cancel";
                color: theme.palette.normal.foreground;
                onClicked: show_finish ? PopupUtils.close(manual_update_dialog) : cancel_update();
            }

            Component.onCompleted: {
                whereat.progress0.connect(updateProgress0);
                whereat.progress.connect(updateProgress);
                whereat.updateDbManualComplete.connect(updateComplete);
            }

            function updateProgress0(done, max) {
                progressBar0.visible = true;
                progressBar0.maximumValue = max;
                progressBar0.value = done;
            }

            function updateProgress(n, done, max) {
                progressBar.maximumValue = max;
                progressBar.value = done;
                dialog.text = n;
            }

            function updateComplete() {
                show_finish = true;
                progressBar0.visible = false;
                dialog.text = "Update Complete!";
            }
        }
    }

    WhereAt { id: whereat;}
}
