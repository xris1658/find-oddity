import QtQuick

import QtQml.Models

import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    Item {
        id: imagePlaceholder
        Rectangle {
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height)
            height: width
            color: "transparent"
            border.color: "#808080"
        }
    }
    Item {
        id: itemListPlaceholder
        property int minimumWidth: 200
        property int minimumHeight: 200
        ColumnLayout {
            anchors.fill: parent
            spacing: 10
            ListView {
                id: itemList
                Layout.preferredWidth: itemListPlaceholder.width
                Layout.fillHeight: true
                model: ListModel {
                    ListElement {
                        desc: "操作高压电时无保护措施"
                    }
                    ListElement {
                        desc: "未戴安全帽"
                    }
                }
                delegate: Row {
                    required property int index
                    required property string desc
                    ItemDelegate {
                        id: moveHandle
                        width: height
                        text: index + 1
                    }
                    ItemDelegate {
                        width: itemList.width - moveHandle.width - options.width
                        height: moveHandle.height
                        text: desc
                    }
                    Row {
                        id: options
                        Button {
                            height: moveHandle.height
                            text: "编辑描述"
                        }
                        Button {
                            height: moveHandle.height
                            text: "移除"
                        }
                    }
                }
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "#808080"
                }
            }
            Row {
                Layout.minimumHeight: height
                spacing: 10
                Button {
                    id: setImageButton
                    text: "设置图片..."
                }
                Button {
                    id: addPathButton
                    text: "添加路径..."
                }
            }

        }
    }
    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        visible: width <= height + itemListPlaceholder.minimumWidth
        spacing: 10
        LayoutItemProxy {
            target: imagePlaceholder
            Layout.preferredWidth: root.width
            Layout.minimumHeight: Math.min(root.width, columnLayout.height - columnLayout.spacing - itemListPlaceholder.minimumHeight)
        }
        LayoutItemProxy {
            target: itemListPlaceholder
            Layout.preferredWidth: root.width
            Layout.fillHeight: true
            // Layout.minimumHeight: itemListPlaceholder.minimumHeight
        }
    }
    RowLayout {
        id: rowLayout
        anchors.fill: parent
        visible: !columnLayout.visible
        spacing: 10
        LayoutItemProxy {
            target: imagePlaceholder
            Layout.minimumWidth: height
            Layout.preferredHeight: root.height
        }
        LayoutItemProxy {
            target: itemListPlaceholder
            Layout.fillWidth: true
            Layout.preferredHeight: root.height
        }
    }
}
