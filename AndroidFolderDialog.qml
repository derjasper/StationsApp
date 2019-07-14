import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import stationsapp 1.0

Dialog {
    id: dialog
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true

    property string folder
    signal acceptedFolder()

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2

    contentItem: ColumnLayout {
        TextField {
            id: storageLocationInput
            Layout.fillWidth: true
            Layout.preferredWidth: 250
            placeholderText: qsTr("Folder")
            text: folder
        }
    }

    AndroidPermissions {
        id: permissions
    }

    onOpened: title = permissions.requestWriteExternalStorage()

    onAccepted: {
        folder = storageLocationInput.text
        dialog.close()
        acceptedFolder()
    }
}
