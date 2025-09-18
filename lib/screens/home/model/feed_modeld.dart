class FeedModel {
  FeedModelUser? user;
  List<dynamic>? banners;
  List<CategoryDict>? categoryDict;
  List<Feed>? results;
  bool? status;
  bool? next;

  FeedModel({this.user, this.banners, this.categoryDict, this.results, this.status, this.next});

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
    user: json["user"] == null ? null : FeedModelUser.fromJson(json["user"]),
    banners: json["banners"] == null ? [] : List<dynamic>.from(json["banners"]!.map((x) => x)),
    categoryDict: json["category_dict"] == null
        ? []
        : List<CategoryDict>.from(json["category_dict"]!.map((x) => CategoryDict.fromJson(x))),
    results: json["results"] == null ? [] : List<Feed>.from(json["results"]!.map((x) => Feed.fromJson(x))),
    status: json["status"],
    next: json["next"],
  );
}

class CategoryDict {
  double? id;
  String? title;

  CategoryDict({this.id, this.title});
  factory CategoryDict.fromJson(Map<String, dynamic> json) => CategoryDict(
    id: json["id"] is String ? double.tryParse(json["id"]) : (json["id"]?.toDouble()),
    title: json["title"],
  );
}

class Feed {
  int? id;
  String? description;
  String? image;
  String? video;
  List<int>? likes;
  List<dynamic>? dislikes;
  List<dynamic>? bookmarks;
  List<int>? hide;
  DateTime? createdAt;
  bool? follow;
  ResultUser? user;

  Feed({
    this.id,
    this.description,
    this.image,
    this.video,
    this.likes,
    this.dislikes,
    this.bookmarks,
    this.hide,
    this.createdAt,
    this.follow,
    this.user,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
    id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
    description: json["description"]?.toString(),
    image: json["image"]?.toString(),
    video: json["video"]?.toString(),
    likes: json["likes"] == null
        ? []
        : List<int>.from(json["likes"].map((x) => x is int ? x : int.parse(x.toString()))),
    dislikes: json["dislikes"] == null ? [] : List<dynamic>.from(json["dislikes"]),
    bookmarks: json["bookmarks"] == null ? [] : List<dynamic>.from(json["bookmarks"]),
    hide: json["hide"] == null ? [] : List<int>.from(json["hide"].map((x) => x is int ? x : int.parse(x.toString()))),
    createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"].toString()),
    follow: json["follow"] as bool?,
    user: json["user"] == null ? null : ResultUser.fromJson(json["user"]),
  );
}

class ResultUser {
  int? id;
  String? name;
  dynamic image;

  ResultUser({this.id, this.name, this.image});

  factory ResultUser.fromJson(Map<String, dynamic> json) =>
      ResultUser(id: json["id"], name: json["name"], image: json["image"]);
}

class FeedModelUser {
  int? id;
  String? uniqueId;
  dynamic name;
  int? phone;
  dynamic image;
  int? coins;
  dynamic credit;
  dynamic debit;

  FeedModelUser({this.id, this.uniqueId, this.name, this.phone, this.image, this.coins, this.credit, this.debit});

  factory FeedModelUser.fromJson(Map<String, dynamic> json) => FeedModelUser(
    id: json["id"] is String ? int.tryParse(json["id"]) : json["id"],
    uniqueId: json["unique_id"],
    name: json["name"],
    phone: json["phone"] is String ? int.tryParse(json["phone"]) : json["phone"],
    image: json["image"],
    coins: json["coins"] is String ? int.tryParse(json["coins"]) : json["coins"],
    credit: json["credit"],
    debit: json["debit"],
  );
}
