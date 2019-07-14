import QtQuick 2.0
import QtQuick.Controls 2.3

Item {
    id: delegate
    property var station: "None"
    height: 50
    width: parent.width

    Row {
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 10

        Image {
            id: img
            width: height
            height: delegate.height-10
            source: station !== "None" ? station.thumbnailUrl : ""
            fillMode: Image.PreserveAspectFit
            visible: station !== "None" && station.thumbnailUrl !== ""
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            text: station !== "None" ? station.name : qsTr("No station selected")
            font.bold: station !== "None"
            font.italic: station === "None"
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width < contentWidth + img.width + typeLabel.width ?  parent.width-img.width-typeLabel.width : contentWidth
            clip: true
        }
        Label {
            id: typeLabel
            text: (station !== "None" && station.type === "AudioObject") ? "Radio" : "TV"
            visible: station !== "None"
            font.italic: true
            font.pixelSize: 10
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
