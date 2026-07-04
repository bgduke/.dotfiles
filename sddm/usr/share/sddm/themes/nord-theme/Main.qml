import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    anchors.fill: parent
    color: config.bg || "#2e3440"

    readonly property string bg: config.bg || "#2e3440"
    readonly property string bgSoft: config.bgSoft || "#32302f"
    readonly property string fg: config.text || "#d8dee9"
    readonly property string muted: config.muted || "#a89984"
    readonly property string accent: config.accent || "#88c0d0"
    readonly property string red: config.red || "#fb4934"
    readonly property int primaryScreenHeight: 1440

    Image {
        anchors.fill: parent
        source: config.background || "background.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.48
    }

    Rectangle {
        anchors.fill: parent
        color: "#aa282828"
    }
    ColumnLayout {
        id: loginPanel

        width: Math.min(360, root.width - 80)
        spacing: 12

        anchors.horizontalCenter: parent.horizontalCenter

        // Center within the 1440p monitor instead of the whole desktop.
        y: Math.max(40, (primaryScreenHeight - implicitHeight) / 2)

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: sessionManager.hostName
            color: root.fg
            opacity: 0.9
            font.pixelSize: 22
            font.bold: true
        }

        TextField {
            id: username
            Layout.fillWidth: true
            text: config.defaultUser || "bgduke"
            placeholderText: "username"
            selectByMouse: true
            font.pixelSize: 15
            color: root.fg
            placeholderTextColor: root.muted
            background: Rectangle {
                implicitHeight: 44
                radius: 10
                color: "#cc32302f"
                border.width: 1
                border.color: username.activeFocus ? root.accent : "#55504945"
            }
        }

        TextField {
            id: password
            Layout.fillWidth: true
            placeholderText: "password"
            echoMode: TextInput.Password
            focus: true
            font.pixelSize: 15
            color: root.fg
            placeholderTextColor: root.muted
            Keys.onReturnPressed: loginButton.clicked()
            Keys.onEnterPressed: loginButton.clicked()
            background: Rectangle {
                implicitHeight: 44
                radius: 10
                color: "#cc32302f"
                border.width: 1
                border.color: password.activeFocus ? root.accent : "#55504945"
            }
        }

        ComboBox {
            id: sessionBox
            Layout.fillWidth: true
            model: sessionModel
            textRole: "name"
            currentIndex: sessionModel.lastIndex
            font.pixelSize: 14
        }

        Button {
            id: loginButton
            Layout.fillWidth: true
            text: "login"
            onClicked: sddm.login(username.text, password.text, sessionBox.currentIndex)
            background: Rectangle {
                implicitHeight: 44
                radius: 10
                color: loginButton.down ? "#b57614" : root.accent
            }
            contentItem: Text {
                text: loginButton.text
                color: root.bg
                font.pixelSize: 15
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Label {
            id: errorMessage
            Layout.fillWidth: true
            text: ""
            color: root.red
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 13
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 18

            ToolButton {
                text: "sleep"
                onClicked: sddm.suspend()

                contentItem: Text {
                    text: parent.text
                    color: root.muted
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ToolButton {
                text: "restart"
                onClicked: sddm.reboot()

                contentItem: Text {
                    text: parent.text
                    color: root.muted
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ToolButton {
                text: "off"
                onClicked: sddm.powerOff()

                contentItem: Text {
                    text: parent.text
                    color: root.muted
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter

        // Bottom of the top monitor.
        y: primaryScreenHeight - height - 28
        text: Qt.formatDateTime(new Date(), "ddd, MMM d  •  hh:mm")
        color: root.muted
        font.pixelSize: 14
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            password.text = ""
            password.forceActiveFocus()
            errorMessage.text = "login failed"
        }
        function onLoginSucceeded() {
            errorMessage.text = ""
        }
    }
}
