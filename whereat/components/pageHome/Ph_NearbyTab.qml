import QtQuick 2.4
import Ubuntu.Components 1.3

MainListView { id: nearby_view;
    grid_model: nearby_model;
    list.headerPositioning: ListView.PullBackHeader;
    list.header: NearbySlider { visible: !nearby_model.is_loading;}
    ptr.refreshing: nearby_model.is_loading;
    ptr.onRefresh: nearby_model.force_reload();

    EmptyState { id: nearby_es;
        visible: nearby_model.count === 0 && nearby_model.is_loading === false;
        iconName: "location"
        title: i18n.tr("Nothing nearby")
        subTitle: "Change the search radius or check system settings"
    }
}
