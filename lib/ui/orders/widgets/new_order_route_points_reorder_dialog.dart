import 'package:booking/models/main_application.dart';
import 'package:booking/models/preferences.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/ui/route_point/route_point_screen.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class NewOrderRoutePointsReorderDialog extends StatefulWidget {
  @override
  State<NewOrderRoutePointsReorderDialog> createState() => new _NewOrderRoutePointsReorderDialogState();
}

class _NewOrderRoutePointsReorderDialogState extends State<NewOrderRoutePointsReorderDialog> {
  int _indexOfKey(Key key) {
    return MainApplication().curOrder.routePoints.indexWhere((RoutePoint d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    return MainApplication().curOrder.reorderRoutePoints(item, newPosition);
  }

  void _reorderDone(Key item) {
    final draggedItem = MainApplication().curOrder.routePoints[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.name}}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await MainApplication().curOrder.routePoints.first.checkPickUp();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              await MainApplication().curOrder.routePoints.first.checkPickUp();
              Navigator.pop(context);
            },
          ),
          title: Text("Корректировка маршрута"),
        ),
        body: ReorderableList(
          onReorder: this._reorderCallback,
          onReorderDone: this._reorderDone,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                sliver: StreamBuilder<List<RoutePoint>>(
                    stream: AppBlocs().orderRoutePointsStream,
                    builder: (context, snapshot) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (index == MainApplication().curOrder.routePoints.length) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: FlatButton.icon(
                                      icon: Icon(Icons.add),
                                      label: Text("Добавить"),
                                      onPressed: () async {
                                        RoutePoint routePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen()));
                                        if (routePoint != null) {
                                          MainApplication().curOrder.addRoutePoint(routePoint);
                                        }
                                      },
                                    ),
                                  ),
                                  Container(height: 40, child: VerticalDivider(color: Preferences().mainColor)),
                                  Expanded(
                                    child: FlatButton.icon(
                                      icon: Icon(Icons.cached),
                                      label: Text("Обратно"),
                                      onPressed: MainApplication().curOrder.routePoints.first.placeId == MainApplication().curOrder.routePoints.last.placeId
                                          ? null
                                          : () => MainApplication().curOrder.addRoutePoint(RoutePoint.copy(MainApplication().curOrder.routePoints.first)),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Item(
                              data: MainApplication().curOrder.routePoints[index],
                              // first and last attributes affect border drawn during dragging
                              isFirst: index == 0,
                              isLast: index == MainApplication().curOrder.routePoints.length - 1,
                            );
                          },
                          childCount: MainApplication().curOrder.routePoints.length + 1,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  Item({
    this.data,
    this.isFirst,
    this.isLast,
  });

  final RoutePoint data;
  final bool isFirst;
  final bool isLast;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy || state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.white);
    }

    // For iOS dragging mdoe, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = ReorderableListener(
      child: Container(
        padding: EdgeInsets.only(right: 18.0, left: 18.0),
        color: Color(0x08000000),
        child: Center(
          child: Icon(Icons.import_export, color: Color(0xFF888888)),
        ),
      ),
    );

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: () {
                        MainApplication().curOrder.deleteRoutePoint(data.key);
                      }),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 14.0,
                      ),
                      child: Text(
                        data.name,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                  // Triggers the reordering
                  dragHandle,
                ],
              ),
            ),
          )),
    );

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: data.key, //
      childBuilder: _buildChild,
    );
  }
}
