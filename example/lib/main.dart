import 'package:api_request/api_request.dart';
import 'package:flutter/material.dart';

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  @override
  String toString() {
    return 'Post{' +
        ' id: $id,' +
        ' userId: $userId,' +
        ' title: $title,' +
        ' body: $body,' +
        '}';
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      body: map['body'],
    );
  }
}

class PostsResponse {
  List<Post>? posts;
  PostsResponse({this.posts});

  PostsResponse.fromList(List<dynamic>? data) {
    if (data is List) {
      this.posts = <Post>[];
      data.forEach((item) => this.posts?.add(Post.fromMap(item)));
    }
  }
}

class PostsRequestAction extends RequestAction<PostsResponse, ApiRequest> {
  @override
  bool get authRequired => false;

  @override
  Future<PostsResponse> execute({ApiRequest? request}) async {
    return PostsResponse.fromList(await get());
  }

  @override
  String get path => 'posts';
}

void main() {
  //config api requests;
  ApiRequestOptions.instance?.config(
    baseUrl: 'https://jsonplaceholder.typicode.com/',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api Request Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Api Request Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post>? posts = <Post>[];

  @override
  initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    PostsResponse response = await PostsRequestAction().execute();
    setState(() {
      posts = response.posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: (posts?.isNotEmpty ?? false)
            ? ListView.builder(
                itemCount: posts?.length,
                itemBuilder: (_, index) => ListTile(
                      title: Text(posts?[index].title ?? ''),
                    ))
            : CircularProgressIndicator(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}