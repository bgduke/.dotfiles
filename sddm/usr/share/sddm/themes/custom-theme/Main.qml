/***************************************************************************
* Gruvbox Material Dark Medium customization
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    width: 640
    height: 480
    color: "#282828"

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    // Gruvbox Material Dark Medium
    property color bg: "#282828"
    property color bg0: "#32302f"
    property color bg1: "#3c3836"
    property color bg2: "#504945"
    property color fg: "#d4be98"
    property color gray: "#928374"
    property color green: "#a9b665"
    property color blue: "#7daea3"
    property color red: "#ea6962"
    property color yellow: "#d8a657"

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        function onLoginSucceeded() {
            errorMessage.color = green
            errorMessage.text = textConstants.loginSucceeded
        }

        function onLoginFailed() {
            password.text = ""
            errorMessage.color = red
            errorMessage.text = textConstants.loginFailed
        }

        function onInformationMessage(message) {
            errorMessage.color = yellow
            errorMessage.text = message
        }
    }

    Background {
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background)
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            var defaultBackground = Qt.resolvedUrl(config.defaultBackground)
            if (status == Image.Error && source != defaultBackground) {
                source = defaultBackground
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#cc282828"

        Clock {
            id: clock
            anchors.margins: 14
            anchors.top: parent.top
            anchors.right: parent.right

            color: fg
            timeFont.family: "Noto Sans"
        }

        Rectangle {
            id: rectangle
            anchors.centerIn: parent
            width: Math.max(360, mainColumn.implicitWidth + 56)
            height: Math.max(340, mainColumn.implicitHeight + 56)
            radius: 14
            color: "#ee32302f"
            border.color: bg2
            border.width: 1

            Column {
                id: mainColumn
                anchors.centerIn: parent
                spacing: 12
                width: 300

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: fg
                    verticalAlignment: Text.AlignVCenter
                    height: text.implicitHeight
                    width: parent.width
                    text: textConstants.welcomeText.arg(sddm.hostName)
                    wrapMode: Text.WordWrap
                    font.family: "Noto Sans"
                    font.pixelSize: 24
                    font.bold: true
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }

                Column {
                    width: parent.width
                    spacing: 4

                    Text {
                        id: lblName
                        width: parent.width
                        text: textConstants.userName
                        color: gray
                        font.family: "Noto Sans"
                        font.bold: true
                        font.pixelSize: 12
                    }

                    TextBox {
                        id: name
                        width: parent.width
                        height: 30
                        text: userModel.lastUser
                        font.family: "Noto Sans"
                        font.pixelSize: 14
                        color: fg

                        KeyNavigation.backtab: rebootButton
                        KeyNavigation.tab: password

                        Keys.onPressed: function (event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing: 4

                    Text {
                        id: lblPassword
                        width: parent.width
                        text: textConstants.password
                        color: gray
                        font.family: "Noto Sans"
                        font.bold: true
                        font.pixelSize: 12
                    }

                    PasswordBox {
                        id: password
                        width: parent.width
                        height: 30
                        font.family: "Noto Sans"
                        font.pixelSize: 14
                        color: fg

                        KeyNavigation.backtab: name
                        KeyNavigation.tab: session

                        Keys.onPressed: function (event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    spacing: 8
                    width: parent.width
                    z: 100

                    Column {
                        z: 100
                        width: parent.width * (layoutBox.visible ? 0.62 : 1)
                        spacing: 4
                        anchors.bottom: parent.bottom

                        Text {
                            id: lblSession
                            width: parent.width
                            text: textConstants.session
                            color: gray
                            wrapMode: TextEdit.WordWrap
                            font.family: "Noto Sans"
                            font.bold: true
                            font.pixelSize: 12
                        }

                        ComboBox {
                            id: session
                            width: parent.width
                            height: 30
                            font.family: "Noto Sans"
                            font.pixelSize: 14
                            color: fg

                            arrowIcon: Qt.resolvedUrl("angle-down.png")

                            model: sessionModel
                            index: sessionModel.lastIndex

                            KeyNavigation.backtab: password
                            KeyNavigation.tab: layoutBox
                        }
                    }

                    Column {
                        z: 101
                        width: parent.width * 0.34
                        spacing: 4
                        anchors.bottom: parent.bottom

                        visible: keyboard.enabled && keyboard.layouts.length > 0

                        Text {
                            id: lblLayout
                            width: parent.width
                            text: textConstants.layout
                            color: gray
                            wrapMode: TextEdit.WordWrap
                            font.family: "Noto Sans"
                            font.bold: true
                            font.pixelSize: 12
                        }

                        LayoutBox {
                            id: layoutBox
                            width: parent.width
                            height: 30
                            font.family: "Noto Sans"
                            font.pixelSize: 14
                            color: fg

                            arrowIcon: Qt.resolvedUrl("angle-down.png")

                            KeyNavigation.backtab: session
                            KeyNavigation.tab: loginButton
                        }
                    }
                }

                Column {
                    width: parent.width

                    Text {
                        id: errorMessage
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: textConstants.prompt
                        color: gray
                        font.family: "Noto Sans"
                        font.pixelSize: 10
                    }
                }

                Row {
                    spacing: 6
                    anchors.horizontalCenter: parent.horizontalCenter

                    property int btnWidth: Math.max(
                        loginButton.implicitWidth,
                        shutdownButton.implicitWidth,
                        rebootButton.implicitWidth,
                        80
                    ) + 10

                    Button {
                        id: loginButton
                        text: textConstants.login
                        width: parent.btnWidth
                        color: bg1
                        textColor: fg

                        onClicked: sddm.login(name.text, password.text, sessionIndex)

                        KeyNavigation.backtab: layoutBox
                        KeyNavigation.tab: shutdownButton
                    }

                    Button {
                        id: shutdownButton
                        text: textConstants.shutdown
                        width: parent.btnWidth
                        color: bg1
                        textColor: fg

                        onClicked: sddm.powerOff()

                        KeyNavigation.backtab: loginButton
                        KeyNavigation.tab: rebootButton
                    }

                    Button {
                        id: rebootButton
                        text: textConstants.reboot
                        width: parent.btnWidth
                        color: bg1
                        textColor: fg

                        onClicked: sddm.reboot()

                        KeyNavigation.backtab: shutdownButton
                        KeyNavigation.tab: name
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
