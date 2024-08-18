import QtQuick

import QtQml.Models

import QtQuick.Controls.Fusion
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root

    property alias model: itemList.model
    property alias imageUrl: image.source

    property FontLoader fontLoader

    signal init()
    onInit: {
        root.model.init();
        impl.foundItemCount = 0;
    }

    QtObject {
        id: impl
        property int foundItemCount: 0
    }

    Item {
        id: imagePlaceholderArea
        Rectangle {
            id: imagePlaceholder
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height)
            height: width
            color: "transparent"
            border.color: "#808080"
            Image {
                id: image
                anchors.fill: parent
                anchors.margins: parent.border.width
                fillMode: Image.PreserveAspectCrop
                clip: true
                z: 1
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onClicked: (mouse) => {
                    let point = Qt.point(mouse.x, mouse.y);
                    for(let i = 0; i < mouseAreas.count; ++i) {
                        let shape = mouseAreas.itemAt(i);
                        shape.testPoint(point);
                    }
                }
            }
            Repeater {
                id: mouseAreas
                model: root.model
                Shape {
                    id: lassoShape
                    parent: imagePlaceholder
                    anchors.fill: parent
                    containsMode: Shape.FillContains
                    clip: true
                    signal testPoint(point: point)
                    onTestPoint: (point) => {
                        if(contains(point) && !im_found) {
                            im_found = true;
                            ++impl.foundItemCount;
                        }
                    }
                    z: 2
                    ShapePath {
                        startX: 0
                        startY: 0
                        property double scaleFactor: lassoShape.width
                        scale: Qt.size(scaleFactor, scaleFactor)
                        strokeColor: "transparent"
                        fillColor: im_found? "#80808040": "transparent"
                        PathPolyline {
                            path: im_path
                        }
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
                delegate: Label {
                    id: label
                    text: im_found? im_description: "?"
                    topPadding: 5
                    leftPadding: height
                    bottomPadding: 5
                    Item {
                        width: height
                        height: parent.height
                        Rectangle {
                            anchors.centerIn: parent
                            width: height
                            height: 16
                            radius: height / 2
                            color: im_found? "#00FF00": "transparent"
                            border.color: "#CCCCCC"
                        }
                    }
                }
            }
            Label {
                Layout.preferredWidth: itemListPlaceholder.width
                Layout.minimumHeight: height
                horizontalAlignment: Label.AlignHCenter
                text: impl.foundItemCount.toString() + " / " + itemList.count
            }
        }
    }
    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        visible: width <= height + itemListPlaceholder.minimumWidth
        spacing: 10
        LayoutItemProxy {
            target: imagePlaceholderArea
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
            target: imagePlaceholderArea
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
