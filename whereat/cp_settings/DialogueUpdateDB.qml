import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog { id: dialogue;

    signal updateCompleted()

    title: "Update Database"
    text: "This action requires a network connection and will freeze the app for a period of time. Please don't turn the screen off."

    ActivityIndicator { id: activity; running: false;}
    Button { id: b1;
        text: "I'm not ready...";
        onClicked: PopupUtils.close(dialogue);
    }
    Button { id: b2;
        text: "Experience the lag 😱";
        color: UbuntuColors.orange;
        onClicked: updateDB();
    }

    function updateDB() {
        dialogue.text = "Please wait...";
        activity.running = true;

        where_at.calendar_working = true;
        where_at.trips_working = true;
        where_at.routes_working = true;

        b1.visible = false;
        b2.visible = false;

        calendar.force_download_all();
        routes.force_download_all();
        trips.force_download_all();
    }

    Timer { id: loadFinishedTimer;
        running: false; interval: 1000; repeat: true;
        onTriggered: {
            if (where_at.calendar_working === where_at.trips_working === where_at.routes_working === true) {
                dialogue.text = "Done!";
                activity.running = false;
                b1.text = "Close";
                b1.visible = true;

            }
        }
    }

    U1db_Calendar { id: calendar; }
    U1db_Routes { id: routes; }
    U1db_Trips { id: trips; }
}
