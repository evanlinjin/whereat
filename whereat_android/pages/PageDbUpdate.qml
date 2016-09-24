import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import WhereAt 1.0
import QtGraphicalEffects 1.0

import "../js/appInfo.js" as INFO
import "../components"
import "../listitems"

Page { id: page;

    property int update_method: 0; // 0:NORMAL, 1:MANUAL

    header: MainPageHeader { id: header;
        ln0: "Update Database";
        titleIcon: "qrc:/icons/sync.svg";
        menuIcon: "qrc:/icons/back.svg";
        actionNavMenu: function() {stack.pop();}
        currentIndex: 0;
        showReload: false;
        showTabBar: false;
    }

    Column {
        anchors.centerIn: parent;
        anchors.verticalCenterOffset: -header.height/2;
        spacing: 20;

        Label {
            width: page.width - 40;
            text: update_method == 0 ? INFO.desc_nud : INFO.desc_mcd;
            horizontalAlignment: Text.AlignHCenter;
            wrapMode: Text.WordWrap;
            font.pixelSize: 14;
            font.weight: Font.Normal;
        }

        MainButton {
            anchors.horizontalCenter: parent.horizontalCenter;
            text: "Begin Update";
            onClicked: begin_update();
        }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 10;
        height: 40;
        width: textBottomRow.width;
        color: bottomMouseArea.pressed ? "whitesmoke" : "transparent";

        Row { id: textBottomRow;
            spacing: 5;

            Item {
                height: 20;
                width: 20;
                anchors.verticalCenter: parent.verticalCenter;
                Image { id: textIcon;
                    anchors.fill: parent;
                    source: update_method === 1 ?
                                "qrc:/icons/security-alert.svg" :
                                "qrc:/icons/tick.svg";
                    mipmap: true;
                    smooth: true;
                    onSourceChanged: overlay.reload();
                }
                ColorOverlay { id: overlay;
                    Component.onCompleted: reload();
                    function reload() {
                        overlay.source = textIcon;
                        overlay.anchors.fill = textIcon;
                        overlay.color = update_method === 1 ? "red" : "green";
                    }
                }
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter;
                text: update_method === 1 ? "Maunal mode selected." : "Normal mode selected.";
                color: update_method === 1 ? "red" : "green";
                horizontalAlignment: Text.AlignHCenter;
            }

            NumberAnimation on opacity {from: 0; to: 1; duration: 200;}
            NumberAnimation on opacity {from: 1; to: 0; duration: 200;}
        }

        MouseArea { id: bottomMouseArea;
            z: textBottomRow.z + 1;
            anchors.fill: parent;
            onClicked: update_method = !update_method;
        }
    }

    function begin_update() {
        if (update_method === 1) {
            dialog.open();
            whereat.updateDbManual();
        } else {
            progressBar0.visible = true;
            progressBar.visible = false;
            dialog.open();
            whereat.updateDb();
        }
    }

    function cancel_update() {
        if (update_method === 1) {
        }
    }

    property bool show_finish: false;

    Popup { id: dialog;

        property string text: "Downloading...";

        x: parent.width/2 - dialog.width/2;
        y: parent.height/2 - dialog.width/2;
        width: parent.width*2/3;
        height: parent.height*2/3;

        modal: true;
        closePolicy: Popup.NoAutoClose;

        ColumnLayout {
            anchors.fill: parent;
            spacing: 10;

            Label {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: dialog.text;
                font.pixelSize: 14;
                font.weight: Font.Normal;
            }

            ProgressBar { id: progressBar0;
                property alias maximumValue: progressBar0.to;
                value: 0;
                visible: false;
                height: visible ? 5 : 0;
            }
            ProgressBar { id: progressBar;
                property alias maximumValue: progressBar.to;
                value: 0;
                visible: !show_finish;
                height: visible ? 5 : 0;
            }
            MainButton {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: show_finish ? "Close" : "Cancel";
                onClicked: {
                    show_finish ? dialog.close() : cancel_update();
                    stack.pop();
                }
            }
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

    WhereAt { id: whereat;}
}
