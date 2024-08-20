import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts

Popup {
    id: root
    padding: 10
    property string version: "6.6"
    background: Rectangle {
        color: "#222222"
        border.color: "#808080"
        border.width: 1
    }
    contentItem: RowLayout {
        width: 600
        spacing: 10
        Item {
            Layout.minimumWidth: 64
            height: texts.height
            Image {
                width: 64
                height: 64
                source: "./images/qtlogo-64.png"
                smooth: true
                mipmap: true
            }
        }
        Item {
            id: textPlaceholder
            Layout.fillWidth: true
            width: 500
            height: texts.height
            ColumnLayout {
                id: texts
                width: parent.width
                spacing: 5
                Label {
                    Layout.preferredWidth: parent.width
                    text: "<b>关于 Qt</b>"
                    font.pointSize: Qt.application.font.pointSize * 1.5
                }
                Label {
                    Layout.preferredWidth: parent.width
                    text: "This program uses Qt version %1.".arg(version)
                }
                Label {
                    Layout.preferredWidth: parent.width
                    wrapMode: Label.WordWrap
                    text:
                        "<p>Qt is a C++ toolkit for cross-platform application
                        development.</p>
                        <p>Qt provides single-source portability across all major desktop
                        operating systems. It is also available for embedded Linux and other
                        embedded and mobile operating systems.</p>
                        <p>Qt is available under multiple licensing options designed
                        to accommodate the needs of our various users.</p>
                        <p>Qt licensed under our commercial license agreement is appropriate
                        for development of proprietary/commercial software where you do not
                        want to share any source code with third parties or otherwise cannot
                        comply with the terms of GNU (L)GPL.</p>
                        <p>Qt licensed under GNU (L)GPL is appropriate for the
                        development of Qt&nbsp;applications provided you can comply with the terms
                        and conditions of the respective licenses.</p>
                        <p>Please see <a href=\"http://%2/\">%2</a>
                        for an overview of Qt licensing.</p>
                        <p>Copyright (C) %1 The Qt Company Ltd and other
                        contributors.</p>
                        <p>Qt and the Qt logo are trademarks of The Qt Company Ltd.</p>
                        <p>Qt is The Qt Company Ltd product developed as an open source
                        project. See <a href=\"http://%3/\">%3</a> for more information.</p>"
                            .arg("2022").arg("qt.io/licensing").arg("qt.io")
                    onLinkActivated: (link) => {
                        Qt.openUrlExternally(link);
                    }
                }
                Item {
                    Layout.preferredWidth: parent.width
                    height: closeButton.height
                    Button {
                        id: closeButton
                        anchors.right: parent.right
                        text: "关闭(&C)"
                        onClicked: {
                            root.close();
                        }
                    }
                }
            }
        }
    }
}