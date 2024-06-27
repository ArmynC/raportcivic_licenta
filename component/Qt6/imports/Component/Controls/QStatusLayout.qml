import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Component

Item{
    id:control
    default property alias content: container.data
    property int statusMode: QStatusLayoutType.Loading
    property string loadingText:"正在加载..."
    property string emptyText: "空空如也"
    property string errorText: "页面出错了.."
    property string errorButtonText: "重新加载"
    property color color: QTheme.dark ? Window.active ?  Qt.rgba(38/255,44/255,54/255,1) : Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
    signal errorClicked
    property Component loadingItem : com_loading
    property Component emptyItem : com_empty
    property Component errorItem : com_error

    Item{
        id:container
        anchors.fill: parent
        visible: statusMode===QStatusLayoutType.Success
    }
    QLoader{
        id:loader
        anchors.fill: parent
        visible: statusMode!==QStatusLayoutType.Success
        sourceComponent: {
            if(statusMode === QStatusLayoutType.Loading){
                return loadingItem
            }
            if(statusMode === QStatusLayoutType.Empty){
                return emptyItem
            }
            if(statusMode === QStatusLayoutType.Error){
                return errorItem
            }
            return undefined
        }
    }
    Component{
        id:com_loading
        QFrame{
            padding: 0
            border.width: 0
            radius: 0
            color:control.color
            ColumnLayout{
                anchors.centerIn: parent
                QProgressRing{
                    indeterminate: true
                    Layout.alignment: Qt.AlignHCenter
                }
                QText{
                    text:control.loadingText
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
    Component {
        id:com_empty
        QFrame{
            padding: 0
            border.width: 0
            radius: 0
            color:control.color
            ColumnLayout{
                anchors.centerIn: parent
                QText{
                    text:control.emptyText
                    font: QTextStyle.BodyStrong
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
    Component{
        id:com_error
        QFrame{
            padding: 0
            border.width: 0
            radius: 0
            color:control.color
            ColumnLayout{
                anchors.centerIn: parent
                QText{
                    text:control.errorText
                    font: QTextStyle.BodyStrong
                    Layout.alignment: Qt.AlignHCenter
                }
                QFilledButton{
                    id:btn_error
                    Layout.alignment: Qt.AlignHCenter
                    text:control.errorButtonText
                    onClicked:{
                        control.errorClicked()
                    }
                }
            }
        }
    }
    function showSuccessView(){
        statusMode = QStatusLayoutType.Success
    }
    function showLoadingView(){
        statusMode = QStatusLayoutType.Loading
    }
    function showEmptyView(){
        statusMode = QStatusLayoutType.Empty
    }
    function showErrorView(){
        statusMode = QStatusLayoutType.Error
    }
}
