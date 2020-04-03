class HomeModel {
  String code;
  String message;
  Data data;

  HomeModel({this.code, this.message, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Slides> slides;
  List<Recommend> recommend;
  Floor1Pic floor1Pic;
  List<Floor1> floor1;
  List<Category> category;

  Data(
      {this.slides,
      this.recommend,
      this.floor1Pic,
      this.floor1,
      this.category});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['slides'] != null) {
      slides = new List<Slides>();
      json['slides'].forEach((v) {
        slides.add(new Slides.fromJson(v));
      });
    }
    if (json['recommend'] != null) {
      recommend = new List<Recommend>();
      json['recommend'].forEach((v) {
        recommend.add(new Recommend.fromJson(v));
      });
    }
    floor1Pic = json['floor1Pic'] != null
        ? new Floor1Pic.fromJson(json['floor1Pic'])
        : null;
    if (json['floor1'] != null) {
      floor1 = new List<Floor1>();
      json['floor1'].forEach((v) {
        floor1.add(new Floor1.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = new List<Category>();
      json['category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.slides != null) {
      data['slides'] = this.slides.map((v) => v.toJson()).toList();
    }
    if (this.recommend != null) {
      data['recommend'] = this.recommend.map((v) => v.toJson()).toList();
    }
    if (this.floor1Pic != null) {
      data['floor1Pic'] = this.floor1Pic.toJson();
    }
    if (this.floor1 != null) {
      data['floor1'] = this.floor1.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slides {
  String image;
  String goodsId;

  Slides({this.image, this.goodsId});

  Slides.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    goodsId = json['goodsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['goodsId'] = this.goodsId;
    return data;
  }
}

class RecommendData {
  String code;
  String message;
  List<Recommend> data;

  RecommendData({this.code, this.message, this.data});

  RecommendData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Recommend>();
      json['data'].forEach((v) {
        data.add(new Recommend.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Recommend {
  String name;
  String image;
  double presentPrice;
  String goodsId;
  double oriPrice;

  Recommend(
      {this.name, this.image, this.presentPrice, this.goodsId, this.oriPrice});

  Recommend.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    presentPrice = json['presentPrice'];
    goodsId = json['goodsId'];
    oriPrice = json['oriPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['presentPrice'] = this.presentPrice;
    data['goodsId'] = this.goodsId;
    data['oriPrice'] = this.oriPrice;
    return data;
  }
}

class Floor1Pic {
  String pICTUREADDRESS;
  String tOPLACE;

  Floor1Pic({this.pICTUREADDRESS, this.tOPLACE});

  Floor1Pic.fromJson(Map<String, dynamic> json) {
    pICTUREADDRESS = json['PICTURE_ADDRESS'];
    tOPLACE = json['TO_PLACE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PICTURE_ADDRESS'] = this.pICTUREADDRESS;
    data['TO_PLACE'] = this.tOPLACE;
    return data;
  }
}

class CategoryData {
  String code;
  String message;
  List<Category> data;

  CategoryData({this.code, this.message, this.data});

  CategoryData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Category>();
      json['data'].forEach((v) {
        data.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String firstCategoryId;
  String firstCategoryName;
  List<SecondCategoryVO> secondCategoryVO;
  Null comments;
  String image;

  Category(
      {this.firstCategoryId,
      this.firstCategoryName,
      this.secondCategoryVO,
      this.comments,
      this.image});

  Category.fromJson(Map<String, dynamic> json) {
    firstCategoryId = json['firstCategoryId'];
    firstCategoryName = json['firstCategoryName'];
    if (json['secondCategoryVO'] != null) {
      secondCategoryVO = new List<SecondCategoryVO>();
      json['secondCategoryVO'].forEach((v) {
        secondCategoryVO.add(new SecondCategoryVO.fromJson(v));
      });
    }
    comments = json['comments'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstCategoryId'] = this.firstCategoryId;
    data['firstCategoryName'] = this.firstCategoryName;
    if (this.secondCategoryVO != null) {
      data['secondCategoryVO'] =
          this.secondCategoryVO.map((v) => v.toJson()).toList();
    }
    data['comments'] = this.comments;
    data['image'] = this.image;
    return data;
  }
}

class SecondCategoryVO {
  String secondCategoryId;
  String firstCategoryId;
  String secondCategoryName;
  String comments;

  SecondCategoryVO(
      {this.secondCategoryId,
      this.firstCategoryId,
      this.secondCategoryName,
      this.comments});

  SecondCategoryVO.fromJson(Map<String, dynamic> json) {
    secondCategoryId = json['secondCategoryId'];
    firstCategoryId = json['firstCategoryId'];
    secondCategoryName = json['secondCategoryName'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['secondCategoryId'] = this.secondCategoryId;
    data['firstCategoryId'] = this.firstCategoryId;
    data['secondCategoryName'] = this.secondCategoryName;
    data['comments'] = this.comments;
    return data;
  }
}

class Floor1 {
  String image;
  String goodsId;

  Floor1({this.image, this.goodsId});

  Floor1.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    goodsId = json['goodsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['goodsId'] = this.goodsId;
    return data;
  }
}
