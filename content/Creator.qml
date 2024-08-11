import QtQuick

import QtQml.Models

import QtQuick.Controls.Fusion
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root
    property int minimumWidth: 360
    property int minimumHeight: 480

    property alias stageModel: itemList.model

    QtObject {
        id: impl
        property ShapePath editingShapePath
        property PathPolyline editingPathPolyline
        property int lassoAreaInitialSize
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
            }
        }
        MouseArea {
            id: lassoArea
            anchors.fill: parent
            property int prevX: 0
            property int prevY: 0
            z: 1
            enabled: itemList.currentIndex != -1
            onPressed: {
                impl.editingPathPolyline.path = [];
                prevX = mouseX;
                prevY = mouseY;
                impl.editingShapePath.startX = mouseX / imagePlaceholder.width;
                impl.editingShapePath.startY = mouseY / imagePlaceholder.height;
                impl.editingPathPolyline.path.push(
                    Qt.point(impl.editingShapePath.startX, impl.editingShapePath.startY)
                );
            }
            onReleased: {
                impl.editingPathPolyline.path.push(
                    Qt.point(impl.editingShapePath.startX, impl.editingShapePath.startY)
                );
            }
            onPositionChanged: (mouse) => {
                if(containsPress) {
                    if(Math.sqrt(Math.pow(mouseX - prevX, 2) + Math.pow(mouseY - prevY, 2)) >= 4) {
                        impl.editingPathPolyline.path.push(
                            Qt.point(mouseX / imagePlaceholder.width, mouseY / imagePlaceholder.width)
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
                highlightFollowsCurrentItem: true
                clip: true
                property int footerHeight: 50
                delegate: ItemDelegate {
                    id: itemDelegate
                    width: itemList.width
                    leftPadding: height
                    rightPadding: options.width + 5 + options.anchors.rightMargin
                    text: sm_description.length !== 0? sm_description: "(无描述)"
                    highlighted: itemList.currentIndex == index
                    property Shape lassoShape: lassoShape
                    onHighlightedChanged: {
                        if(highlighted) {
                            impl.editingShapePath = lassoPath;
                            impl.editingPathPolyline = pathPolyline;
                        }
                    }
                    Label {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 5
                        width: parent.leftPadding
                        text: index + 1
                    }
                    Row {
                        id: options
                        z: 1
                        visible: true
                        anchors.right: parent.right
                        anchors.rightMargin: 3
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 3
                        Button {
                            text: "编辑描述"
                            onClicked: {
                                editRow.visible = true;
                                textField.text = sm_description;
                                textField.selectAll();
                                textField.forceActiveFocus();
                            }
                        }
                        Button {
                            text: "移除"
                            onClicked: {
                                itemList.model.removeRows(index, 1);
                            }
                        }
                    }
                    Row {
                        id: editRow
                        z: 2
                        visible: false
                        anchors.right: parent.right
                        anchors.rightMargin: 3
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 3
                        TextField {
                            id: textField
                            width: options.parent.width - editOkButton.width - editCancelButton.width - editRow.spacing * 3 - itemDelegate.leftPadding
                            enabled: editRow.visible
                            onAccepted: {
                                editRow.visible = false;
                                options.visible = true;
                                sm_description = textField.text;
                            }
                        }
                        Button {
                            id: editOkButton
                            enabled: editRow.visible
                            text: "确定"
                            onClicked: {
                                textField.accepted();
                            }
                        }
                        Button {
                            id: editCancelButton
                            enabled: editRow.visible
                            text: "取消"
                            onClicked: {
                                editRow.visible = false;
                                options.visible = true;
                            }
                        }
                    }
                    Shape {
                        id: lassoShape
                        visible: itemList.currentIndex == index
                        containsMode: Shape.FillContains
                        parent: imagePlaceholder
                        anchors.fill: parent
                        clip: true
                        property double initialSize: 1.0
                        ShapePath {
                            id: lassoPath
                            strokeColor: "#FF0000"
                            strokeWidth: 2
                            startX: 0
                            startY: 0
                            property double scaleFactor: lassoShape.width
                            scale: Qt.size(scaleFactor, scaleFactor)
                            fillColor: lassoShapeArea.containsMouse? "#80808080": "transparent"
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
                    onClicked: {
                        itemList.currentIndex = index;
                    }
                }
                footer: Item {
                    width: parent.width
                    height: itemList.footerHeight
                }
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "#808080"
                }
                MouseArea {
                    width: parent.width
                    anchors.top: itemList.contentItem.bottom
                    anchors.topMargin: -1 * itemList.footerHeight
                    anchors.bottom: parent.bottom
                    acceptedButtons: Qt.LeftButton
                    property double initialSize: 1.0
                    onClicked: {
                        itemList.currentIndex = -1;
                        impl.editingShapePath = null;
                        impl.editingPathPolyline = null;
                    }
                }
            }
            Row {
                Layout.minimumHeight: height
                spacing: 10
                Button {
                    id: setImageButton
                    text: "设置图片..."
                    onClicked: {
                        imagePicker.open();
                    }

                    FileDialog {
                        id: imagePicker
                        nameFilters: ["图像文件 (*.jpg *.png *.jpeg *.bmp)"]
                        onAccepted: {
                            image.source = imagePicker.currentFile;
                        }
                    }
                }
                Button {
                    id: addPathButton
                    text: "添加路径"
                    onClicked: {
                        impl.lassoAreaInitialSize = imagePlaceholder.width;
                        let count = itemList.count;
                        itemList.model.insertRows(count, 1);
                        itemList.currentIndex = count;
                    }
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
