import QtQuick
import Component

Item {

    id:control
    property var _from : Window.window
    property var _to
    property var path
    signal result(var data)

    function launch(argument = {}){
        QRouter.navigate(control.path,argument,control)
    }

    function setResult(data = {}){
        control.result(data)
    }

}
