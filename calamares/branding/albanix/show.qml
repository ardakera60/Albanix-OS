// show.qml — Albanix OS Calamares slideshow
// Runs on the LIVE ISO (shown while Calamares works).
// Albanian + English slides.
import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    width: 1024
    height: 768
    title: qsTr("Albanix OS — Installing")

    property int currentSlide: 0

    ListModel {
        id: slidesModel
        ListElement {
            title: qsTr("Mirë se vini / Welcome")
            body: qsTr("Albanix OS — Arch Linux with KDE Plasma 6.\nAlbanian-first, fast, beautiful.")
        }
        ListElement {
            title: qsTr("Tema Red / Theme Red")
            body: qsTr("Albanix Red — black and red, Albanian flag motif.\nDefault theme.")
        }
        ListElement {
            title: qsTr("Tema Blue / Theme Blue")
            body: qsTr("Albanix Blue — navy and gold, Kosovo flag motif.\nSix stars, gold map on blue.")
        }
        ListElement {
            title: qsTr("Pa telemetri / No telemetry")
            body: qsTr("No tracking, no ads, no phone-home.\nOnly mirrors and NTP.")
        }
        ListElement {
            title: qsTr("Gatshmë / Ready")
            body: qsTr("Installation almost complete.\nReboot into your new Albanix OS.")
        }
    }

    delegate: Item {
        width: root.width
        height: root.height
        Text {
            text: model.title
            font.pixelSize: 32
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 60
        }
        Text {
            text: model.body
            font.pixelSize: 18
            wrapMode: Text.Wrap
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: titleText.bottom
            anchors.topMargin: 24
        }
    }
}