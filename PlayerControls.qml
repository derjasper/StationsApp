import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8

ToolBar {
    id: player

    property bool playerLink: true
    property bool showFullscreenToggle: false

    RowLayout {
        spacing: 10
        anchors.fill: parent

        ToolButton {
            icon.name: (mediaPlayer.playbackState !== MediaPlayer.PlayingState) ?  "media-playback-start" : "media-playback-pause"
            icon.source: "/icons/material/24x24/" + icon.name + ".svg"
            enabled: mediaPlayer.hasStation()
            onClicked: {
                if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                    mediaPlayer.pause()
                } else if (mediaPlayer.playbackState === MediaPlayer.PausedState) {
                    mediaPlayer.play()
                }
            }
        }

        RowLayout {
            id: metadata

            Layout.fillWidth: true
            Layout.fillHeight: true

            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 10

            Column {
                id: icon
                Layout.fillHeight: true
                Layout.preferredWidth: height

                Image {
                    width: height
                    height: parent.height-10
                    source: mediaPlayer.currentStation !== "None" ? mediaPlayer.currentStation.thumbnailUrl : ""
                    fillMode: Image.PreserveAspectFit
                    visible: mediaPlayer.currentStation !== "None" && mediaPlayer.currentStation.thumbnailUrl !== "" && !busy.visible
                    anchors.verticalCenter: parent.verticalCenter
                }

                BusyIndicator {
                    id: busy
                    visible: mediaPlayer.status == MediaPlayer.Loading || mediaPlayer.status == MediaPlayer.Buffering
                    anchors.centerIn: parent
                    running: visible
                    width: height
                    height: parent.height * 0.75
                }
            }

            Column {
                Layout.fillWidth: true
                Label {
                    text: (mediaPlayer.currentStation !== "None") ? mediaPlayer.currentStation.name : ""
                    font.bold: true
                    clip: true
                    width: parent.width
                }

                Label {
                    id: subtitle
                    text: mediaPlayer.metaData.title ? mediaPlayer.metaData.title : ""
                    visible: mediaPlayer.metaData.title !== undefined && mediaPlayer.metaData.title !== mediaPlayer.currentStation.name
                    clip: true
                    width: parent.width
                }
            }

            visible: !(playerPage.valid && playerLink)
        }

        ToolButton {
            Layout.fillWidth: true
            StationDelegate {
                station: mediaPlayer.currentStation
                height: parent.height
                width: parent.width
            }
            enabled: playerPage.valid && playerLink
            onClicked: stackView.push(playerPage)

            visible: playerPage.valid && playerLink
        }

        ToolButton {
            icon.name: "media-playback-stop"
            icon.source: "/icons/material/24x24/" + icon.name + ".svg"
            enabled: mediaPlayer.hasStation()
            onClicked: mediaPlayer.reset()
        }

        ToolButton {
            icon.name: "audio-volume-high"
            icon.source: "/icons/material/24x24/" + icon.name + ".svg"
            onClicked: volumePopup.open()

            Popup {
                id: volumePopup

                transformOrigin: Popup.BottomRight
                x: parent.width - width

                Slider {
                    id: volumeSlider
                    anchors.centerIn: parent
                    value: QtMultimedia.convertVolume(mediaPlayer.volume,
                                                      QtMultimedia.LinearVolumeScale,
                                                      QtMultimedia.LogarithmicVolumeScale)
                    property real volume: QtMultimedia.convertVolume(volumeSlider.value,
                                                                     QtMultimedia.LogarithmicVolumeScale,
                                                                     QtMultimedia.LinearVolumeScale)
                    onVolumeChanged: mediaPlayer.volume = volume
                    // TODO binding loop...
                }
            }
        }

        ToolButton {
            visible: showFullscreenToggle
            action: Action {
                enabled: showFullscreenToggle
                icon.name: (window.visibility === ApplicationWindow.FullScreen) ? "view-fullscreen" : "view-restore"
                icon.source: "/icons/material/24x24/" + icon.name + ".svg"
                onTriggered: {
                    if (window.visibility === ApplicationWindow.FullScreen) {
                        window.showNormal()
                    } else {
                        window.showFullScreen()
                    }
                }
                shortcut: StandardKey.FullScreen
            }
        }
    }
}
