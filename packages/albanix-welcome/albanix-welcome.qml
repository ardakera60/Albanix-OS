// albanix-welcome.qml — QML fallback/slideshow for Albanix OS welcome app.
// Runs on the INSTALLED system (loaded by albanix-welcome.py if QtQuick is preferred).
import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    width: 900
    height: 640
    title: qsTr("Mirë se vini në Albanix OS / Welcome to Albanix OS")

    Column {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        Text {
            text: qsTr("Mirë se vini në Albanix OS")
            font.pixelSize: 26
            font.bold: true
        }
        Text {
            text: qsTr("Fast. Beautiful. Albanian. / Shpejtë. E bukur. Shqiptare.")
            font.pixelSize: 14
            color: palette.text.color
        }

        Row {
            spacing: 24
            Button { text: qsTr("Shqip"); onClicked: root.language = "sq" }
            Button { text: qsTr("English"); onClicked: root.language = "en" }
        }

        Text {
            text: qsTr("Choose your theme: Albanix Red (default) or Albanix Blue.")
            wrapMode: Text.Wrap
        }
        Row {
            spacing: 24
            Button { text: qsTr("Albanix Red"); onClicked: root.theme = "red" }
            Button { text: qsTr("Albanix Blue"); onClicked: root.theme = "blue" }
        }
    }
}