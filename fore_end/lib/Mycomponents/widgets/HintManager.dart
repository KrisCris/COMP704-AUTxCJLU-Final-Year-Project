import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fore_end/MyTool/Hint.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/FoodSearchBar.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/plan/ExtendTimeHint.dart';
import 'package:fore_end/Pages/GuidePage.dart';
import 'package:fore_end/Pages/WelcomePage.dart';
import 'package:fore_end/Pages/account/UpdateBody.dart';

class HintManager {
  static final HintManager _instance = HintManager._privateConstructor();
  static HintManager get instance => _instance;
  HintManager._privateConstructor() {
    hints = {};
  }

  Map<String, Hint> hints;
  GlobalKey<HintBoxState> boxKey;
  GlobalKey<FoodSearchBarState> foodSearchKey;

  Hint getHintByIndex(int i) {
    int index = 0;
    for (Hint ht in this.hints.values) {
      if (index == i) {
        return ht;
      }
      index++;
    }
    return null;
  }

  void removeHint(String name) {
    this.hints.remove(name);
    this.boxKey?.currentState?.setState(() {});
  }

  void receiveHint(BuildContext context) {
    this.hints.clear();
    User u = User.getInstance();
    if (u.isOffline) {
      hints["offlineHint"] = new Hint(
          hintContent: CustomLocalizations.of(context).offlineHint,
          instanceClose: false,
          onClick: () {
            Navigator.pushAndRemoveUntil(context,
                new MaterialPageRoute(builder: (context) {
              return Welcome();
            }), (route) => false);
          });
    }
    if (u.shouldUpdateWeight) {
      hints['weightUpdateHint'] = new Hint(
          instanceClose: false,
          hintContent: CustomLocalizations.of(context).weightUpdateHint,
          onClick: () {
            showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                UpdateBody updateBody = new UpdateBody(
                    text: CustomLocalizations.of(context).beforeChangePlan,
                    needHeight: false);
                updateBody.onUpdate = () async {
                  User u = User.getInstance();
                  Response res = await Requests.finishPlan(context, {
                    "uid": u.uid,
                    "token": u.token,
                    "pid": u.plan?.id ?? -1,
                    "weight": updateBody.weight.widgetValue.value.floor()
                  });
                  if (res != null && res.data['code'] == 1) {
                    this.removeHint("weightUpdateHint");
                    Navigator.pop(context, true);
                  } else {
                    Fluttertoast.showToast(msg: "update failed");
                  }
                };
                return updateBody;
              },
            ).then((val) {
              if (val == true) {
                Navigator.push(context, new MaterialPageRoute(builder: (ctx) {
                  return GuidePage(
                    firstTime: false,
                  );
                }));
              }
            });
          });
    }
    if (u.plan.pastDeadline) {
      this.hints['passDeadlineHint'] = Hint(
          instanceClose: false,
          hintContent: CustomLocalizations.of(context).passDeadlineHint,
          onClick: () async {
            bool b = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ExtendTimeHint(
                  title: CustomLocalizations.of(context).planDelayFor +
                      u.plan.calculatedDelayDays.toString() +
                      CustomLocalizations.of(context).days +
                      "," +
                      CustomLocalizations.of(context).planDelayChoose,
                  onClickAccept: () async {
                    Response res = await Requests.delayPlan(context,
                        {"uid": u.uid, "token": u.token, "pid": u.plan.id});
                    if (res != null && res.data['code'] == 1) {
                      u.plan.extendDays = res.data['data']['ext'];
                      u.save();
                    }
                  },
                );
              },
            );
            //accept delay
            if (b == true) {
              this.removeHint("passDeadLineHint");
              this?.boxKey?.currentState?.setState(() {});
              ;
            }
            //finish plan
            else {
              bool success = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  UpdateBody updt = UpdateBody(
                    text: CustomLocalizations.of(context).beforeChangePlan,
                    needHeight: false,
                    needCancel: false,
                  );
                  updt.onUpdate = () async {
                    Response res = await Requests.finishPlan(context, {
                      "uid": u.uid,
                      "token": u.token,
                      "pid": u.plan.id,
                      "weight": updt.getWeight()
                    });
                    if (res != null && res.data['code'] == 1) {
                      u.bodyWeight = updt.weight.widgetValue.value;
                      Navigator.of(context).pop(true);
                    }
                  };
                  return updt;
                },
              );
              //create new plan after finish plan
              if (success) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return GuidePage(firstTime: false);
                }), (route) {
                  return route == null;
                });
              }
            }
          });
    }
    if (this.hints.length > 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        this
            .foodSearchKey
            ?.currentState
            ?.badgeKey
            ?.currentState
            ?.setHintNumber(this.hints.length);
      });
    }
  }
}

class HintBox extends StatefulWidget {
  HintBox(Key key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new HintBoxState();
  }
}

class HintBoxState extends State<HintBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedCrossFade(
        firstChild: Center(
          child: TitleText(text: CustomLocalizations.of(context).noMessage),
        ),
        secondChild: Row(
          children: [
            SizedBox(width: 15),
            Expanded(
                child: Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: HintManager.instance.hints.length,
                  itemBuilder: (BuildContext ctx, int idx) {
                    return CustomButton(
                      topMargin: 15,
                      bottomMargin: 15,
                      width: ScreenTool.partOfScreenWidth(1) - 60,
                      height: 80,
                      radius: 5,
                      text:
                          HintManager.instance.getHintByIndex(idx).hintContent,
                      firstColorName: ThemeColorName.TransparentShadow,
                      tapFunc: () {
                        HintManager.instance.getHintByIndex(idx).onClick();
                      },
                    );
                  }),
            )),
            SizedBox(width: 15)
          ],
        ),
        crossFadeState: HintManager.instance.hints.length <= 0
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 500),
      ),
      decoration: BoxDecoration(
          color: MyTheme.convert(ThemeColorName.TransparentShadow),
          borderRadius: BorderRadius.circular(5)),
    );
  }
}
