import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/postService.dart';
import 'package:flutter_application_1/widgets/widgetInput.dart';
import 'package:flutter_application_1/models/post.dart';


class CreatePostScreen extends StatefulWidget {
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final  _postService = PostService();
  Post ? post;


final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  String? _imageUrl;
  String? _autor;

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    try {
      await _postService.createPost(Post(id: 0, title: _title!, description: _description!, imageUrl: _imageUrl!, autor: _autor!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post agregado correctamente'),
          backgroundColor: Color(0xF006414),
        ),
      );

      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar post: $e'),
          backgroundColor: Color(0xF950101),
        ),
      );
    }
  }
}



  

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: 
      Column(
        children: <Widget> [
        Container(
          
      height: 140,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5RbnN1T1PFGAwDw4mLiwiD6pDWwkbQ7J-3Q&s'))),
                  alignment: Alignment.center,
                  child: Text(
                    "Crear publicación",
                    style: TextStyle(
                    color: Colors.white, 
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                  ),
                  ),
                  
                  
                  ),
                  
                  
                  Expanded(child: Container(
        color: Color(0xFFF9F9F9),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 15),
                  WidgetInput(
                    labelText: 'Title',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) => _title = value,
                  ),
                  SizedBox(height: 15),
                  WidgetInput(
                    labelText: 'Description',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (value) => _description = value,
                  ),
                  SizedBox(height: 15),
                  WidgetInput(
                    labelText: 'Image URL',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an image URL';
                      }
                      return null;
                    },
                    onSaved: (value) => _imageUrl = value,
                  ),
                  SizedBox(height: 15),
                  WidgetInput(
                    labelText: 'Author',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter author\'s name';
                      }
                      return null;
                    },
                    onSaved: (value) => _autor = value,
                  ),
                  SizedBox(height: 15),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    
                    child: Text('crear publicación',
                     style: TextStyle(
                      color: Colors.white,
                     ),
                     ),
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF224F34)),                     ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),)
        

      ],)      
    );
  }
}