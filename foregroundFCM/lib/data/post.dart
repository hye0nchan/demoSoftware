import 'package:http/http.dart' as http;

class Post{
  void getNews(){
    var client = http.Client();
    
    client.get('google.com');
  }
}