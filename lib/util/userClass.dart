class User {
  int id;
  String nickname;
  String message;
  double latitude;
  double longitude;
  String activity;

  User({this.id, this.nickname, this.message, this.latitude, this.longitude,
      this.activity});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nickname = json['nickname'],
        message = json['message'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        activity = json['activity'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'message': message,
        'latitude': latitude,
        'longitude': longitude,
        'activity': activity,
      };
}
