class RemoteResponse {
  final int id;
  final String choise;

  RemoteResponse({this.id = 0, this.choise = ''});

  factory RemoteResponse.fromJson(Map<String, dynamic> jsonMap) => 
    RemoteResponse(
      id: jsonMap["id"] as int,
      choise: jsonMap["choise"] as String,
    );
}