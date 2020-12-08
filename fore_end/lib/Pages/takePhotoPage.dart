import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/screenTool.dart';

class TakePhotoPage extends StatefulWidget {
  TakePhotoState state;
  CameraDescription camera;
  TakePhotoPage() {}

  @override
  State<StatefulWidget> createState() {
    this.state = new TakePhotoState();
    return this.state;
  }

  void getCamera(){
    this.state.getCamera();
  }
}

class TakePhotoState extends State<TakePhotoPage>
    with TickerProviderStateMixin {

  CameraController _ctl;
  Future<void> _initDone;
  bool _hasCamera = true;
  TweenAnimation loadingCameraAnimation = new TweenAnimation();

  @override
  void initState() {
    super.initState();
    this.loadingCameraAnimation.initAnimation(0.0, -10.0, 1000, this, () {
      setState(() {});
    });
    this.loadingCameraAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.loadingCameraAnimation.reverseAnimation();
      } else if (status == AnimationStatus.dismissed) {
        this.loadingCameraAnimation.beginAnimation();
      }
    });
    this.loadingCameraAnimation.beginAnimation();
  }
  @override
  void dispose() {
    this._ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this._initDone,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.done){
              return cameraWidget();
          }else if(!this._hasCamera){
            return noCameraWidget();
          }
          return waitingForCameraWidget();
        });
  }

  void getCamera() async {
    if(widget.camera != null)return;

    final cameras = await availableCameras();
    if (cameras.length <= 0) {
      this._hasCamera = false;
      return;
    }
    this._hasCamera = true;
    widget.camera = cameras[0];
    this._ctl = new CameraController(widget.camera, ResolutionPreset.medium);
    this._initDone = this._ctl.initialize();
  }

  Widget noCameraWidget() {
    double marginHor = ScreenTool.partOfScreenWidth(0.2);
    double marginTop = ScreenTool.partOfScreenHeight(0.25);
    Card card = new Card(
      elevation: 12.0,
      margin: EdgeInsets.fromLTRB(marginHor, marginTop, marginHor, marginTop),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 40,
          ),
          Icon(FontAwesomeIcons.camera, color: Colors.deepOrange, size: 60),
          Text(
            "Your device has no available camera",
            textAlign: TextAlign.center,
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Futura",
                color: Colors.black),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
    return new Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: card,
    );
  }
  Widget waitingForCameraWidget() {
    double marginHor = ScreenTool.partOfScreenWidth(0.2);
    double marginTop = ScreenTool.partOfScreenHeight(0.25);
    Card card = new Card(
      margin: EdgeInsets.fromLTRB(marginHor, marginTop, marginHor, marginTop),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 40,
          ),
          Transform.translate(
            offset: Offset(0, this.loadingCameraAnimation.getValue()),
            child: Icon(FontAwesomeIcons.camera,
                color: Colors.blueAccent, size: 40),
          ),
          Text(
            "Waiting For Loading Camera",
            textAlign: TextAlign.center,
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Futura",
                color: Colors.black),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
    return new Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: card,
    );
    ;
  }
  Widget cameraWidget(){
    Widget content = new Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: CameraPreview(this._ctl),
    );
    return content;
  }
}
