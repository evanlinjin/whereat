import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import "at_backend.js" as AT

Item { id: u1db_item;

    property var db: null;
    property ListModel model: ListModel {}

    property string debug: "DB TRIPS:";

    /*********************************************************************************************** PUBLIC FUNCTIONS */


    /********************************************************************************************** PRIVATE FUNCTIONS */

    // FUNCTION 'db_open()' >>>
    // Opens 'list' db from SQLite.
    function db_open() {
        if (db !== null) {return;}         // Return if db already loaded.

        // db = LocalStorage.openDatabaseSync(identifier, version, description, estimated_size, callback(db))
        db = LocalStorage.openDatabaseSync("AT", "0.1", "Stores Data from AT Transport", 100000);

        try {
            db.transaction(function(tx){
                tx.executeSql(
                            'CREATE TABLE IF NOT EXISTS trips(' +
                            'trip_id            TEXT PRIMARY KEY    NOT NULL,' +
                            'route_id           TEXT                NOT NULL,' +
                            'service_id         TEXT                NOT NULL,' +
                            'trip_headsign      TEXT                NOT NULL,' +
                            'direction_id       INT                 NOT NULL,' +
                            'block_id           TEXT                        ,' +
                            'shape_id           TEXT                NOT NULL,' +
                            'trip_short_name    TEXT                        ,' +
                            'trip_type          TEXT                         ' + ')'
                            );
                var table_len  = tx.executeSql("SELECT * FROM trips").rows.length;
                console.log("LOADED: DB 'trips' with ", table_len, " elements.");
            });
        } catch (err) { console.log("ERROR: creating table in database: " + err); };
    }

    // FUNCTION 'db_add()' >>>
    // Adds a 'trips' db element.
    // Inputs: [ TEXT x4], INT, [ TEXT x4].
    function db_add(trip_id, route_id, service_id, t_hs, d_id, b_id, s_id, t_sn, t_t) {
        db.transaction( function(tx) {
            tx.executeSql('INSERT OR REPLACE INTO trips VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)',
                          [trip_id, route_id, service_id, t_hs, d_id, b_id, s_id, t_sn, t_t] );
        });
    }

    // FUNCTION
}

