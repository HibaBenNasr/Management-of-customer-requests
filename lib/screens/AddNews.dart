import 'package:flutter/material.dart';
import 'package:project_for_pole/widgets/AppBar.dart';
import 'package:project_for_pole/widgets/CustomTextFormField.dart';
import 'package:project_for_pole/widgets/Drawer.dart';
import 'package:project_for_pole/widgets/Methodes.dart';
import 'package:intl/intl.dart';
import 'HomeScreen.dart';

class AddNews extends StatefulWidget {
  const AddNews({Key? key}) : super(key: key);

  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  late String _object;
  late String _message;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar("Ajouter à l'accueil", true),
        drawer: MainDrawer(),
        body: isLoading? Center(
          child: Container(
            height: size.height/20,
            width: size.width/10,
            child: CircularProgressIndicator(),
          ),
        )
            :SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Ajouter\n une publication ",
                style: TextStyle(
                  letterSpacing: 2.0,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 24, right: 24, left: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      _builObject(),
                      SizedBox(
                        height: 20,
                      ),
                      _builMessage(),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: MaterialButton(
                            elevation: 0,
                            color: Color.fromRGBO(42, 159, 244, 1),
                            onPressed: () {

                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              _formKey.currentState!.save();
                              var datetime=new DateTime.now();
                              String date=DateFormat('dd/MM/yyyy').format(datetime)+" "+DateFormat('kk:mm').format(datetime);
                              createNews(_object, _message,date);
                              setState(() {
                                isLoading= true;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomeScreen()));
                            },
                            child: Text(
                              "Envoyer",
                              style: TextStyle(color: Colors.white, fontSize: 24),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _builObject() {
    return TextFormField(
      decoration: inputDecoration("Titre", Icon(Icons.title)),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Objet obligatoire';
        }
        return null;
      },
      onSaved: (String? value) {
        _object = value!;
      },
    );
  }

  Widget _builMessage() {
    return TextFormField(
      maxLines: 9,
      decoration: InputDecoration(
        labelText: "Contenu",
        prefixIcon: Icon(Icons.speaker_notes),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
          borderSide: BorderSide(
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: Colors.blue,width: 2.0),
        ),
      ),
      onSaved: (String? value) {
        _message = value!;
      },
    );
  }
}
