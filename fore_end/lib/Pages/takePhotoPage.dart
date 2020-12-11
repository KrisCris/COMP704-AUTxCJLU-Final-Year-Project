import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/screenTool.dart';

class TakePhotoPage extends StatefulWidget {
  TakePhotoState state;
  CameraDescription camera;
  String waitingText;
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
            if(this._ctl.value.isInitialized){
              return cameraWidget();
            }else{
              widget.waitingText="Camera Launch Failed, Please Check the Permission";
              return waitingForCameraWidget();
            }
          }else if(!this._hasCamera){
            return noCameraWidget();
          }else{
            widget.waitingText="Waiting For Camera Launching...";
            return waitingForCameraWidget();
          }
        });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (this._ctl == null || !this._ctl.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      this._ctl?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (this._ctl != null) {
        onNewCameraSelected(this._ctl.description);
      }
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (this._ctl != null) {
      await this._ctl.dispose();
    }
    this._ctl = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    this._ctl.addListener(() {
      if (mounted) setState(() {});
      if (this._ctl.value.hasError) {
        print('Camera error ${this._ctl.value.errorDescription}');
      }
    });

    try {
      await this._ctl.initialize();
    } on CameraException catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {});
    }
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
    this._ctl = new CameraController(widget.camera, ResolutionPreset.high,enableAudio: false);
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
            widget.waitingText,
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
