import QtQml.Models

import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts

Popup {
    id: root
    width: 400
    padding: 10
    background: Rectangle {
        color: "#222222"
        border.color: "#808080"
        border.width: 1
    }
    contentItem: ColumnLayout {
        spacing: 10
        Label {
            Layout.preferredWidth: parent.width
            text: "<b>一起来找茬</b>"
            font.pointSize: Qt.application.font.pointSize * 1.5
        }
        Label {
            Layout.preferredWidth: parent.width
            text: "寻找图片中奇怪的地方吧！您可以自己创作关卡，并让别人游玩。"
        }
        Label {
            Layout.preferredWidth: parent.width
            text: "Copyright (c) 2024 xris1658"
        }
        ListView {
            id: itemList
            Layout.preferredWidth: parent.width
            visible: thirdPartySoftwareButton.checked
            height: 100
            model: ListModel {
                ListElement {
                    name: "Qt"
                    website: "https://www.qt.io"
                    desc: "跨平台的应用程序开发套件"
                    license: "商用 / GPLv3"
                }
                ListElement {
                    name: "rapidyaml"
                    website: "https://github.com/biojppm/rapidyaml"
                    desc: "快速 YAML 读取和写入"
                    license: "MIT"
                }
            }
            delegate: Row {
                Label {
                    width: 90
                    leftPadding: 3
                    text: "<a href=\"%1\">%2</a>".arg(website).arg(name)
                    onLinkActivated: (link) => {
                        Qt.openUrlExternally(link);
                    }
                }
                Label {
                    width: 200
                    text: desc
                }
                Label {
                    width: 110
                    text: license
                }
            }
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: "#808080"
            }
        }
        Item {
            Layout.preferredWidth: parent.width
            height: row.height
            Row {
                id: row
                anchors.right: parent.right
                spacing: 3
                Button {
                    id: thirdPartySoftwareButton
                    text: "第三方软件(&T)"
                    checkable: true
                    checked: false
                }
                Button {
                    text: "关闭(&C)"
                    onClicked: {
                        root.close();
                    }
                }
            }
        }
    }
}
