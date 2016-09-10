import QtQuick 2.4
import Ubuntu.Components 1.3

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // whereatectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "whereat.evanlinjin"

    width: units.gu(100)
    height: units.gu(75)

    Page {
        header: PageHeader {
            id: header
            title: i18n.tr("Where AT?")
            StyleHints {
                foregroundColor: UbuntuColors.orange
                backgroundColor: UbuntuColors.porcelain
                dividerColor: UbuntuColors.slate
            }
            trailingActionBar.actions: [
                Action {
                    iconName: "location"; text: "Reload";
                    onTriggered: whereat.reloadNearbyStops();
                }
            ]
        }

        UbuntuListView {
            anchors.fill: parent
            anchors.topMargin: header.height
            currentIndex: -1
            delegate: ListItem {
                height: units.gu(10)
                ListItemLayout {
                    id: lol
                    anchors.fill: parent
                    title.text: model.ln0;
                    subtitle.text: model.ln1;
                    summary.text: model.ln2;
                }
            }
            model: NearbyStopsModel;
            PullToRefresh {
                refreshing: NearbyStopsModel.loading;
                onRefresh: whereat.reloadNearbyStops();
            }
        }
    }
}
