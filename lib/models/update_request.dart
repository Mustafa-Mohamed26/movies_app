class UpdateRequest {
  //String? email;
  int? avaterId;
  String? name;
  String? phone;

  UpdateRequest({ this.avaterId, this.name, this.phone});

  UpdateRequest.fromJson(Map<String, dynamic> json) {
    //email = json['email'];
    avaterId = json['avaterId'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['email'] = email;
    data['avaterId'] = avaterId;
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}
