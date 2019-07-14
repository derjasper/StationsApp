import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8

Page {
    id: page
    title: mediaPlayer.hasStation() ? mediaPlayer.currentStation.name : ""

    property bool valid: mediaPlayer.hasStation() && mediaPlayer.currentStation.type === "VideoObject"

    property bool controlsVisible: true

    onValidChanged: {
        if (stackView.currentItem == page)
            stackView.pop()
    }

    Action {
        id: closePlayerAction
        icon.name: "go-previous" // TODO icon not shown
        icon.source: "/icons/material/24x24/" + icon.name + ".svg"
        onTriggered: {
            stackView.pop()
            if (window.visibility == ApplicationWindow.FullScreen) {
                window.showNormal()
            }
        }
        shortcut: StandardKey.Cancel
    }

    ToolBar {
        width: parent.width
        z: 1
        RowLayout {
            spacing: 10
            anchors.fill: parent

            ToolButton {
                action: closePlayerAction
            }
        }
        visible: controlsVisible
    }

    VideoOutput {
        anchors.fill: parent
        source: mediaPlayer
        autoOrientation: false
        visible: mediaPlayer.hasVideo
    }

    BusyIndicator {
        visible: !mediaPlayer.hasVideo
        anchors.centerIn: parent
        running: !mediaPlayer.hasVideo
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: {
            controlsVisible = true
            timer.restart()
        }
        onClicked: {
            controlsVisible = true
            timer.restart()
        }
        cursorShape: controlsVisible ? Qt.ArrowCursor : Qt.BlankCursor
    }

    Timer {
        id: timer
        interval: 3000
        onTriggered: {
            controlsVisible = false
        }

    }

    PlayerControls {
        playerLink: false
        showFullscreenToggle: true
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: controlsVisible
    }
}
