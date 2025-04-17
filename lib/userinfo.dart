// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:intl/intl.dart';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Userinfo extends StatefulWidget {
  const Userinfo({super.key});

  @override
  State<Userinfo> createState() => _UserinfoState();
}

class _UserinfoState extends State<Userinfo> {
  bool isUserLoaded = false;
  String gender = '';
  String name = '';
  String location = '';
  String email = '';
  String username = '';
  String birth = '';
  String phone = '';
  String cell = '';
  String age = '';
  String imageUrl = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
        appBar: AppBar(
          centerTitle: true, 
          title: Text('User Info'),
          backgroundColor: Colors.cyan[100],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              height: 900, // or whatever size fits your design
              width: 600,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isUserLoaded) ...[
                      if (imageUrl.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                        ),
                      SizedBox(height: 16),
                      Text(name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text('Username: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(username),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Age: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(age),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Gender: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(gender),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Expanded(child: Text(email)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Birth Date: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(birth),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Address: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Expanded(child: Text(location))
                        ],
                      ),
                      Row(
                        children: [
                          Text('Phone: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(phone),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Cell: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(cell),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                    if (errorMessage.isNotEmpty) ...[
                    Text(errorMessage, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                  ],
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(onPressed: onPressed, child: Text('Load User'))
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  Future<void> onPressed() async {
    var response = 
      await http.get(Uri.parse('http://randomuser.me/api/'));
    //log(response.statusCode.toString());
    //log(response.body.toString());
    if(response.statusCode == 200){
      isUserLoaded = true;
      var data = json.decode(response.body);
      gender = (data['results'][0]['gender']);
      name = (data['results'][0]['name']['title']
              + ' ' + data['results'][0]['name']['first']
              + ' ' + data['results'][0]['name']['last']);
      location = (data['results'][0]['location']['street']['number'].toString()
                  + ' ' + data['results'][0]['location']['street']['name']
                  + ' ,' + data['results'][0]['location']['city']
                  + ' ,' + data['results'][0]['location']['state']
                  + ' ' + data['results'][0]['location']['postcode'].toString()
                  + ' ,' + data['results'][0]['location']['country']);
      email = (data['results'][0]['email']);
      username = (data['results'][0]['login']['username']);
      DateTime birthDate = DateTime.parse(data['results'][0]['dob']['date']);
      birth = DateFormat('yyyy-MM-dd').format(birthDate);
      age = (data['results'][0]['dob']['age'].toString());
      phone = (data['results'][0]['phone']);
      cell = (data['results'][0]['cell']);
      imageUrl = data['results'][0]['picture']['large'];
      errorMessage = '';
      setState(() {});
    } else {

      setState(() {errorMessage = 'Failed to load user data. Please try again later.';});
    }
  }
}