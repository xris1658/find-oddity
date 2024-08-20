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
    property bool showEditButton: true
    title: showEditButton? "一起来找茬 创作端": "一起来找茬 用户端"
    FontLoader {
        id: fontLoader
        source: "./font/wqy-microhei.ttc"
    }
    ProfessionList {
        id: professionList
        anchors.fill: parent
        anchors.margins: 20
        showEditButton: root.showEditButton
        onStageSelected: {
            stageList.model = currentStageList;
            visible = false;
            stageListPlaceholder.visible = true;
        }
        Row {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 5
            Button {
                text: "关于此软件(&A)..."
                onClicked: {
                    aboutPopup.open();
                }
            }
            Button {
                text: "关于 Qt(&Q)..."
                onClicked: {
                    aboutQtPopup.open();
                }
            }
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
            showEditButton: root.showEditButton
            fontLoader: root.isOnWasm? fontLoader: null
            onItemSelected: {
                stageListPlaceholder.visible = false;
                if(showEditButton) {
                    creator.model = currentItemList;
                    creatorPlaceholder.visible = true;
                    creator.imageUrl = currentImageUrl;
                }
                else {
                    player.model = currentItemList;
                    playerPlaceholder.visible = true;
                    player.imageUrl = currentImageUrl;
                }
            }
            Connections {
                target: root.currentIndex != -1? creator: null
                function onImageUrlChanged() {
                    stageList.currentImageUrl = creator.imageUrl;
                }
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
            onPlay: {
                creatorPlaceholder.visible = false;
                playerPlaceholder.visible = true;
                player.model = creator.model;
                player.imageUrl = creator.imageUrl;
                player.init();
            }
        }
    }
    ColumnLayout {
        id: playerPlaceholder
        anchors.fill: parent
        anchors.margins: 20
        visible: false
        Item {
            Layout.preferredWidth: creatorPlaceholder.width
            Layout.minimumHeight: creatorReturnButton.height
            Button {
                id: playerReturnButton
                text: "< 返回"
                onClicked: {
                    playerPlaceholder.visible = false;
                    if(root.showEditButton) {
                        creatorPlaceholder.visible = true;
                    }
                    else {
                        stageListPlaceholder.visible = true;
                    }
                }
            }
            Label {
                text: professionList.currentName + " - " + stageList.currentName
                anchors.left: playerReturnButton.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Player {
            id: player
            Layout.preferredWidth: creatorPlaceholder.width
            Layout.fillHeight: true
            fontLoader: root.isOnWasm? fontLoader: null
        }
    }
    About {
        id: aboutPopup
        anchors.centerIn: parent
    }
    AboutQt {
        id: aboutQtPopup
        anchors.centerIn: parent
    }
}
