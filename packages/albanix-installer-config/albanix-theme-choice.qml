// albanix-theme-choice.qml — Calamares custom module UI (theme choice)
// Runs on the LIVE ISO.
// Shows "Zgjidh temën / Choose your theme" with live preview images.

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 700
    height: 500

    property string theme: job.theme

    Column {
        anchors.centerIn: parent
        spacing: 24

        Text {
            text: qsTr("Zgjidh temën / Choose your theme")
            font.pixelSize: 24
            font.bold: true
            color: "#F5F3EF"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: qsTr("Your theme changes Plasma, SDDM, Plymouth, wallpaper, Konsole, fastfetch, starship.")
            font.pixelSize: 14
            color: "#A9B6D3"
            wrapMode: Text.Wrap
            width: 600
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing: 40
            anchors.horizontalCenter: parent.horizontalCenter

            // Red theme card
            Column {
                spacing: 12
                RadioButton {
                    text: qsTr("Albanix Red")
                    checked: job.theme === "red"
                    onCheckedChanged: if (checked) { job.theme = "red"; job.save("red") }
                }
                Image {
                    source: job.previewImage("red")
                    width: 240
                    height: 160
                    fillMode: Image.PreserveAspectFit
                }
                Text {
                    text: qsTr("Red #E41E20 · Black #0B0B0F · Gold #D4A537")
                    font.pixelSize: 12
                    color: "#D4A537"
                    wrapMode: Text.Wrap
                    width: 240
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            // Blue theme card
            Column {
                spacing: 12
                RadioButton {
                    text: qsTr("Albanix Blue")
                    checked: job.theme === "blue"
                    onCheckedChanged: if (checked) { job.theme = "blue"; job.save("blue") }
                }
                Image {
                    source: job.previewImage("blue")
                    width: 240
                    height: 160
                    fillMode: Image.PreserveAspectFit
                }
                Text {
                    text: qsTr("Blue #244AA5 · Navy #07101F · Gold #D0A650")
                    font.pixelSize: 12
                    color: "#D0A650"
                    wrapMode: Text.Wrap
                    width: 240
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}