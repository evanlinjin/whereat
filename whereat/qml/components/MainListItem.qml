import QtQuick 2.4
import Ubuntu.Components 1.3

ListItem { id: listItem;

    property var updateFavourite;
    property var open;
    property var open0;
    property alias showRemove: leftRemoveAction.visible;

    divider.visible: false
    height: units.gu(8)

    ListItemLayout {
        anchors.fill: parent
        title.text: model.ln0;
        subtitle.text: model.ln1;

        Icon {
            SlotsLayout.position: SlotsLayout.Leading;
            width: height; height: units.gu(4);
            source: model.type;
        }

        Item { id: icon_container;
            SlotsLayout.position: SlotsLayout.Trailing;
            width: units.gu(2.5); height: units.gu(4.5);
            anchors.verticalCenter: parent.verticalCenter;
            Label {
                anchors.right: parent.right;
                anchors.top: parent.top;
                text: model.ln2;
                textSize: Label.Small;
            }
            Icon {id: favourite_icon;
                anchors.right: parent.right;
                anchors.bottom: parent.bottom;
                width: units.gu(2);
                name: model.fav ? "starred" : "non-starred";
            }
        }
    }

    // LEADING ACTIONS *********************************************************

    leadingActions: ListItemActions {
        actions: Action { id: leftRemoveAction;
            iconName: "remove"; name: "Remove Favourite";
            onTriggered: listItem.updateFavourite(model.id, false);
            visible: listItem.showRemove;
        }
    }

    // TRAILING ACTIONS ********************************************************

    trailingActions: ListItemActions { id: trailing_actions; actions: [
            Action {
                iconName: model.fav ? "starred" : "non-starred";
                text: model.fav ? "Remove from Favourites" : "Add to Favourites"
                onTriggered: listItem.updateFavourite(model.id, !model.fav);
            },
            Action {
                iconName: "info";
                text: "View Information Board";
                onTriggered: listItem.open0(model.id);
            }
        ]
    }

    // CLICKABLE ***************************************************************

    onClicked: {listView.currentIndex = -1; listItem.open(model.id);}
    //onPressAndHold: {}
}
