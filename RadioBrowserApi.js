.pragma library


function searchStationByName(name, callback) {// TODO use playable station url
    var req = new XMLHttpRequest();
    req.onreadystatechange = function() {
        if (req.readyState === XMLHttpRequest.DONE) {
            var rawData = JSON.parse(req.responseText)

            var list = []
            for (var i = 0; i < rawData.length; i++) {
                var isTV = (rawData[i].tags === "TV")
                list.push({
                  "type": isTV ? "VideoObject" : "AudioObject",
                  "contentUrl": rawData[i].url,
                  "name": isTV ? rawData[i].name.substring(0, rawData[i].name.length-3) : rawData[i].name,
                  "thumbnailUrl": rawData[i].favicon,
                  "websiteUrl": ""
                })
            }

            callback(list)
        }
    }
    req.open("GET", "http://www.radio-browser.info/webservice/json/stations/byname/" + encodeURIComponent(name))
    req.send();
}
