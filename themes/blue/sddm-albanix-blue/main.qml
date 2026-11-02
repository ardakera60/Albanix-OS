import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4 as DesktopControls

Rectangle {
    id: greeter
    width: 1280
    height: 800
    color: "#07101F"

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
        color: "#244AA5"
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Label {
            id: usernameLabel
            text: qsTr("Username:")
            color: "#FFFFFF"
        }

        TextField {
            id: usernameField
            width: 300
            color: "#FFFFFF"
            background: Rectangle { color: "#1A2845"; radius: 6 }
        }

        Label {
            id: passwordLabel
            text: qsTr("Password:")
            color: "#FFFFFF"
        }

        DesktopControls.PasswordField {
            id: passwordField
            width: 300
            color: "#FFFFFF"
            background: Rectangle { color: "#1A2845"; radius: 6 }
        }

        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: loginButton
                text: qsTr("Login")
                enabled: usernameField.text.length > 0 && passwordField.text.length > 0
                background: Rectangle { color: "#244AA5"; radius: 6 }
                color: "#FFFFFF"
                onClicked: greeter.authenticate(usernameField.text, passwordField.text)
            }

            Button {
                id: restartButton
                text: qsTr("Restart")
                background: Rectangle { color: "#1A2845"; radius: 6 }
                color: "#FFFFFF"
                onClicked: greeter.reboot()
            }

            Button {
                id: shutdownButton
                text: qsTr("Shutdown")
                background: Rectangle { color: "#1A2845"; radius: 6 }
                color: "#FFFFFF"
                onClicked: greeter.shutdown()
            }
        }

        Text {
            id: messageLabel
            color: "#244AA5"
            wrapMode: Text.Wrap
            width: 300
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

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