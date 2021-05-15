import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new Image.network(
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcdn.vox-cdn.com%2Fthumbor%2F_C1ugN0jUg2uYg5PQOyz4eumEAY%3D%2F0x444%3A7115x5780%2F1200x800%2Ffilters%3Afocal%280x444%3A7115x5780%29%2Fcdn.vox-cdn.com%2Fuploads%2Fchorus_image%2Fimage%2F49565113%2Fshutterstock_333689708.0.0.jpg&refer=http%3A%2F%2Fcdn.vox-cdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1623507447&t=fa12b8de96af39fc66e337d974bcf6ca",
            fit: BoxFit.fill,
          );
        },
        itemCount: 10,
        viewportFraction: 0.8,
        scale: 0.9,
      ),
    );
  }
}
