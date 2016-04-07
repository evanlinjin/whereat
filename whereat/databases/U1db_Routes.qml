import QtQuick 2.0

Item { id: u1db_item;

    property var db: null;
    property ListModel model: ListModel {}

    function rq_names() {} // TODO: Should return [route_short_name, route_long_name] from route_id;
    function force_download_all() {} // TODO: Should fill database.

    // FUNCTION 'reload_model()' >>
    // Forces a complete reload on 'routes' lm.
    function reload_model() {
        db_open(); model.clear();
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM routes');
            for (var i = 0; i < rs.rows.length; i++) {
                model.append(rs.rows.item(i));
            }
        });
    }

    /********************************************************************************************** PRIVATE FUNCTIONS */

    // FUNCTION 'db_open()' >>>
    // Opens 'routes' db from SQLite.
    function db_open() {
        if (db !== null) {return;}         // Return if db already loaded.

        // db = LocalStorage.openDatabaseSync(identifier, version, description, estimated_size, callback(db))
        db = LocalStorage.openDatabaseSync("AT", "0.1", "Stores Data from AT Transport", 100000);

        try {
            db.transaction(function(tx){
                tx.executeSql(
                            'CREATE TABLE IF NOT EXISTS routes(' +
                            'route_id         TEXT PRIMARY KEY    NOT NULL,' +
                            'agency_id        TEXT                NOT NULL,' +
                            'route_short_name TEXT                NOT NULL,' +
                            'route_long_name  TEXT                NOT NULL,' +
                            'route_desc       TEXT                        ,' + /* CAN BE NULL */
                            'route_type       INT                 NOT NULL,' +
                            'route_url        TEXT                        ,' + /* CAN BE NULL */
                            'route_color      TEXT                        ,' + /* CAN BE NULL */
                            'route_text_color TEXT                         ' + /* CAN BE NULL */ ')'
                            );
                var table_len  = tx.executeSql("SELECT * FROM routes").rows.length;
                console.log("LOADED: DB 'routes' with ", table_len, " elements.");
            });
        } catch (err) { console.log("ERROR: creating table in database: " + err); };
    }

    // FUNCTION 'db_add(route_id, a_id, r_sn, r_ln, r_d, r_t, r_u, r_c, r_tc)' >>
    // Adds a 'routes' db element.
    // Inputs: TEXT, [ TEXT x4 ], INT, [ TEXT x3 ].
    function db_add(route_id, a_id, r_sn, r_ln, r_d, r_t, r_u, r_c, r_tc) {
        //db_open();
        db.transaction( function(tx){
            tx.executeSql('INSERT OR REPLACE INTO routes VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)',
                          [route_id, a_id, r_sn, r_ln, r_d, r_t, r_u, r_c, r_tc] );
        });

    }

    // FUNCTION 'db_get(route_id, key)' >>>
    // Returns value from selected 'route_id' and 'key'.
    function db_get(route_id, key) {
        //db_open();
        var res = "";
        db.transaction( function(tx) {
            var rs = tx.executeSql('SELECT ' + key + ' FROM routes WHERE route_id=?', [route_id]);
            if (rs.rows.item(0) === undefined) {return 0;} // TODO: Inform user that their AT DB is outdated.
            res = rs.rows.item(0)[key];
            //console.log("I GOT: ", res, typeof res, " FROM: ", key, route_id);
        });
        return res;
    }

    // FUNCTION 'db_getList()' >>>
    // Returns a list of 'route_id's stored in 'routes' db.
    function db_getList() {
        //db_open();
        var res = [];
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT route_id FROM routes');

            for (var i = 0; i < rs.rows.length; i++) {
                res.push(String(rs.rows.item(i).route_id));
            }
        });
        return res;
    }
}
