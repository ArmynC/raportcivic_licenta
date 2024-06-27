import QtQuick
import QtQuick.Controls
import Component

QStatusLayout {
    property url source: ""
    property bool lazy: false
    color:"transparent"
    id:control
    onErrorClicked: {
        reload()
    }
    Component.onCompleted: {
        if(!lazy){
            loader.source = control.source
        }
    }
    QLoader{
        id:loader
        anchors.fill: parent
        asynchronous: true
        onStatusChanged: {
            if(status === Loader.Error){
                control.statusMode = QStatusLayoutType.Error
            }else if(status === Loader.Loading){
                control.statusMode = QStatusLayoutType.Loading
            }else{
                control.statusMode = QStatusLayoutType.Success
            }
        }
    }
    function reload(){
        var timestamp = Date.now();
        loader.source = control.source+"?"+timestamp
    }
    function itemLodaer(){
        return loader
    }
}
