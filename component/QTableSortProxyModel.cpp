#include "QTableSortProxyModel.h"

#include <QJSValueList>

QTableSortProxyModel::QTableSortProxyModel(QSortFilterProxyModel *parent)
    : QSortFilterProxyModel {parent}
{
    _model = nullptr;
    connect(this,&QTableSortProxyModel::modelChanged,this,[=]{
        setSourceModel(this->model());
    });
}

bool QTableSortProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const{
    QJSValue filter = _filter;
    if(filter.isUndefined()){
        return true;
    }
    QJSValueList data;
    data<<source_row;
    return filter.call(data).toBool();
}

bool QTableSortProxyModel::filterAcceptsColumn(int source_column, const QModelIndex &source_parent) const{
    return true;
}

bool QTableSortProxyModel::lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const{
    QJSValue comparator = _comparator;
    if(comparator.isUndefined()){
        return true;
    }
    QJSValueList data;
    data<<source_left.row();
    data<<source_right.row();
    bool flag = comparator.call(data).toBool();
    if(sortOrder()==Qt::AscendingOrder){
        return !flag;
    }else{
        return flag;
    }
}

void QTableSortProxyModel::setComparator(QJSValue comparator){
    int column = 0;
    if(comparator.isUndefined()){
        column = -1;
    }
    this->_comparator = comparator;
    if(sortOrder()==Qt::AscendingOrder){
        sort(column,Qt::DescendingOrder);
    }else{
        sort(column,Qt::AscendingOrder);
    }
}

void QTableSortProxyModel::setFilter(QJSValue filter){
    this->_filter = filter;
    invalidateFilter();
}

QVariant QTableSortProxyModel::getRow(int rowIndex){
    QVariant result;
    QMetaObject::invokeMethod(_model, "getRow",Q_RETURN_ARG(QVariant, result),Q_ARG(int, mapToSource(index(rowIndex,0)).row()));
    return result;
}

void QTableSortProxyModel::setRow(int rowIndex,QVariant val){
    QMetaObject::invokeMethod(_model, "setRow",Q_ARG(int, mapToSource(index(rowIndex,0)).row()),Q_ARG(QVariant,val));
}

void QTableSortProxyModel::removeRow(int rowIndex,int rows){
    QMetaObject::invokeMethod(_model, "removeRow",Q_ARG(int, mapToSource(index(rowIndex,0)).row()),Q_ARG(int,rows));
}

