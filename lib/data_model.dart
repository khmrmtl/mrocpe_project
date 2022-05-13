class Data {
  final int value;

  Data(this.value);

  Data.fromJson(Map<dynamic, dynamic> json) : value = json['reading'] as int;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'reading': value,
      };
}
