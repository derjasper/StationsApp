import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Dialog {
    id: dialog
    title: currentStation !== "" ? qsTr("Edit station") :  qsTr("Create station")
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2

    property var currentStation: ""

    function createStation() {
        typeInput.currentIndex = 0
        nameInput.clear()
        thumbnailUrlInput.clear()
        contentUrlInput.clear()
        websiteUrlInput.clear()
        currentStation = ""
        open()
    }

    function editStation(station) {
        typeInput.currentIndex = station.type === "AudioObject" ? 0 : 1
        nameInput.text = station.name
        thumbnailUrlInput.text = station.thumbnailUrl
        contentUrlInput.text = station.contentUrl
        websiteUrlInput.text = station.websiteUrl
        currentStation = station
        open()
    }

    contentItem: ColumnLayout {
        id: layout
        spacing: 10

        ComboBox {
            id: typeInput
            textRole: "text"
            model: ListModel {
                id: typeModel
                ListElement {
                    text: "Radio"
                    value: "AudioObject"
                }
                ListElement {
                    text: "TV"
                    value: "VideoObject"
                }
            }
            Layout.fillWidth: true
            Layout.preferredWidth: 250
        }

        TextField {
            id: nameInput
            Layout.fillWidth: true
            Layout.preferredWidth: 250
            placeholderText: qsTr("Name")
        }

        TextField {
            id: contentUrlInput
            Layout.fillWidth: true
            Layout.preferredWidth: 250
            placeholderText: qsTr("Stream URL")
        }

        TextField {
            id: thumbnailUrlInput
            Layout.fillWidth: true
            Layout.preferredWidth: 250
            placeholderText: qsTr("Thumnail URL")
        }

        TextField {
            id: websiteUrlInput
            Layout.fillWidth: true
            Layout.preferredWidth: 250
            placeholderText: qsTr("Website URL")
        }
    }

    onAccepted: {
        if (currentStation === "")
            stationsModel.append({
                "type": typeModel.get(typeInput.currentIndex).value,
                "name": nameInput.text,
                "contentUrl": contentUrlInput.text,
                "thumbnailUrl": thumbnailUrlInput.text,
                "websiteUrl": websiteUrlInput.text
            })
        else {
            currentStation.type = typeModel.get(typeInput.currentIndex).value
            currentStation.name = nameInput.text
            currentStation.contentUrl = contentUrlInput.text
            currentStation.thumbnailUrl = thumbnailUrlInput.text
            currentStation.websiteUrl = websiteUrlInput.text
        }
        dialog.close()
    }
}
