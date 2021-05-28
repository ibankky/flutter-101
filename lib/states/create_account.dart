import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_demo/utility/my_constant.dart';
import 'package:flutter_application_demo/utility/my_dailog.dart';
import 'package:flutter_application_demo/utility/my_style.dart';
import 'package:flutter_application_demo/widgets/show_progress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  double? lat, lng;

  bool load = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formField = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      load = false;
    });
    print('lat= $lat , long =$lng , load = $load');
  }

  Future<Position?> findPosition() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  Container buildName(double size) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: size * 0.6,
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Name';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'Name :',
          prefixIcon: Icon(Icons.fingerprint),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Container buildUser(double size) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: size * 0.6,
      child: TextFormField(
        controller: userController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill User in Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'User :',
          prefixIcon: Icon(Icons.perm_identity),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Container buildPassword(double size) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: size * 0.6,
      child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Password';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'Password :',
          prefixIcon: Icon(Icons.lock_outline),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.blue)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstrant.primary,
        title: Text('Create Account'),
      ),
      body: load ? ShowProgress() : buildCenter(size),
    );
  }

  Center buildCenter(double size) {
    return Center(
      child: Form(
        key: formField,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildName(size),
              buildUser(size),
              buildPassword(size),
              buildMap(size),
              buildCreateAccount(size)
            ],
          ),
        ),
      ),
    );
  }

  Container buildCreateAccount(double size) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      width: size * 0.6,
      child: ElevatedButton.icon(
        style: Mystyle().myButtonStyle(),
        onPressed: () {
          if (formField.currentState!.validate()) {
            String name = nameController.text;
            String user = userController.text;
            String password = passwordController.text;
            print(
                'name = $name , user = $user , password = $password , lat = $lat , lng = $lng');
            insertNewUser(name: name, user: user, password: password);
          }
        },
        icon: Icon(Icons.cloud_upload),
        label: Text('Create Account'),
      ),
    );
  }

  Future<Null> insertNewUser(
      {String? name, String? user, String? password}) async {
    String apiCheckUser =
        'https://www.androidthai.in.th/bigc/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(apiCheckUser).then(
          (value) {
            print('## value = $value');
            if (value.toString() != 'null') {
              normalDialog(context , 'User Duplicate' , 'Please cahange User');
            } else {
              String apiInsertUser = 'https://www.androidthai.in.th/bigc/insertUser.php?isAdd=true&name=$name&user=$user&password=$password&lat=$lat&lng=$lng';
               Dio().get(apiInsertUser).then((value){
                if(value.toString() == 'true'){
                  Navigator.pop(context);
                }else{
                  normalDialog(context, 'Error', 'Please Try agin');
                }
              });
            }
          },
          
        );
  }

  Set<Marker> setMarkers() {
    return [
      Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'Your Here !', snippet: 'Lat = $lat , Lng =$lng')),
    ].toSet();
  }

  Container buildMap(double size) {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(vertical: 16),
      width: size * 0.8,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat!, lng!),
          zoom: 16,
        ),
        onMapCreated: (controller) {},
        markers: setMarkers(),
      ),
    );
  }
}
