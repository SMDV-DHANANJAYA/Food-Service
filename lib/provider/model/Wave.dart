class Wave{
  int waveId;
  String waveDate;
  String waveTime;
  String waveLocation;

  Wave({this.waveId, this.waveDate, this.waveTime, this.waveLocation});

  Wave.fromJson(Map<String,dynamic> json){
    waveId = int.parse(json["wave_id"]);
    waveDate = json["wave_date"].toString();
    waveTime = json["wave_time"].toString();
    waveLocation = json["location"].toString();
  }
}