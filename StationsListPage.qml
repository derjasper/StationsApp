import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8

Page {
    id: page
    property alias stationsList: stationsList

    title: qsTr("Stations")

    Action {
        id: addStationAction
        icon.name: "list-add"
        icon.source: "/icons/material/24x24/" + icon.name + ".svg"
        text: qsTr("Add custom station")
        onTriggered: stationDetailsDialog.createStation()
        shortcut: StandardKey.New
        enabled: page.visible
    }

    Action {
        id: radioBrowserAction
        icon.name: "edit-find"
        icon.source: "/icons/material/24x24/" + icon.name + ".svg"
        text: qsTr("Search RadioBrowser.net")
        onTriggered: stackView.push("RadioBrowserPage.qml")
        shortcut: StandardKey.Find
        enabled: page.visible
    }

    Action {
        id: streamlinkAction
        // icon.name: "edit-find"
        // icon.source: "/icons/material/24x24/" + icon.name + ".svg"
        text: qsTr("Add via link")
        onTriggered: stackView.push("StreamlinkPage.qml", {"backend": streamlinkBackend})
        // shortcut: StandardKey.Find
        enabled: page.visible && streamlinkBackend.available
    }

    Action {
        id: reloadAction
        icon.name: "view-refresh"
        icon.source: "/icons/material/24x24/" + icon.name + ".svg"
        text: qsTr("Reload")
        onTriggered: stationsModel.reload()
        shortcut: StandardKey.Refresh
        enabled: page.visible
    }

    Action {
        id: settingsAction
        icon.name: "settings"
        icon.source: "/icons/material/24x24/" + icon.name + ".svg"
        text: qsTr("Settings")
        onTriggered: stackView.push("SettingsPage.qml")
        shortcut: StandardKey.Preferences
        enabled: page.visible
    }

    Action {
        id: aboutAction
        icon.name: "help-about"
        icon.source: "/icons/material/24x24/" + icon.name + ".svg"
        text: qsTr("About")
        onTriggered: stackView.push("AboutPage.qml")
        shortcut: StandardKey.HelpContents
        enabled: page.visible
    }

    StationDetailsDialog {
        id: stationDetailsDialog
    }

    StreamlinkBackend {
        id: streamlinkBackend
    }

    function startPlayback(station) {
        mediaPlayer.setStation(station)
        mediaPlayer.play()
        if (station.type === "VideoObject")
            stackView.push(playerPage)
    }

    header: ToolBar {
        RowLayout {
            spacing: 10
            anchors.fill: parent

            Label {
                text: page.title
                elide: Label.ElideRight
                Layout.fillWidth: true
                Layout.leftMargin: 20
            }

            ToolButton {
                icon.name: "list-add"
                icon.source: "/icons/material/24x24/" + icon.name + ".svg"
                onClicked: addMenu.open()

                Menu {
                    id: addMenu
                    MenuItem {
                        action: addStationAction
                    }
                    MenuItem {
                        action: radioBrowserAction
                    }
                    MenuItem {
                        action: streamlinkAction
                        visible: streamlinkAction.enabled
                        height: visible ? implicitHeight : 0
                    }
                }
            }

            ToolButton {
                icon.name: "contextual-menu"
                icon.source: "/icons/material/24x24/" + icon.name + ".svg"
                onClicked: moreMenu.open()

                Menu {
                    id: moreMenu
                    MenuItem {
                        action: reloadAction
                    }
                    MenuItem {
                        action: settingsAction
                    }
                    MenuItem {
                        action: aboutAction
                    }
                }
            }
        }
    }

    Label {
        anchors.centerIn: parent
        text: qsTr("No stations added yet")
        visible: stationsList.model.length === 0
    }

    ListView { // TODO key navigation + enter
        id: stationsList
        anchors.fill: parent
        keyNavigationEnabled: true
        orientation: ListView.Vertical
        delegate: ItemDelegate {
            width: parent.width
            height: stationDelegate.height

            StationDelegate {
                id: stationDelegate
                station: model
                height: itemToolButton.height
                width: parent.width - itemToolButton.width
            }

            onClicked: {
                if (!appsettings.alwaysExternalPlayer) {
                    startPlayback(model)
                } else {
                    Qt.openUrlExternally(model.contentUrl)
                }
            }


            ToolButton {
                id: itemToolButton
                anchors.right: parent.right
                icon.name: "contextual-menu"
                icon.source: "/icons/material/24x24/" + icon.name + ".svg"
                onClicked: itemMenu.open()

                Menu {
                    id: itemMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight
                    MenuItem {
                        text: qsTr("Open externally")
                        onTriggered: Qt.openUrlExternally(model.contentUrl)
                    }
                    MenuItem {
                        text: qsTr("Website")
                        onTriggered: Qt.openUrlExternally(model.websiteUrl)
                        visible: model.websiteUrl !== ""
                        height: visible ? implicitHeight : 0
                    }
                    MenuSeparator {}
                    MenuItem {
                        text: qsTr("Edit")
                        icon.name: "edit"
                        icon.source: "/icons/material/24x24/" + icon.name + ".svg"
                        onTriggered: stationDetailsDialog.editStation(model)
                    }
                    MenuItem {
                        text: qsTr("Delete")
                        icon.name: "edit-delete"
                        icon.source: "/icons/material/24x24/" + icon.name + ".svg"
                        onTriggered: stationsModel.remove(index)
                    }
                }
            }
        }
        model: stationsModel
        ScrollIndicator.vertical: ScrollIndicator { }
        Component.onCompleted: forceActiveFocus()
    }

    footer: PlayerControls {
        playerLink: true
        visible: !appsettings.alwaysExternalPlayer
    }
}
