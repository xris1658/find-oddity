import QtQuick

import QtQuick.Controls.Fusion
import QtQuick.Layouts
import QtQuick.Shapes

import FindOddity.Models

Window {
    id: root
    width: 1280
    height: 720
    visible: true
    color: "#222222"
    minimumWidth: creator.minimumWidth + creator.anchors.margins * 2
    minimumHeight: creator.minimumHeight + creator.anchors.margins * 2
    property bool isOnWasm: false
    property alias professionModel: professionList.model
    FontLoader {
        id: fontLoader
        source: "./font/wqy-microhei.ttc"
    }
    ProfessionList {
        id: professionList
        anchors.fill: parent
        anchors.margins: 20
        onStageSelected: {
            stageList.model = currentStageList;
            visible = false;
            stageListPlaceholder.visible = true;
        }
    }
    ColumnLayout {
        id: stageListPlaceholder
        anchors.fill: parent
        anchors.margins: 20
        visible: false
        Item {
            Layout.preferredWidth: stageListPlaceholder.width
            Layout.minimumHeight: stageListReturnButton.height
            Button {
                id: stageListReturnButton
                text: "< 返回"
                onClicked: {
                    stageListPlaceholder.visible = false;
                    professionList.visible = true;
                }
            }
            Label {
                text: professionList.currentName
                anchors.left: stageListReturnButton.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        StageList {
            id: stageList
            Layout.preferredWidth: stageListPlaceholder.width
            Layout.fillHeight: true
            fontLoader: root.isOnWasm? fontLoader: null
            onItemSelected: {
                creator.model = currentItemList;
                stageListPlaceholder.visible = false;
                creatorPlaceholder.visible = true;
            }
        }
    }
    ColumnLayout {
        id: creatorPlaceholder
        anchors.fill: parent
        anchors.margins: 20
        visible: false
        Item {
            Layout.preferredWidth: creatorPlaceholder.width
            Layout.minimumHeight: creatorReturnButton.height
            Button {
                id: creatorReturnButton
                text: "< 返回"
                onClicked: {
                    creatorPlaceholder.visible = false;
                    stageListPlaceholder.visible = true;
                }
            }
            Label {
                text: professionList.currentName + " - " + stageList.currentName
                anchors.left: creatorReturnButton.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Creator {
            id: creator
            Layout.preferredWidth: creatorPlaceholder.width
            Layout.fillHeight: true
            fontLoader: root.isOnWasm? fontLoader: null
        }
    }
}
