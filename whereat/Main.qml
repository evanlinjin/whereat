import QtQuick 2.4
import Ubuntu.Components 1.3

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // whereatectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "testquick.evanlinjin"

    width: units.gu(100)
    height: units.gu(75)

    Page {
        header: PageHeader {
            id: pageHeader
            title: i18n.tr("testquick")
            StyleHints {
                foregroundColor: UbuntuColors.orange
                backgroundColor: UbuntuColors.porcelain
                dividerColor: UbuntuColors.slate
            }
        }

        Label { id: label
            anchors {
                horizontalCenter: parent.horizontalCenter;
                top: pageHeader.bottom;
                topMargin: units.gu(2);
            }
            text: whereat.atApiKey;
            Component.onCompleted: {
                locator.response.connect(response);
            }
            function response(status, lat, lon) {
                label.text = "Status: " + status + ", Lat: " + lat + ", Lon: " + lon;
            }
        }

        Button { id: button
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: label.bottom
                topMargin: units.gu(2)
            }
            width: parent.width
            text: "Locate";
            onClicked: locator.request();
        }

        UbuntuListView {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: button.bottom;
                bottom: parent.bottom;
                topMargin: units.gu(2);
            }
            width: parent.width
            clip: true
            //currentIndex: -1
            delegate: ListItem {
                height: units.gu(10)
                ListItemLayout { id: lol
                    anchors.fill: parent;
                    title.text: model.index;
                    subtitle.text: model.ln0 + model.ln1;
                    summary.text: model.fav;
                }
                onClicked: favouritesModel.removeFavourite(index);
            }
            model: favouritesModel;

            Component.onCompleted: {
                //walistmodel.insertRows(0, 5, walistmodel.getIndex(0));
            }
            PullToRefresh {}
        }
    }
}
