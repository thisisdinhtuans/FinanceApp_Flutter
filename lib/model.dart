class Comment {
  int? id;
  String? title;
  String? content;
  String? createdOn;
  int? stockId;

  Comment({this.id, this.title, this.content, this.createdOn, this.stockId});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    createdOn = json['createdOn'];
    stockId = json['stockId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['createdOn'] = this.createdOn;
    data['stockId'] = this.stockId;
    return data;
  }
}

class Stock {
  late int id;
  String? symbol;
  String? companyName;
  num? purchase;
  num? lastDiv;
  String? industry;
  num? marketCap;
  List<Comment>? comments;

  Stock({
    required this.id,
    this.symbol,
    this.companyName,
    this.purchase,
    this.lastDiv,
    this.industry,
    this.marketCap,
    this.comments,
  });

  Stock.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    companyName = json['companyName'];
    purchase = json['purchase'];
    lastDiv = json['lastDiv'];
    industry = json['industry'];
    marketCap = json['marketCap'];
    if (json['comments'] != null) {
      comments = <Comment>[];
      json['comments'].forEach((v) {
        comments!.add(Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['symbol'] = symbol;
    data['companyName'] = companyName;
    data['purchase'] = purchase;
    data['lastDiv'] = lastDiv;
    data['industry'] = industry;
    data['marketCap'] = marketCap;
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
