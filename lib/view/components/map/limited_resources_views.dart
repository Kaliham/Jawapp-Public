import 'package:app/constants.dart';
import 'package:app/model/limited_resouce.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/view/components/generics/generic_card.dart';
import 'package:app/view/components/popup/limited_resources_popup.dart';
import 'package:app/view/screens/mainscreen/limitedresources_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class _LimitedResourceTag extends StatefulWidget {
  Resource resource;
  final double width, height;
  final bool isSmall;
  bool selected = false;
  Function onTap;
  LimitedResourcesScreenState state;

  _LimitedResourceTag(this.resource,
      {this.width, this.height, this.isSmall = false, this.onTap, this.state});
  @override
  _LimitedResourceTagState createState() => _LimitedResourceTagState();
}

class _LimitedResourceTagState extends State<_LimitedResourceTag> {
  Resource get resource => widget.resource;
  bool selected = false;
  Color get backgroundColor => (selected) ? Colors.blue[200] : Colors.white;
  Color get fontColor =>
      (selected) ? Colors.white : Const.defaultTextStyle.color;
  double get height => widget.height ?? 70;
  double get width => widget.width ?? 140;
  Function get onTap => widget.onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        left: 20,
      ),
      child: GenericCardItem(
        noMargin: true,
        height: height,
        width: width,
        function: () {
          setState(() {
            selected = !selected;
          });
          widget.state.setState(() {
            if (selected) {
              locators.mapService.limitedResourceFilter.add(resource.id);
            } else if (locators.mapService.limitedResourceFilter
                .contains(resource.id)) {
              locators.mapService.limitedResourceFilter.remove(resource.id);
            }
          });

          locators.mapService.changeFilter();
        },
        rightFlex: (widget.isSmall) ? 0 : 1,
        color: backgroundColor,
        rightChild: (widget.isSmall)
            ? Container()
            : Center(
                child: Text(
                  resource.type,
                  style: Const.defaultTextStyle.merge(
                      TextStyle(fontWeight: FontWeight.w400, color: fontColor)),
                  maxLines: 3,
                ),
              ),
        leftChild: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          child: Image.network(
            resource.imgUrl,
            fit: BoxFit.cover,
            height: height,
            width: height,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}

class ResourceTagStrip extends StatefulWidget {
  final List<Resource> resources;
  final double width, height;
  final bool isSmall;
  LimitedResourcesScreenState state;
  ResourceTagStrip(
      {this.resources,
      this.width,
      this.height,
      this.isSmall = false,
      this.state});
  @override
  _ResourceTagStripState createState() => _ResourceTagStripState();
}

class _ResourceTagStripState extends State<ResourceTagStrip> {
  List<Resource> get resources => widget.resources ?? [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: resources.length,
        itemBuilder: (context, index) {
          if (widget.width != null)
            return _LimitedResourceTag(
              resources[index],
              width: widget.width,
              height: widget.height,
              isSmall: widget.isSmall,
              state: widget.state,
            );
          return _LimitedResourceTag(
            resources[index],
            isSmall: widget.isSmall,
            state: widget.state,
          );
        },
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  LimitedResourceModel model;
  PageController _pageController;
  GoogleMapController mapContoller;
  double width = 350.0, height = 160.0;
  int index;
  _StoreCard(this.model, this._pageController, this.mapContoller,
      [this.index = 0]);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * height,
            width: Curves.easeInOut.transform(value) * width,
            child: widget,
          ),
        );
      },
      child: Container(
        child: Stack(
          children: [
            GenericCardItem(
              color: Colors.white,
              leftFlex: 2,
              rightFlex: 5,
              function: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return LimitedResourcesPopup(model);
                  },
                );
              },
              leftChild: Image.network(
                model.imgUrl,
                height: height,
                fit: BoxFit.cover,
              ),
              rightChild: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    model.title + " wowowowowow dowoowowowowow",
                                    style:
                                        Const.defaultTextStyle.merge(TextStyle(
                                      fontSize: 18,
                                      color: Const.accent,
                                      fontWeight: FontWeight.w500,
                                    )),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(flex: 1, child: Container()),
                          Flexible(
                              flex: 5,
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                child: StreamBuilder<List<Resource>>(
                                  stream: model.resources,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return CircularProgressIndicator();
                                    return ResourceTagStrip(
                                      resources: snapshot.data,
                                      width: 50,
                                      isSmall: true,
                                    );
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      height: double.infinity,
                      width: double.infinity,
                      child: FlatButton(
                        child: Icon(
                          Icons.map,
                          color: Const.accent,
                        ),
                        onPressed: moveCamera,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveCamera() {
    CameraPosition cameraPosition = new CameraPosition(
      target: model.position,
      zoom: 14,
    );
    mapContoller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}

class StoresStrip extends StatefulWidget {
  List<LimitedResourceModel> models;
  GoogleMapController mapController;
  PageController pageController;

  StoresStrip({this.models, this.mapController, this.pageController});
  @override
  _StoresStripState createState() => _StoresStripState();
}

class _StoresStripState extends State<StoresStrip> {
  List<LimitedResourceModel> get models => widget.models;
  GoogleMapController get mapContoller => widget.mapController;
  PageController get _pageController => widget.pageController;
  int currentPage;
  @override
  void initState() {
    super.initState();
    _pageController..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page.toInt() != currentPage) {
      currentPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  void moveCamera() {
    CameraPosition cameraPosition = new CameraPosition(
      target: models[currentPage].position,
      zoom: 14,
    );
    mapContoller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView.builder(
        controller: _pageController,
        itemCount: (models ?? []).length,
        itemBuilder: (BuildContext context, int index) {
          return _StoreCard(
              models[index], _pageController, mapContoller, index);
        },
      ),
    );
  }
}
