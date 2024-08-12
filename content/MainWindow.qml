import QtQuick

import QtQuick.Controls
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
    FontLoader {
        id: fontLoader
        source: "./font/wqy-microhei.ttc"
    }
    Creator {
        id: creator
        anchors.fill: parent
        anchors.margins: 20
        fontLoader: root.isOnWasm? fontLoader: null
        stageModel: StageModel {}
    }
}
