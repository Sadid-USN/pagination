class Famaly {
  String? father;
  String? mother;
  int? fatherAge;
  int? motherAge;
  List<Children>? children;
  Famaly({
    this.father,
    this.mother,
    this.fatherAge,
    this.motherAge,
    this.children,
  });

  factory Famaly.fromJson(Map<String, dynamic> json) {
    var list = json['children'] as List;
    List<Children> children = list
        .map(
          (children) => Children.fromJson(children),
        )
        .toList();
    return Famaly(
      father: json['father'],
      mother: json['mother'],
      fatherAge: json['fatherAge'],
      motherAge: json['motherAge'],
      children: children,
    );
  }
}

class Children {
  String? son;
  String? daughter;
  int? sonAge;
  int? daughterAge;
  Children({
    this.son,
    this.daughter,
    this.daughterAge,
    this.sonAge,
  });

  factory Children.fromJson(Map<String, dynamic> json) {
    return Children(
      son: json['son'],
      daughter: json['daughter'],
      daughterAge: json['daughterAge'],
      sonAge: json['sonAge'],
    );
  }
}
