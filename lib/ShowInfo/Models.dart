
class GambitModel {
  final String descript;
  final int id;
  final int selected;

  GambitModel({
    this.descript,
    this.id,
    this.selected
  });

  factory GambitModel.fromJson(Map<String,dynamic> json){
      return GambitModel(
        descript: json['descript'],
        id: json['id'],
        selected: 0
      );
  }
}