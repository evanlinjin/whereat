TEMPLATE = aux
TARGET = whereat

RESOURCES += whereat.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  whereat.apparmor \
               whereat.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)               

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               whereat.desktop

#specify where the qml/js files are installed to
qml_files.path = /whereat
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /whereat
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /whereat
desktop_file.files = $$OUT_PWD/whereat.desktop
desktop_file.CONFIG += no_check_exist

INSTALLS+=config_files qml_files desktop_file

DISTFILES += \
    PageHome.qml \
    components/CustomHeader.qml \
    PageTimeBoard.qml \
    views/MainGridView.qml \
    views/MainSearchView.qml \
    logic/at_backend.js \
    models/NearbyModel.qml \
    models/MainSearchResultsModel.qml \
    models/FavouritesModel.qml \
    models/HistoryModel.qml \
    databases/U1db_Favourites.qml \
    models/TimeBoardModel.qml \
    components/TBM_Label.qml \
    views/MainListView.qml \
    PageSettings.qml \
    popups/PopupNavigation.qml \
    components/NearbySlider.qml \
    components/MainHeader.qml \
    databases/U1db_Calendar.qml \
    components/EmptyState.qml \
    PageJourneyPlanner.qml \
    components/pageHome/Ph_FavouritesTab.qml \
    components/pageHome/Ph_NearbyTab.qml \
    components/pageHome/Ph_HistoryTab.qml \
    views/StopInfoView.qml \
    databases/U1db_Trips.qml \
    databases/U1db_Routes.qml \
    cp_settings/PageInfo.qml \
    cp_settings/DialogueUpdateDB.qml \
    PageATHop.qml \
    cp_settings/cp_update/UpdateDB_View0.qml \
    cp_settings/cp_update/UpdateDB_View1.qml \
    cp_settings/cp_update/UpdateDB_View2.qml \
    databases/U1db_Stops.qml

