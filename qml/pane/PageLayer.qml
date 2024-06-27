import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Component 1.0
import module

QWindow {

    id:window
    width: 800
    height: 600
    minimumWidth: 520
    minimumHeight: 200
    launchMode: QWindowType.SingleInstance
    onInitArgument:
        (arg)=>{
            window.title = arg.title
            loader.setSource(arg.url,{animationEnabled:false})
        }
    QLoader{
        id: loader
        anchors.fill: parent
    }
}
