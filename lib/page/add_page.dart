import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_app/services/firebase_service.dart';
import 'package:intl/intl.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  AddPageState createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
  final _firestoreService = FirestoreService();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _ageController = TextEditingController();
  String? selectedAnimal;
  String? selectedSex;

  Future<void> _addInfomation() async {
    if (_nameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text('名前を入力して下さい'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (_typeController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text('品種を入力して下さい'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (_ageController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text('年齢を入力して下さい'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (selectedAnimal == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text('動物をを選択して下さい'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (selectedSex == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text('性別を選択して下さい'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      try {
        await _firestoreService.addInfomation({
          'name': _nameController.text,
          'type': _typeController.text,
          'age': _ageController.text,
          'animal': selectedAnimal,
          'sex': selectedSex,
          'date': DateTime.now(),
        });
        _nameController.clear();
        _typeController.clear();
        _ageController.clear();
        setState(() {
          selectedAnimal = null;
          selectedSex = null;
        });
      } catch (e) {
        if (!mounted) return;
        print('$e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('メッセージを送信できませんでした'),
            behavior: SnackBarBehavior.floating, // SnackBarの動作をfloatingに設定
            margin: EdgeInsets.only(bottom: 60),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _ageController.dispose();
    _nameController.dispose();
    _typeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '名前',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Expamdedにすることでサイズエラーを回避
                      Expanded(
                        child: ListTile(
                          title: const Text('犬'),
                          leading: Radio(
                            fillColor: MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.blue; // 選択状態の場合は青色を返す
                              } else {
                                return Colors.grey; // 非選択状態の場合は灰色を返す
                              }
                            }),
                            value: '犬',
                            groupValue: selectedAnimal,
                            onChanged: (value) {
                              setState(() {
                                selectedAnimal = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('猫'),
                          leading: Radio(
                            fillColor: MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.blue; // 選択状態の場合は青色を返す
                              } else {
                                return Colors.grey; // 非選択状態の場合は灰色を返す
                              }
                            }),
                            value: '猫',
                            groupValue: selectedAnimal,
                            onChanged: (value) {
                              setState(() {
                                selectedAnimal = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      controller: _typeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '品種',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Expamdedにすることでサイズエラーを回避
                      Expanded(
                        child: ListTile(
                          title: const Text('オス'),
                          leading: Radio(
                            fillColor: MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.blue; // 選択状態の場合は青色を返す
                              } else {
                                return Colors.grey; // 非選択状態の場合は灰色を返す
                              }
                            }),
                            value: 'オス',
                            groupValue: selectedSex,
                            onChanged: (value) {
                              setState(() {
                                selectedSex = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('メス'),
                          leading: Radio(
                            fillColor: MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.blue; // 選択状態の場合は青色を返す
                              } else {
                                return Colors.grey; // 非選択状態の場合は灰色を返す
                              }
                            }),
                            value: 'メス',
                            groupValue: selectedSex,
                            onChanged: (value) {
                              setState(() {
                                selectedSex = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '年齢',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (int.tryParse(value) == null) {
                              // 数値以外の文字列が入力された場合のエラーメッセージ表示
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('エラー'),
                                    content: Text('半角で整数を入力してください'),
                                    actions: [
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              int age = int.parse(value);
                              // 数値が正しく入力された場合の処理
                            }
                          }
                        },
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
                      onPressed: () {
                        _addInfomation();
                      },
                      child: Text('登録')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
