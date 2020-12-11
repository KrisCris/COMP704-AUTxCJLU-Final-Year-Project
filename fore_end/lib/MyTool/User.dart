class User{
  String _userName;
  String _avatar_local;
  String _avatar_remote;

  User({ String username, String avatar="image/avatar.png"}){
    this._userName = username;
    this._avatar_remote = avatar;
    this.dataSynchornize();
  }

  String get userName => _userName;
  String getAvatar(){
    this.dataSynchornize();
    return _avatar_remote;
  }

  void dataSynchornize(){
    //if 有网络
    //  同步远程与本地头像数据并返回头像
    //else
    //  返回本地头像
  }
}