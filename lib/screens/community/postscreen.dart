import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/postService.dart';
import 'package:flutter_application_1/widgets/widgetInput.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/screens/community/detatil.dart';
import 'package:flutter_application_1/screens/community/createPostScreen.dart';


class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body:
      
       const PostList()
        
    
    );
  }
  
}

class PostList extends StatefulWidget{
  const PostList({super.key});
  @override
  State <PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList>{
  final  _postService = PostService();
  List _posts = [];

  @override
  void initState(){
    super.initState();
    _cargaPosts();
  }

  void _cargaPosts() async {
    List posts = await _postService.getAllPosts();
    setState(() {
      _posts = posts;
    });
  }
  
  @override
Widget build(BuildContext context) {
  _cargaPosts(); //StatefulWidget lo primero que carga el build por eso es importante hacer ese llamado. 
  
  return Container(
    color: Color(0xFFF9F9F9),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
        Container(
          color: Color(0xFF313131),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
            children:<Widget> [
              ElevatedButton(
                        onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CreatePostScreen()));
                        },
                        child: const Text(
                          'Create Post', 
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                            ),
                        ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, 
              )
            ),

            ],

            ),
          ),
          
        ),

        SizedBox(height: 15),

      Text(
        
            "Publicaciones recientes",  // Título de la lista
            style: TextStyle(
              fontSize: 17.0,  // Tamaño del texto
              color: Color(0xFF494949),
            ),
      ),
      SizedBox(height: 15),

      Expanded(
        
        child:ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return Card(
          color: Color(0xFFFFFFFF),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Image.network(
                  _posts[index].imageUrl,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const Icon(Icons.broken_image);
                  },
                ),
                title: Text(
                  _posts[index].title,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF224F34)
                  ),
                  ),
                subtitle: Text(
                  _posts[index].autor,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9B9B9B)
                  ),
                  ),
              ),
              ButtonBar(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen( id:_posts[index].id)));
                    },
                    child: const Text(
                      'Ver más',
                      style: TextStyle(
                        color: Colors.white,
                      ),
    
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF224F34),
                        padding: EdgeInsets.symmetric(vertical: 0.1),
                      ),
                  ),
                ],
              ),
            ],
          ),
        );  
            
          
        },
      ),

      ),

      ]
        
        
        )
      
    );
}



}




