import QtQuick

import QtQuick.Controls.Fusion
import QtQuick.Layouts

Item {
    id: root
    property alias model: itemList.model
    property string currentName
    property var currentStageList: null
    property bool showEditButton: true
    signal stageSelected()

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
                text: "无关卡集"
                color: "#FFFFFF"
                visible: itemList.count == 0
            }
            delegate: ItemDelegate {
                id: itemDelegate
                width: itemList.width
                text: pm_name.length !== 0? pm_name: "关卡集 %1".arg(index + 1)
                Row {
                    id: options
                    visible: root.showEditButton
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 3
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 3
                    Button {
                        text: "修改名称"
                        enabled: options.visible
                        onClicked: {
                            editRow.visible = true;
                            textField.text = pm_name;
                            textField.selectAll();
                            textField.forceActiveFocus();
                        }
                    }
                    Button {
                        text: "移除"
                        enabled: options.visible
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
                            pm_name = textField.text;
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
                    root.currentStageList = pm_stages;
                    root.currentName = text;
                    root.stageSelected();
                }
            }
        }
        Row {
            Layout.minimumHeight: height
            spacing: 10
            visible: root.showEditButton
            Button {
                id: addItemButton
                text: "添加关卡集"
                enabled: root.showEditButton
                onClicked: {
                    let count = itemList.count;
                    itemList.model.insertRows(count, 1);
                }
            }
        }
    }
}
