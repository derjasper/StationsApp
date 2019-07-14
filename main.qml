import QtQuick 2.9
import QtQuick.Controls 2.2
import QtMultimedia 5.8
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import Qt.labs.settings 1.0

import stationsapp 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: stackView.currentItem.title

    FsListModel {
        id: stationsModel
        schema: {
            "type": "String",
            "name": "String",
            "contentUrl": "String",
            "thumbnailUrl": "String",
            "websiteUrl": "String"
        }
        storageLocation: appsettings.storageLocation
    }

    Settings {
        id: appsettings
        property string style: "Default"
        property string theme: "System"
        property string storageLocation: "~/.stationsapp"
        property bool alwaysExternalPlayer: false

        onAlwaysExternalPlayerChanged: {
            if (alwaysExternalPlayer)
                mediaPlayer.reset()
        }
    }

    PlayerPage {
        id: playerPage
        visible: false
    }

    Material.theme: (appsettings.theme === "Light") ? Material.Light : (appsettings.theme === "Dark" || appsettings.theme === "Black" ? Material.Dark : Material.System)
    Material.accent: (appsettings.theme === "Black" || Material.theme === Material.Dark) ? "white" : "black"
    Material.primary: (appsettings.theme === "Black" || Material.theme === Material.Dark) ? "black" : "white"
    Material.background: (appsettings.theme === "Black") ? "black" : defaultTheme.background

    Universal.theme: (appsettings.theme === "Light") ? Universal.Light : (appsettings.theme === "Dark" ? Universal.Dark : Universal.System)

    onClosing: {
        if (Qt.platform.os === "android") {
            if (stackView.depth > 1) {
                close.accepted = false
                stackView.pop();
            } else{
                return;
            }
        }
    }

    Item {
        id: defaultTheme
        visible: false
        Material.theme: appsettings.theme
    }

    // TODO streamlink: regenerate link

    // TODO android icon bugs
    // TODO android default theme
    // TODO android font

    // TODO open externally: on desktop, choose a media player
    // TODO on fullscreen: disable screensaver/standby
    // TODO MPRIS integration
    // TODO android soundmenu integration

    // TODO upnp

    // TODO recorder
    // TODO sleep timer
    // TODO alarm
    // TODO organization: local search filter, categories

    MediaPlayer {
        id: mediaPlayer
        property var currentStation: "None"

        audioRole: (hasStation() || currentStation["@type"] === "AudioObject") ? MediaPlayer.MusicRole : MediaPlayer.VideoRole

        function hasStation() {
            return currentStation !== "None"
        }

        function setStation(station) {
            currentStation = station
            source = station.contentUrl
            currentStationChanged()
        }

        function reset() {
            stop()
            currentStation = "None"
            currentStationChanged()
        }

        onError: {
            reset()
            playbackFailedDialog.open()
        }
    }

    Dialog {
        id: playbackFailedDialog
        standardButtons: Dialog.Ok
        modal: true
        title: qsTr("Playback failed")
        Label {
            anchors.fill: parent
            wrapMode: Label.WordWrap
            text: qsTr("The playback of the selected media could not be started or failed.")
        }
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
    }

    StackView {
        id: stackView
        initialItem: "StationsListPage.qml"
        anchors.fill: parent
    }
}
