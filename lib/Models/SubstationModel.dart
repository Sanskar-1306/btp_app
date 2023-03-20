import 'package:btp_app/Models/LTModel.dart';
import 'package:btp_app/Models/TransformerModel.dart';
import 'package:btp_app/Models/RMUModel.dart';
import 'package:btp_app/Models/LineModel.dart';


class SubstationModel{
    String id="";
    String name="";
    LTModel lt = LTModel(0,0,0,0);
    List<transformerModel> trList= [];
    RMUModel rmu = RMUModel(0, 0);
    locationPoint location = locationPoint(0, 0);

    SubstationModel(this.id,this.name,this.lt,this.trList,this.rmu,this.location);
  }

}