import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import stationsapp 1.0

Item {
    property bool available: false

    Launcher {
        id: launcher
        property bool busy: false
        property var handler
        property var failedHandler
        onFinished: function(res) {
            busy = false
            handler(res)
        }
        onFailed: function() {
            busy = false
            failedHandler()
        }

        function run(command, args, callback, failedCallback) {
            if (busy)
                return
            busy = true

            handler = callback
            failedHandler = failedCallback
            launch(command, args)
        }
    }

    Component.onCompleted: {
        if (Qt.platform.os != "android") {
            // TODO think of another solution..
            launcher.run("/home/jasper/.local/bin/streamlink", ["--version"], function (res) {
                available = res.includes("streamlink 0.")
            }, function() {})
        }
    }

    function getStationsByLink(link, callback) {
        launcher.run("/home/jasper/.local/bin/streamlink", ["-j", link], function(res) {
            var json = JSON.parse(res)

            if ("error" in json)
                callback([])

            var results = []
            for (var key in json["streams"]) {
                results.push({
                    "type": key === "audio_only" ? "AudioObject" : "VideoObject",
                     "contentUrl": json["streams"][key]["url"],
                     "name": key,
                     "thumbnailUrl": "",
                     "websiteUrl": link
                })
            }
            callback(results)
        }, function() {
            callback([])
        })
    }
}


