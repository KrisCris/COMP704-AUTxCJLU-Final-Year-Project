import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:exifdart/exifdart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/FoodRecognizer.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/widgets/basic/DotBox.dart';
import 'package:fore_end/Pages/ResultPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class TakePhotoPage extends StatefulWidget {
  TakePhotoState state;
  CameraDescription camera;
  String waitingText;
  TakePhotoPage({Key key}):super(key:key) {}

  @override
  State<StatefulWidget> createState() {
    this.state = new TakePhotoState();
    return this.state;
  }

  void getCamera() {
    this.state.getCamera();
  }
}

class TakePhotoState extends State<TakePhotoPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  CameraController _ctl;
  Future<void> _initDone;
  bool _hasCamera = true;
  TweenAnimation<double> loadingCameraAnimation = new TweenAnimation<double>();
  TweenAnimation<double> flashAnimation = new TweenAnimation<double>();
  String _path;

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
    this.flashAnimation.initAnimation(0.0, 0.0, 200, this, () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (this._ctl != null) {
      this._ctl.dispose();
    }
    if (this.loadingCameraAnimation != null) {
      this.loadingCameraAnimation.dispose();
    }
    if (this.flashAnimation != null) {
      this.flashAnimation.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (this._ctl == null) {
      widget.waitingText = "Waiting For Camera Launching...";
      return waitingForCameraWidget();
    }

    if (this._ctl.value.isInitialized) {
      return cameraWidget();
    } else {
      if (!this._hasCamera) {
        return noCameraWidget();
      } else {
        widget.waitingText = "Waiting For Camera Launching...";
        return waitingForCameraWidget();
      }
    }
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
    List<CameraDescription> cameras;
    if (widget.camera == null) {
      cameras = await availableCameras();
      if (cameras.length <= 0) {
        this._hasCamera = false;
        return;
      }
      this._hasCamera = true;
      widget.camera = cameras[0];
    }
    if (this._ctl == null) {
      this._ctl = new CameraController(widget.camera, ResolutionPreset.high,
          enableAudio: false);
    }
    if (this._path == null) {
      this._path =
          (await getTemporaryDirectory()).path + '${DateTime.now()}.png';
    }
    if (!this._ctl.value.isInitialized) {
      this._ctl.initialize().then((value) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
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
    DotColumn card = new DotColumn(
        width: 0.7,
        borderRadius: 5,
        children: [
          SizedBox(
            height: 40,
          ),
          Transform.translate(
            offset: Offset(0, this.loadingCameraAnimation.value),
            child:
                Icon(FontAwesomeIcons.camera, color: Colors.blueAccent, size: 40),
          ),
          Container(
            height: 60,
            width: ScreenTool.partOfScreenWidth(0.7),
            child: Text(
              widget.waitingText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Futura",
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 40,
          ),
    ]);
    return new Container(
      width: ScreenTool.partOfScreenWidth(1),
      height:ScreenTool.partOfScreenHeight(1),
      color: Color(0xFF172632),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: ScreenTool.partOfScreenHeight(0.25),
            ),
            card,
            SizedBox(
              height: ScreenTool.partOfScreenHeight(0.25),
            ),
          ],
        ),
      ),
    );
  }

  Widget cameraWidget() {
    Size deviceSize = ScreenTool.pixSize;
    double deviceRatio = deviceSize.width / deviceSize.height;
    double previewRatio = this._ctl.value.aspectRatio;
    double scale = 1;
    if (deviceRatio > previewRatio) {
      scale = deviceRatio / previewRatio;
    } else {
      scale = previewRatio / deviceRatio;
    }
    Widget content = Stack(
      children: [
        Center(
          child: Transform.scale(
            scale: scale,
            child: AspectRatio(
              aspectRatio: this._ctl.value.aspectRatio,
              child: CameraPreview(this._ctl),
            ),
          ),
        ),
        Opacity(
          opacity: this.flashAnimation.value,
          child: Container(
            color: Colors.grey,
          ),
        ),
        Column(
          children: [
            SizedBox(height: ScreenTool.topPadding),
            // Row(
            //   children: [
            //     Expanded(child: SizedBox()),
            //     this.getAlbumButton(),
            //     SizedBox(width: 10),
            //   ],
            // ),
            // SizedBox(height: 10),
            // Row(
            //   children: [
            //     Expanded(child: SizedBox()),
            //     this.getResultButton(),
            //     SizedBox(width: 10),
            //   ],
            // ),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 50),
                this.getAlbumButton(),
                this.getPhotoButton(),
                this.getResultButton(),
                SizedBox(width: 50),
              ],
            ),
            SizedBox(height: ScreenTool.partOfScreenHeight(0.05))
          ],
        ),
      ],
    );
    return content;
  }

  Widget getPhotoButton() {
    return new CustomIconButton(
      icon: FontAwesomeIcons.circle,
      iconSize: 38,
      adjustHeight: 2.5,
      sizeChangeWhenClick: true,
      buttonSize: 45,
      backgroundOpacity: 0.5,
      borderRadius: 45,
      shadows: [
        BoxShadow(
          blurRadius: 10,
          spreadRadius: 3,
          color: Color(0x33000000),
        )
      ],
      onClick: () async {
        await _ctl.takePicture(this._path);
        this.startFlash();
        File pic = File(this._path);
        Map<String, List<int>> res = await this.pictureToBase64(pic);
        pic.delete();
        var entry = res.entries.first;
        FoodRecognizer.addFoodPic(entry.key, entry.value, res['rotate'][0]);
      },
    );
  }

  Widget getAlbumButton() {
    return new CustomIconButton(
      icon: FontAwesomeIcons.image,
      iconSize: 34,
      buttonSize: 45,
      backgroundOpacity: 0.5,
      borderRadius: 10,
      shadows: [
        BoxShadow(
          blurRadius: 10,
          spreadRadius: 3,
          color: Color(0x33000000),
        )
      ],
      onClick: () async {
        File image = await ImagePicker.pickImage(source: ImageSource.gallery);
        if (image == null) return;
        Map<String, Uint8List> res = await this.pictureToBase64(image);
        var entry = res.entries.first;
        FoodRecognizer.addFoodPic(entry.key, entry.value, res['rotate'][0]);
      },
    );
  }

  Widget getResultButton() {
    return new CustomIconButton(
      icon: FontAwesomeIcons.appleAlt,
      iconSize: 34,
      buttonSize: 45,
      backgroundOpacity: 0.5,
      borderRadius: 10,
      shadows: [
        BoxShadow(
          blurRadius: 10,
          spreadRadius: 3,
          color: Color(0x33000000),
        )
      ],
      onClick: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ResultPage(key: GlobalKey<ResultPageState>());
        }));
      },
    );
  }

  void startFlash() {
    this.flashAnimation.initAnimation(0.5, 0, 300, this, () {
      setState(() {});
    });
    this.flashAnimation.beginAnimation();
  }

  Future<Map<String, List<int>>> pictureToBase64(File f) async {
    Uint8List byteData = await f.readAsBytes();
    int rotateAngle = await this.getImageRotateAngular(byteData);
    String bs64 = base64Encode(byteData);
    return {
      bs64: byteData,
      "rotate": [rotateAngle]
    };
  }

  Future<int> getImageRotateAngular(List<int> bytes) async {
    Map<String, dynamic> tags = await readExif(MemoryBlobReader(bytes));
    var orientation = tags['Orientation']; //获取该照片的拍摄方向
    switch (orientation) {
      case 3:
        return 180;
      case 6:
        return 90;
      case 8:
        return -90;
      default:
        return 0;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
