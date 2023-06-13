import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_app/page/add_page.dart';
import 'package:flutter_pet_app/services/firebase_service.dart';

enum SortOption {
  DogsOnly,
  CatsOnly,
  AgeAscending,
  AgeDescending,
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _firestoreService = FirestoreService();
  final _listScrollController = ScrollController();
  late Stream<QuerySnapshot> _AllinfomationsStream;
  late Stream<QuerySnapshot> _DoginfomationsStream;
  late Stream<QuerySnapshot> _CatinfomationsStream;
  late Stream<QuerySnapshot> _AgeinfomationsStream;
  late Stream<QuerySnapshot> _AgeDescendinginfomationsStream;

  Stream<QuerySnapshot> _getInfomationsStream() {
    return _firestoreService.getInfomationsStream();
  }

  Stream<QuerySnapshot> _getDogInfomationsStream() {
    return _firestoreService.getDogInfomationsStream();
  }

  Stream<QuerySnapshot> _getCatInfomationsStream() {
    return _firestoreService.getCatInfomationsStream();
  }

  Stream<QuerySnapshot> _getAgeInfomationsStream() {
    return _firestoreService.getAgeInfomationsStream();
  }

  Stream<QuerySnapshot> _getAgeDescendingInfomationsStream() {
    return _firestoreService.getAgeDescendingInfomationsStream();
  }

  late Stream<QuerySnapshot> _infomationsStream = _AllinfomationsStream;

  @override
  void initState() {
    super.initState();
    _AllinfomationsStream = _getInfomationsStream();
    _DoginfomationsStream = _getDogInfomationsStream();
    _CatinfomationsStream = _getCatInfomationsStream();
    _AgeinfomationsStream = _getAgeInfomationsStream();
    _AgeDescendinginfomationsStream = _getAgeDescendingInfomationsStream();
  }

  void _incremenButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<SortOption>(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<SortOption>>[
                PopupMenuItem<SortOption>(
                  value: SortOption.DogsOnly,
                  child: Text('犬のみ'),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.CatsOnly,
                  child: Text('猫のみ'),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.AgeAscending,
                  child: Text('年齢: 昇順'),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.AgeDescending,
                  child: Text('年齢: 降順'),
                ),
              ];
            },
            child: Container(
              width: 50, // ウィジェットの幅を指定
              child: Icon(Icons.sort),
            ),
            onSelected: (SortOption selectedvalue) {
              if (selectedvalue == SortOption.DogsOnly) {
                setState(() {
                  _infomationsStream = _DoginfomationsStream;
                });
              } else if (selectedvalue == SortOption.CatsOnly) {
                setState(() {
                  _infomationsStream = _CatinfomationsStream;
                });
              } else if (selectedvalue == SortOption.AgeAscending) {
                setState(() {
                  _infomationsStream = _AgeinfomationsStream;
                });
              } else if (selectedvalue == SortOption.AgeDescending) {
                setState(() {
                  _infomationsStream = _AgeDescendinginfomationsStream;
                });
              }
            },
          ),
        ],
      ),
      body: SizedBox(
        child: StreamBuilder<QuerySnapshot>(
            stream: _infomationsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<DocumentSnapshot> infomationsData = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                    controller: _listScrollController,
                    itemCount: infomationsData.length,
                    itemBuilder: (context, index) {
                      final infomationData =
                          infomationsData[index].data() as Map<String, dynamic>;
                      return InfomationCard(
                        infomationData: infomationData,
                        name: infomationData['name'],
                        type: infomationData['type'],
                        age: infomationData['age'],
                        animal: infomationData['animal'],
                        sex: infomationData['sex'],
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incremenButton,
        child: Icon(Icons.add),
      ),
    );
  }
}

class InfomationCard extends StatelessWidget {
  const InfomationCard(
      {super.key,
      required this.infomationData,
      required this.name,
      required this.type,
      required this.age,
      required this.animal,
      required this.sex});

  final Map<String, dynamic> infomationData;
  final name;
  final type;
  final age;
  final animal;
  final sex;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: Colors.white,
        title: Text('名前：$name' + '　品種：$type' + '　性別：$sex' + '　年齢：$age'),
      ),
    );
  }
}
