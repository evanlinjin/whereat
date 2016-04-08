import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog { id: dialogue;

    signal updateCompleted()

    title: "Update Database"
    text: "This action requires a network connection and will freeze the app for a period of time. Please don't turn the screen off."

    ActivityIndicator { id: activity; running: false;}

    Loader { id: loader; source: "UpdateDB_View0.qml"}

    function updateDB() {

        where_at.calendar_working = true;
        where_at.trips_working = true;
        where_at.routes_working = true;

        dialogue.text = "Working...";
        activity.running = true;
        loadFinishedTimer.start();

        loader.source = "";

        calendar.force_download_all();
        routes.force_download_all();
        trips.force_download_all();
    }

    Timer { id: loadFinishedTimer;
        running: false; interval: 1000; repeat: true;
        onTriggered: {
            if (!where_at.calendar_working && !where_at.trips_working && !where_at.routes_working) {
                dialogue.text = "Done!"; activity.running = false;
                loader.source = "UpdateDB_View2.qml";
            }
        }
    }

    U1db_Calendar { id: calendar; }
    U1db_Routes { id: routes; }
    U1db_Trips { id: trips; }
}
