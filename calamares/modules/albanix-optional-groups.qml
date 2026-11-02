// albanix-optional-groups.qml — Calamares custom module UI (optional software groups)
// Runs on the LIVE ISO.

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 700
    height: 500

    Column {
        anchors.centerIn: parent
        spacing: 16

        Text {
            text: qsTr("Optional software groups")
            font.pixelSize: 24
            font.bold: true
            color: "#F5F3EF"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: qsTr("Install extra software now. You can add more later with albanix install-group.")
            font.pixelSize: 14
            color: "#A9B6D3"
            wrapMode: Text.Wrap
            width: 600
            anchors.horizontalCenter: parent.horizontalCenter
        }

        GroupBox {
            title: qsTr("Choose groups to install")
            width: 600
            CheckBox {
                text: qsTr("Developer — git, node, pnpm, python, rustup, docker, podman, VS Code OSS")
                checked: job.groups.includes("developer")
                onCheckedChanged: job.toggle("developer", checked)
            }
            CheckBox {
                text: qsTr("Gaming — steam, proton-ge, gamemode, mangohud, lutris")
                checked: job.groups.includes("gaming")
                onCheckedChanged: job.toggle("gaming", checked)
            }
            CheckBox {
                text: qsTr("Creator — obs, kdenlive, krita, gimp, inkscape, blender")
                checked: job.groups.includes("creator")
                onCheckedChanged: job.toggle("creator", checked)
            }
            CheckBox {
                text: qsTr("Office — libreoffice, okular")
                checked: job.groups.includes("office")
                onCheckedChanged: job.toggle("office", checked)
            }
            CheckBox {
                text: qsTr("Privacy — wireguard-tools, tor browser launcher")
                checked: job.groups.includes("privacy")
                onCheckedChanged: job.toggle("privacy", checked)
            }
        }

        Button {
            text: qsTr("Save choices")
            onClicked: job.save()
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}