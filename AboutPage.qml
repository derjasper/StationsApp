import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Page {
    id: page
    title: qsTr("About")

    property string iconSource: "icon.svg"
    property string appName: qsTr("StationsApp")
    property string copyright: qsTr("StationsApp Contributors")

    property var credits: ListModel {
        ListElement {
            category: ""
            title: qsTr("Project homepage")
            description: qsTr("Bug tracking, translations, pull requests are welcome")
            link: "https://github.com/derjasper/StationsApp"
        }
        ListElement {
            category: ""
            title: qsTr("Donate via PayPal")
            description: qsTr("I would appreciate a donation if you like this app.")
            link: "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=52XD8L5GZPPNW"
        }

        ListElement {
            category: qsTr("Used APIs and Libraries")
            title: qsTr("RadioBrowser.info")
            description: qsTr("Visit radio-browser.info")
            link: "http://www.radio-browser.info"
        }
        ListElement {
            category: qsTr("Used APIs and Libraries")
            title: qsTr("Streamlink")
            description: qsTr("Needs to be installed seperately")
            link: "https://streamlink.github.io/"
        }
        ListElement {
            category: qsTr("Used APIs and Libraries")
            title: qsTr("Google material-design-icons")
            description: qsTr("Apache 2.0 License")
            link: "https://github.com/google/material-design-icons"
        }

        ListElement {
            category: qsTr("Contributors")
            title: "Jasper Nalbach"
            description: qsTr("Main developer")
            link: "https://github.com/derjasper"
        }
    }


    Action {
        id: backAction
        icon.name: "go-previous"
        icon.source: "/icons/material/24x24/" + icon.name + ".svg" // TODO binding loop..
        onTriggered: stackView.pop()
        shortcut: StandardKey.Cancel
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

    ListView {
        anchors.fill: parent
        header: Column {
            width: parent.width

            spacing: 40
            padding: 20

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: iconSource
                width:120
                height:120
            }

            Label {
                text: appName
                font.pointSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        model: credits
        delegate: ItemDelegate {
            width: parent.width
            height: col.height
            Column {
                id: col
                width: parent.width
                padding: 20
                Label {
                    text: model.title
                    wrapMode:Text.WordWrap
                    font.bold: true
                    width: parent.width-parent.padding*2
                }
                Label {
                    text: model.description
                    wrapMode:Text.WordWrap
                    font.pointSize: 10
                    width: parent.width-parent.padding*2
                }
            }
            onClicked: Qt.openUrlExternally(model.link)
        }
        section.property: "category"
        section.criteria: ViewSection.FullString
        section.delegate: Label {
            text: section
            font.bold: true
            font.pointSize: 10
            padding: 10
        }

        footer: Column { // TODO include copy of gplv3
            width: parent.width
            padding: 20
            Label {
                text: "© " + copyright
                wrapMode:Text.WordWrap
                horizontalAlignment:Text.AlignHCenter
                font.pointSize: 10
                width: parent.width-parent.padding*2
            }
            Label {
                text: qsTr("Licensed under GPLv3.")
                wrapMode:Text.WordWrap
                horizontalAlignment:Text.AlignHCenter
                font.pointSize: 10
                width: parent.width-parent.padding*2
            }
        }
    }
}
