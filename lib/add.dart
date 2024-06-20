import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:taskapp/sqlhelper.dart';
import 'package:taskapp/user_input.dart';
import 'package:taskapp/user_model.dart';
import 'package:http/http.dart' as http;

class AddTwoNumber extends StatefulWidget {
  const AddTwoNumber({super.key});

  @override
  State<AddTwoNumber> createState() => _AddTwoNumberState();
}

class _AddTwoNumberState extends State<AddTwoNumber> {
  List<UserDataModel> userDetails = [];
  TextEditingController numberone = TextEditingController();
  TextEditingController numbertwo = TextEditingController();
  int answer = 0;

  Map<String, dynamic> data = {
    'numberOne': "",
    'numberTwo': "",
    'answer': "",
  };

  List<Map<String, dynamic>>? _userdata;

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate a delay
    final listofdata = await SqlHelper.getItems();
    setState(() {
      _userdata = listofdata;
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double wSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            "Add Two Number",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshort) {
                  if (snapshort.hasData) {
                    return ListView.builder(
                      itemCount: userDetails.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(userDetails[0].a),
                          subtitle: Text(userDetails[0].q),
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UserInput(controller: numberone),
                  const Icon(Icons.add),
                  UserInput(controller: numbertwo),
                  // const Text("=",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w700),),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                if (numberone.text != "" && numbertwo.text != "") {
                  setState(() {
                    answer =
                        int.parse(numberone.text) + int.parse(numbertwo.text);
                  });
                  data['numberOne'] = numberone.text;
                  data['numberTwo'] = numbertwo.text;
                  data['answer'] = answer;
                  _addItem();
                }
              },
              child: Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "Add",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _userdata == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _userdata!.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Text(
                              "•  ${_userdata![_userdata!.length - index - 1]['numberOne']} + ${_userdata![_userdata!.length - index - 1]['numberTwo']} = ${_userdata![_userdata!.length - index - 1]['answer']}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ],
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _addItem() async {
    final int id = await SqlHelper.createItem(data);
    debugPrint("User id: $id");
    _loadData();
  }

  Future<List<UserDataModel>> getData() async {
    final response =
        await http.get(Uri.parse('https://zenquotes.io/api/random'));

    var data = jsonDecode(response.body.toString());
    print("Data : $data");

    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        userDetails.add(UserDataModel.fromJson(index));
      }
      return userDetails;
    } else {
      return userDetails;
    }
  }
}
