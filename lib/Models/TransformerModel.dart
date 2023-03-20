class transformerModel{
  String id="";
  String name="";
  double ratedPower=0.0;
  double impedance=0.0;
  String nextMant= "";
  double primaryVolt=0.0;
  double secondaryVolt=0.0;
  int manYear=0;
  String substationId="";

  transformerModel(this.id,this.name,this.ratedPower,this.impedance,this.nextMant,this.primaryVolt,this.secondaryVolt,this.manYear,this.substationId);
  factory transformerModel.fromJson(Map<String,dynamic>json){
    return transformerModel(json['_id'],
        json['name'],
        json['rated_power'],
        json['impedance'],
        json['next_maintenance'],
        json['rated_primary_voltage'],
        json['rated_secondary_voltage'],
        json['year_of_manuacture'],
        json['substation']
       );
  }

}