class Video{
  final String id;
  final String titulo;
  final String thumb;
  final String canal;
  Video({this.id,this.canal,this.thumb,this.titulo});

  factory Video.fromJson(Map<String, dynamic> json){
    if(json.containsKey("id"))
    return Video(
      id:json['id']['videoId'],
      titulo:json['snippet']['title'],
      thumb: json['snippet']['thumbnails']['high']['url'],
      canal:json['snippet']['channelTitle']
    );
    else
    return Video(
      id: json['videoId'],
      titulo: json['titulo'],
      thumb: json['thumb'],
      canal: json['canal']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "videoId": id,
      "titulo": titulo,
      "thumb": thumb,
      "canal": canal
    };
  }
}