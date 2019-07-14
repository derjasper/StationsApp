import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
//import QtQuick.Dialogs 1.3
import Qt.labs.platform 1.1

Page { // TODO design
    id: page
    title: qsTr("Settings")

    Action {
        id: backAction
        icon.name: "go-previous"
        icon.source: "/icons/material/24x24/" + icon.name + ".svg"
        onTriggered: stackView.pop()
        shortcut: StandardKey.Cancel
    }

    /*
    FileDialog {
        id: fileDialog
        title: qsTr("Library location")
        folder: appsettings.storageLocation
        selectFolder: true
        selectMultiple: false
        selectExisting: true
        onAccepted: {
            appsettings.storageLocation = decodeURIComponent(fileDialog.fileUrl.toString().replace(/^(file:\/{2})/,""))
        }
    }
    */

    FolderDialog {
        id: fileDialog
        title: qsTr("Library location")
        folder: stationsModel.storageLocation // appsettings.storageLocation
        onAccepted: {
            appsettings.storageLocation = decodeURIComponent(fileDialog.folder.toString().replace(/^(file:\/{2})/,""))
        }
    }

    AndroidFolderDialog {
        id: androidFileDialog
        title: qsTr("Library location")
        folder: stationsModel.storageLocation
        onAcceptedFolder: {
            appsettings.storageLocation = androidFileDialog.folder
        }
    }


    header: ToolBar {
        RowLayout {
            spacing: 10
            anchors.fill: parent

            ToolButton {
                action: backAction
            }

            Label {
                text: page.title
                elide: Label.ElideRight
                Layout.fillWidth: true
            }
        }
    }

    // TODO fix ugly layout
    ScrollView {
        anchors.fill: parent

        Flickable {
            boundsBehavior: Flickable.StopAtBounds

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                Label {
                    text: qsTr("Library folder")
                    font.weight: Font.Bold
                }

                Button {
                    Layout.fillWidth: true
                    text: stationsModel.storageLocation
                    onClicked: {
                        if (Qt.platform.os !== "android") {
                            fileDialog.open()
                        } else {
                            androidFileDialog.open()
                        }
                    }
                }


                Label {
                    text: qsTr("Style and colors")
                    font.weight: Font.Bold
                }

                ComboBox {
                    Layout.fillWidth: true
                    property bool initialized: false
                    model: availableStyles
                    Component.onCompleted: {
                        var styleIndex = find(appsettings.style, Qt.MatchFixedString)
                        currentIndex = (styleIndex === -1) ? 0 : styleIndex
                        initialized = true
                    }
                    onCurrentIndexChanged: {
                        if (appsettings.style !== availableStyles[currentIndex] && initialized)
                            appsettings.style = availableStyles[currentIndex]
                    }
                }
                Label {
                    text: qsTr("Needs restart to take effect")
                    font.italic: true
                }

                ComboBox {
                    Layout.fillWidth: true
                    property bool initialized: false
                    model: ["System", "Light", "Dark", "Black"]
                    Component.onCompleted: {
                        var idx = find(appsettings.theme, Qt.MatchFixedString)
                        currentIndex = (idx === -1) ? 0 : idx
                        initialized = true
                    }
                    onCurrentIndexChanged: {
                        if (appsettings.theme !== model[currentIndex] && initialized)
                            appsettings.theme = model[currentIndex]
                    }
                }

                Label {
                    text: qsTr("Playback")
                    font.weight: Font.Bold
                }
                Switch {
                    text: qsTr("Always use external player")
                    checked: appsettings.alwaysExternalPlayer
                    onToggled: appsettings.alwaysExternalPlayer = checked
                }

            }
        }
    }
}
