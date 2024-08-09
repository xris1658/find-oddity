import QtQuick

import QtQml.Models

import QtQuick.Controls.Fusion
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root
    property int minimumWidth: 360
    property int minimumHeight: 480
    Item {
        id: imagePlaceholder
        Rectangle {
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height)
            height: width
            color: "transparent"
            border.color: "#808080"
        }
        Shape {
            z: 2
            containsMode: Shape.FillContains
            anchors.fill: parent
            clip: true
            visible: pathPolyline.path.length !== 0
            ShapePath {
                id: lassoPath
                strokeColor: "#FF0000"
                strokeWidth: 2
                startX: 0
                startY: 0
                fillColor: lassoShapeArea.containsMouse? "#808080": "transparent"
                PathPolyline {
                    id: pathPolyline
                }
            }
            MouseArea {
                id: lassoShapeArea
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
            }
        }

        MouseArea {
            id: lassoArea
            anchors.fill: parent
            property int prevX: 0
            property int prevY: 0
            z: 1
            onPressed: {
                pathPolyline.path = [];
                prevX = mouseX;
                prevY = mouseY;
                lassoPath.startX = mouseX;
                lassoPath.startY = mouseY;
                pathPolyline.path.push(
                    Qt.point(lassoPath.startX, lassoPath.startY)
                );
            }
            onReleased: {
                pathPolyline.path.push(
                    Qt.point(lassoPath.startX, lassoPath.startY)
                );
            }
            onPositionChanged: (mouse) => {
                if(containsPress) {
                    if(Math.sqrt(Math.pow(mouseX - prevX, 2) + Math.pow(mouseY - prevY, 2)) >= 4) {
                        pathPolyline.path.push(
                            Qt.point(mouseX, mouseY)
                        );
                        lassoArea.prevX = mouseX;
                        lassoArea.prevY = mouseY;
                    }
                }
            }
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
                        width: itemList.width - moveHandle.width
                        height: moveHandle.height
                        rightPadding: options.width + 5 + options.anchors.rightMargin
                        text: desc
                        Row {
                            id: options
                            anchors.right: parent.right
                            anchors.rightMargin: 3
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 3
                            Button {
                                text: "编辑描述"
                            }
                            Button {
                                text: "移除"
                            }
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
