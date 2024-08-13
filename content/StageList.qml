import QtQuick

import QtQuick.Controls.Fusion
import QtQuick.Layouts

Item {
    id: root
    property alias model: itemList.model
    property string currentName
    property var currentItemList: null
    signal itemSelected()

    property FontLoader fontLoader

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        ListView {
            id: itemList
            Layout.preferredWidth: root.width
            Layout.fillHeight: true
            clip: true
            Label {
                anchors.centerIn: parent
                text: "无关卡"
                color: "#FFFFFF"
                visible: itemList.count == 0
            }
            delegate: ItemDelegate {
                id: itemDelegate
                width: itemList.width
                text: sm_name.length !== 0? sm_name: "关卡 %1".arg(index + 1)
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
                        text: "修改名称"
                        onClicked: {
                            editRow.visible = true;
                            textField.text = sm_name;
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
                            sm_name = textField.text;
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
                onClicked: {
                    root.currentItemList = sm_items;
                    root.currentName = text;
                    root.itemSelected();
                }
            }
        }
        Row {
            Layout.minimumHeight: height
            spacing: 10
            Button {
                id: addItemButton
                text: "添加关卡"
                onClicked: {
                    let count = itemList.count;
                    itemList.model.insertRows(count, 1);
                }
            }
        }
    }
}
