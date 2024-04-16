class Comment {
  int? id;
  int? userId;
  int? postId;
  String? body;
  String? createdAt;
  String? updatedAt;
  int? favoriteCount;
  int? isFavorited;
  String? userImageUrl;
  int? repliesCount;
  List<CommentReplies>? commentReplies;
  CommentUser? commentUser;


  Comment(
      {this.id,
        this.userId,
        this.postId,
        this.body,
        this.createdAt,
        this.updatedAt,
        this.favoriteCount,
        this.isFavorited,
        this.userImageUrl,
        this.repliesCount,
        this.commentReplies,
        this.commentUser});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    postId = json['post_id'];
    body = json['body'];
    createdAt = json['created_at'];
    userImageUrl = json['user_image_url'];
    repliesCount = json['replies_count'];
    if (json['comment_replies'] != null) {
      commentReplies = <CommentReplies>[];
      json['comment_replies'].forEach((v) {
        commentReplies!.add(new CommentReplies.fromJson(v));
      });
    }
    commentUser = json['user'] != null ? new CommentUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['favoriteCount'] = this.favoriteCount;
    data['isFavorited'] = this.isFavorited;
    data['user_image_url'] = this.userImageUrl;
    data['replies_count'] = this.repliesCount;
    if (this.commentReplies != null) {
      data['comment_replies'] =
          this.commentReplies!.map((v) => v.toJson()).toList();
    }
    if (this.commentUser != null) {
      data['user'] = this.commentUser!.toJson();
    }
    return data;
  }
}

class CommentReplies {
  int? id;
  String? body;
  int? userId;
  int? commentId;
  String? createdAt;
  String? updatedAt;
  String? userImageUrl;
  ReplyUser? replyUser;

  CommentReplies(
      {this.id,
        this.body,
        this.userId,
        this.commentId,
        this.createdAt,
        this.updatedAt,
        this.userImageUrl,
        this.replyUser});

  CommentReplies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    userId = json['user_id'];
    commentId = json['comment_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userImageUrl = json['user_image_url'];
    replyUser = json['user'] != null ? new ReplyUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['body'] = this.body;
    data['user_id'] = this.userId;
    data['comment_id'] = this.commentId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_image_url'] = this.userImageUrl;
    if (this.replyUser != null) {
      data['user'] = this.replyUser!.toJson();
    }
    return data;
  }
}

class ReplyUser {
  int? id;
  String? name;
  String? username;
  String? email;
  Null emailVerifiedAt;
  String? image;
  String? bio;
  String? phoneNumber;
  String? dateOfBirth;
  String? occupation;
  int? public;
  int? roleId;
  String? deviceToken;
  String? price;
  String? createdAt;
  String? updatedAt;
  String? resetPasswordToken;
  int? followerCount;
  int? followingCount;
  bool? followingMe;
  bool? followed;
  String? userImageUrl;
  int? postCount;

  ReplyUser(
      {this.id,
        this.name,
        this.username,
        this.email,
        this.emailVerifiedAt,
        this.image,
        this.bio,
        this.phoneNumber,
        this.dateOfBirth,
        this.occupation,
        this.public,
        this.roleId,
        this.deviceToken,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.resetPasswordToken,
        this.followerCount,
        this.followingCount,
        this.followingMe,
        this.followed,
        this.userImageUrl,
        this.postCount});

  ReplyUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    image = json['image'];
    bio = json['bio'];
    phoneNumber = json['phone_number'];
    dateOfBirth = json['date_of_birth'];
    occupation = json['occupation'];
    public = json['public'];
    roleId = json['role_id'];
    deviceToken = json['device_token'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    resetPasswordToken = json['reset_password_token'];
    followerCount = json['followerCount'];
    followingCount = json['followingCount'];
    followingMe = json['followingMe'];
    followed = json['followed'];
    userImageUrl = json['user_image_url'];
    postCount = json['postCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['image'] = this.image;
    data['bio'] = this.bio;
    data['phone_number'] = this.phoneNumber;
    data['date_of_birth'] = this.dateOfBirth;
    data['occupation'] = this.occupation;
    data['public'] = this.public;
    data['role_id'] = this.roleId;
    data['device_token'] = this.deviceToken;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['reset_password_token'] = this.resetPasswordToken;
    data['followerCount'] = this.followerCount;
    data['followingCount'] = this.followingCount;
    data['followingMe'] = this.followingMe;
    data['followed'] = this.followed;
    data['user_image_url'] = this.userImageUrl;
    data['postCount'] = this.postCount;
    return data;
  }
}

class CommentUser {
  int? id;
  String? name;
  String? image;
  int? followerCount;
  int? followingCount;
  bool? followingMe;
  bool? followed;
  String? userImageUrl;
  int? postCount;

  CommentUser(
      {this.id,
        this.name,
        this.image,
        this.followerCount,
        this.followingCount,
        this.followingMe,
        this.followed,
        this.userImageUrl,
        this.postCount});

  CommentUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    followerCount = json['followerCount'];
    followingCount = json['followingCount'];
    followingMe = json['followingMe'];
    followed = json['followed'];
    userImageUrl = json['user_image_url'];
    postCount = json['postCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['followerCount'] = this.followerCount;
    data['followingCount'] = this.followingCount;
    data['followingMe'] = this.followingMe;
    data['followed'] = this.followed;
    data['user_image_url'] = this.userImageUrl;
    data['postCount'] = this.postCount;
    return data;
  }
}
