import 'dart:io';
import 'dart:math';
// import 'package:aves/screens/side_menu.dart';
// import 'package:avesweb//webview.dart';
import 'package:avesweb/wiki_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:avesweb/sigin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:aves/screens/side_menu.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:logger/logger.dart';
// import 'package:avesweb/reusable_widgets/classifier_quant.dart';
import 'package:image/image.dart' as img;
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// import 'package:aves/screens/webview.dart';

// import '../reusable_widgets/classifier.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late Classifier _classifier;
  // var logger = Logger();
  // late File pickedImage;
  // bool isImageLoaded = false;
  // Image?_imageWidget;
  //
  // Category? category;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _classifier = ClassifierQuant();
  // }
  //
  // getImageFromGallery()async{
  //   var tempStore = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     pickedImage = File(tempStore!.path);
  //     isImageLoaded = true;
  //
  //     _predict();
  //   });
  //
  //   // imageClassification(pickedImage);
  // }
  // void _predict() async{
  //   img.Image imageInput = img.decodeImage(_image.readAsBytesSync())!;
  //   var pred = _classifier.predict(imageInput);
  //
  //   setState(() {
  //     // this.category = pred;
  //   });
  //
  // }
  // // Future imageClassification(File image)
  // // async
  // // {
  // //   var recognitions = await Tflite.runModelOnImage(
  // //     path: image.path,
  // //     numResults: 6,
  // //     threshold: 0.05,
  // //     imageMean: 127.5,
  // //     imageStd: 127.5,
  // //   );
  // //   setState(() {
  // //     _results = recognitions!;
  // //     _image = image;
  // //     imageSelect = true;
  // //   });
  // // }
  //
  // @override
  // // void initState() {
  // //   // TODO: implement initState
  // //   super.initState();
  // //   loadModel();
  // // }
  // // Future loadModel()
  // // async{
  // //   Tflite.close();
  // //   String res;
  // //   res = (await Tflite.loadModel(model: 'assets/tflite_model.tflite', labels: 'assets/label.txt'))!;
  // //   print("Model loading status: $res");
  // // }
  // late File _image;
  // late List _results;
  // bool imageSelect = false;
  // late Classifier _classifier;
  bool link=false;
  // var logger = Logger();

  File? _image;
  final picker = ImagePicker();

  Image? _imageWidget;

  // img.Image? fox;

  // Category? category;
  String mail = "";
  String name = "";

  @override
  void initState() {
    super.initState();
    setState(
        () {
          mail = FirebaseAuth.instance.currentUser!.email!;
        }
    );
    // _classifier = ClassifierQuant();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      name = pickedFile!.name;
      _image = File(pickedFile.path);
      _imageWidget = Image.file(_image!);

      _predict();
    });
  }

  void _predict() async {
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    // var pred = _classifier.predict(imageInput);
    //     setState(() {
    //       link=true;
    //       this.category = pred;
    //     });

        try{
          await FirebaseStorage.instance.ref('$mail/$name').putFile(_image!);
        }on FirebaseException catch (e){print(e);}
        String dt=await FirebaseStorage.instance.ref('$mail/$name').getDownloadURL();
        String date=DateTime.now().toString();
        FirebaseFirestore.instance.collection(mail).doc(date).set({
          // "prediction":category!.label,
          // "confidence":"${(category!.score*100).toStringAsFixed(2)}%",
          "image url":dt,
          "docid":date,
        }).catchError((error) => print("Failed to add new profile due to $error"));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavDrawer(),
      // body: Center(
      //   child: ElevatedButton(
      //     child: Text("Logout"),
      //     onPressed: () {
      //       FirebaseAuth.instance.signOut().then((value) {
      //         print("Signed Out");
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => SignInScreen()));
      //       });
      //     },
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Aves"),
      ),

      // body: Container(
      //   child: Column(
      //     children: [
      //       SizedBox(height: 30,),
      //       isImageLoaded ?
      //           Center(
      //             child: Container(
      //               height: 350,
      //               width: 350,
      //               decoration: BoxDecoration(
      //                 image: DecorationImage(
      //                   image: FileImage(File(pickedImage.path)),
      //                   fit: BoxFit.contain
      //                 )
      //               ),
      //             ),
      //           )
      //           :Container(),
      //       SingleChildScrollView(
      //         child: Column(
      //           children: (imageSelect)?_results.map((results){
      //             return Card(
      //               child: Container(
      //                 margin: EdgeInsets.all(10),
      //                 child: Text(
      //                   "${results['label']} - ${results['confidence'].toStringAsFixed(2)}",
      //                   style: TextStyle(color: Colors.red,fontSize: 20),
      //                 ),
      //               ),
      //             );
      //           }).toList(): [],
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      body: Column(
        children: <Widget>[
          Center(
            child: _image == null
                ? Text('No image selected.')
                : Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: _imageWidget,
            ),
          ),
          SizedBox(
            height: 36,
          ),
          Text(
            // category != null ? category!.label : ''
            '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            // category != null
            //     ? 'Confidence: ${category!.score.toStringAsFixed(3)}'
            //     :
            '',

            style: TextStyle(fontSize: 16),
          ),
          if(link)ElevatedButton(

              style: ButtonStyle(elevation:MaterialStatePropertyAll(3) ),
              onPressed:(){
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => wikiPedia(info.weblink[category!.label]!),));
                  },

              child:
            Text(
              "Click Here",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),),



        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.browse_gallery_outlined),
      ),
    );
  }

}