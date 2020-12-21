import 'package:flutter/material.dart';

class MySearchBarDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => "Search foods";


  //初始化加载
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Card(
        color: Colors.redAccent,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSuggest
        : searchList.where((input) => input.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) =>
          ListTile(
            title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: suggestionList[index].substring(query.length),
                          style: TextStyle(
                              color: Colors.grey
                          )
                      )
                    ]
                )
            ),
          ),
    );
  }





}
  const searchList = [
    "zsk",
    "yyz",
    "hpc",
    "yht",
    "apple 苹果 5000 200",
    "bread 面包",
    "cake 蛋糕",
    "dumpling 饺子",
    "egg 鸡蛋",
    "fig 无花果",
    "grape 葡萄",
    "ham 火腿",
    "ice-cream 冰淇凌",
    "jelly 果冻",
    "ketchup 番茄酱",
    "lettuce 莴苣",
    "meat 肉",
    "noodles 面条",
    "onion 洋葱",
    "pea 豌豆",
    "QQSugar QQ糖",
    "rice 米饭",
    "sandwich 三明治",
    "tomato 土豆",
    "ufo？",
    "veal 小牛肉",
    "white gourd 冬瓜容",
    "XO 人头马（洋酒）",
    "yam 山芋",
    "zombie",

  ];

  const recentSuggest = [
    "推荐1-26个字母都可以比如apple",
    "推荐2-开发人员比如zsk"
  ];
