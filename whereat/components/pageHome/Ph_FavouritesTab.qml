import QtQuick 2.4
import Ubuntu.Components 1.3

MainListView { id: favourites_view;
    grid_model: favourites_model;
    thumb_str: "location";
    ptr.refreshing: false;
    ptr.onRefresh: favourites_model.force_reload();

    Component.onCompleted: favourites_model.force_reload();

    EmptyState { id: favourites_es;
        visible: favourites_model.count === 0;
        iconName: "non-starred"
        title: i18n.tr("Nothing starred")
        subTitle: "Star a timeboard simply by pressing the star icon"
    }
}
