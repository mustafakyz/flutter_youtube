class ChannelModel {
  final String id;
  final String name;
  final String code;

  ChannelModel({this.id, this.name, this.code});

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return new ChannelModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }
}