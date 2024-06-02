
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/postService.dart';
import 'package:flutter_application_1/models/post.dart';

class DetailScreen extends StatefulWidget {
  final int id;  

  const DetailScreen({super.key, required this.id});

  @override
 State <DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>{
 final  _postService = PostService();
  Post ? post;  

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  void _loadPost() async {
    post = await _postService.getPostById(widget.id);
    setState(() {});
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text('Más de ...'),
        centerTitle: true,
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: post == null ? const Center(child: CircularProgressIndicator()) :
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
                  post?.imageUrl ?? '',errorBuilder: (
                    BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const Icon(Icons.broken_image);
              },),
            ),
             SizedBox(height: 15),
            Text(
              post?.title ?? '',
              style:TextStyle(
                fontSize: 20,
                color: Color(0xFF224F34),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
        
              ),
              ),
               SizedBox(height: 15),
              Text(
              post?.autor ?? '',
              style:TextStyle(
                fontSize: 12,
                color: Color(0xFF9B9B9B),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
        
              ),
            ),
             
             SizedBox(height: 15),
            Divider(
              color: Colors.grey, 
              thickness: 1, 
              height: 20, 
            ),
            Text(
              "Descripcion: ",
              style: TextStyle(
                color: Color(0xFF2F2D2C),
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                
                ),
              ),
               SizedBox(height: 15),
            RichText(
                textAlign: TextAlign.justify,  // Justifica el texto de la descripción
                text: TextSpan(
                  style: TextStyle(
                    color: Color(0xFF9B9B9B),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal, 
                    height: 1.5,// Asegúrate de usar la familia de fuentes adecuada
                  ),
                  text: post?.description ?? '',
                ),
              
            )
              

            
          ],
        ),
      ),
    );
  }

}
