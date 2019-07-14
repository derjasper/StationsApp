import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import stationsapp 1.0


Page {
    id: page
    title: qsTr("Add via Link")
    property string currentSearch: ""
    property var backend

    Action {
        id: backAction
        icon.name: "go-previous"
        icon.source: "/icons/material/24x24/" + icon.name + ".svg"
        onTriggered: stackView.pop()
        shortcut: StandardKey.Cancel
    }

    Component.onCompleted: searchInput.forceActiveFocus()

    Launcher { id: launcher }

    header: ToolBar {
        RowLayout {
            spacing: 10
            anchors.fill: parent

            ToolButton {
                action: backAction
            }

            TextField {
                id: searchInput
                placeholderText: page.title
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                onAccepted: {
                    if (text.length >=3)
                        search(text)
                }
                // validator: RegExpValidator { regExp: /^.{3,}$/ }
            }
        }
    }

    function search(name) {
        currentSearch = name
        backend.getStationsByLink(name, function(list) {
            if (name === currentSearch) {
                stationsList.model = list
                currentSearch = ""
            }
        })
    }

    BusyIndicator {
        id: busy
        running: currentSearch !== ""
        anchors.centerIn: parent
    }

    Label {
        anchors.centerIn: parent
        text: qsTr("No results")
        visible: currentSearch === "" && stationsList.model.length === 0
    }

    ListView {
        id: stationsList
        visible: currentSearch === ""
        anchors.fill: parent
        keyNavigationWraps: true
        orientation: ListView.Vertical
        delegate: ItemDelegate {
            width: parent.width
            height: stationDelegate.height

            StationDelegate {
                id: stationDelegate
                station: stationsList.model[index]
                width: parent.width
            }

            onClicked: {
                stationsModel.append({
                     "type": stationsList.model[index]["type"],
                     "name": stationsList.model[index]["name"],
                     "contentUrl": stationsList.model[index]["contentUrl"],
                     "thumbnailUrl": stationsList.model[index]["thumbnailUrl"],
                     "websiteUrl": stationsList.model[index]["websiteUrl"]
                 })

                stackView.pop()
            }
        }
        model: []
        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
