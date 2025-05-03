class OrgModel {
  String? orgName;
  String? orgLogo;
  double? orgLat;
  double? orgLong;

  OrgModel({this.orgName, this.orgLogo, this.orgLat, this.orgLong});

  OrgModel.fromJson(Map<String, dynamic> json) {
    orgName = json['orgName'];
    orgLogo = json['orgLogo'];
    orgLat = (json['orgLat'] as num?)?.toDouble();
    orgLong = (json['orgLong'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'orgName': orgName,
      'orgLogo': orgLogo,
      'orgLat': orgLat,
      'orgLong': orgLong,
    };
  }
}