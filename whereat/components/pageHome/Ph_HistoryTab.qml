import QtQuick 2.4
import Ubuntu.Components 1.3

MainListView { id: history_view;
    grid_model: history_model;
    ptr.refreshing: false;
    ptr.onRefresh: history_model.force_reload();

    EmptyState { id: history_es;
        visible: history_model.count === 0 && history_model.is_loading === false;
        iconName: "timer"
        title: i18n.tr("Nothing visited")
        subTitle: "Swipe from the bottom to search or press nearby to see what's close"
    }
}
