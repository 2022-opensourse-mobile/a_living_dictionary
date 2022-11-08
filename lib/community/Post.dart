
class Post {
  static int n = 0;
  int id;
  String title;
  String writer_name;
  String writer_id;
  String body;
  int like;
  DateTime? time;
  int boardType;
  String hashTag;

  Post({
    this.id = 0,
    this.title = '',
    this.writer_name = '',
    this.writer_id = '',
    this.body = '',
    this.like = 0,
    this.time,
    this.boardType = 1,
    this.hashTag = ''}) {}
}