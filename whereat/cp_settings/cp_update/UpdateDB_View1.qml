import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Column {
    spacing: units.gu(1);

//    ProgressBar {
//            id: indeterminateBar;
//            indeterminate: true;
//            width: parent.width;
//        }

//    ProgressBar { id: c_bar;
//        showProgressPercentage: true;
//        minimumValue: 0;
//        maximumValue: where_at.c_total;
//        value: where_at.c_i;
//        width: parent.width;
//        onValueChanged: {console.log("HARROOO!");}
//    }

//    ProgressBar { id: r_bar;
//        showProgressPercentage: true;
//        minimumValue: 0;
//        maximumValue: where_at.r_total;
//        value: where_at.r_i;
//        width: parent.width;
//        onValueChanged: {console.log("HARROOO!");}
//    }

//    ProgressBar { id: t_bar;
//        showProgressPercentage: true;
//        minimumValue: 0;
//        maximumValue: where_at.t_total;
//        value: where_at.t_i;
//        width: parent.width;
//        onValueChanged: {console.log("HARROOO!");}
//    }

    Button { id: b1;
        text: "Cancel";
        onClicked: PopupUtils.close(dialogue);
        width: parent.width;
    }

//    Timer { id: load_timer;
//        running: true; interval: 1000; repeat: true;
//        onTriggered: {
//            c_bar.maximumValue = where_at.c_total;
//            c_bar.value = where_at.c_i;
//            r_bar.maximumValue = where_at.r_total;
//            r_bar.value = where_at.r_i;
//            t_bar.maximumValue = where_at.t_total;
//            t_bar.value = where_at.t_i;
//        }
//    }
}
