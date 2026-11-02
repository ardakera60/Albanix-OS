import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4 as DesktopControls

Rectangle {
    id: greeter
    width: 1280
    height: 800
    color: "#0B0B0F"

    Image {
        id: logo
        source: "/usr/share/albanix-branding/logo-albanix.svg"
        width: 96; height: 96
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 60
    }

    Text {
        anchors.top: logo.bottom
        anchors.topMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Albanix OS"
        font.pixelSize: 32
        font.weight: Font.Bold
        color: "#E41E20"
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Label {
            id: usernameLabel
            text: qsTr("Username:")
            color: "#F5F3EF"
        }

        TextField {
            id: usernameField
            width: 300
            color: "#F5F3EF"
            background: Rectangle { color: "#2A2A33"; radius: 6 }
        }

        Label {
            id: passwordLabel
            text: qsTr("Password:")
            color: "#F5F3EF"
        }

        DesktopControls.PasswordField {
            id: passwordField
            width: 300
            color: "#F5F3EF"
            background: Rectangle { color: "#2A2A33"; radius: 6 }
        }

        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: loginButton
                text: qsTr("Login")
                enabled: usernameField.text.length > 0 && passwordField.text.length > 0
                background: Rectangle { color: "#E41E20"; radius: 6 }
                color: "#F5F3EF"
                onClicked: greeter.authenticate(usernameField.text, passwordField.text)
            }

            Button {
                id: restartButton
                text: qsTr("Restart")
                background: Rectangle { color: "#2A2A33"; radius: 6 }
                color: "#F5F3EF"
                onClicked: greeter.reboot()
            }

            Button {
                id: shutdownButton
                text: qsTr("Shutdown")
                background: Rectangle { color: "#2A2A33"; radius: 6 }
                color: "#F5F3EF"
                onClicked: greeter.shutdown()
            }
        }

        Text {
            id: messageLabel
            color: "#E41E20"
            wrapMode: Text.Wrap
            width: 300
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Authentication signals
    Connections {
        target: greeter
        onAuthenticationError: messageLabel.text = qsTr("Wrong username or password.")
        onAuthenticationSuccess: usernameField.text = ""; passwordField.text = ""; messageLabel.text = ""
        onEnabledChanged: loginButton.enabled = greeter.enabled && usernameField.text.length > 0 && passwordField.text.length > 0
    }

    Image {
        source: "/usr/share/albanix-branding/eagle-mark.svg"
        width: 120; height: 120
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
    }
}