import 'package:flutter/material.dart';
import 'package:helloworld1/model/petani.dart';
import 'package:helloworld1/page/EditPetaniPage.dart';
import 'package:helloworld1/page/TambahPetaniPage.dart'; // Perubahan pada impor ini
import 'package:helloworld1/page/detail_petani_page.dart' as DetailPage; // Gunakan alias DetailPage

import 'package:helloworld1/service/apiStatic.dart';

class DatasScreen extends StatefulWidget {
  const DatasScreen({Key? key, required this.futurePetani}) : super(key: key);

  final Future<List<Petani>> futurePetani;

  @override
  State<DatasScreen> createState() => _DatasScreenState();
}

class _DatasScreenState extends State<DatasScreen> {
  late final ApiStatic _apiStatic;

  @override
  void initState() {
    super.initState();
    _apiStatic = ApiStatic();
  }

  void refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Petani List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahPetaniPage(
                    petani: Petani(),
      
                  ),
                ),
              );
              refreshData();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Petani>>(
                future: widget.futurePetani,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final List<Petani> petaniList = snapshot.data!;
                    return ListView.builder(
                      itemCount: petaniList.length,
                      itemBuilder: (BuildContext context, int index) => Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailPage.DetailPetaniPage( // Gunakan alias untuk mengakses DetailPetaniPage
                                    petani: petaniList[index],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 16),
                                Text(
                                  '${petaniList[index].nama}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPetaniPage(
                                          petani: petaniList[index],
                                        ),
                                      ),
                                    );
                                    refreshData();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final confirmed = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: Text(
                                            'Are you sure you want to delete this petani?'
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Delete'),
                                              onPressed: () async {
                                                try {
                                                  final idPenjual =
                                                      petaniList[index].idPenjual;
                                                  if (idPenjual != null) {
                                                    await ApiStatic.deletePetani(
                                                      idPenjual
                                                    );
                                                    refreshData();
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Failed to delete petani: ${e.toString()}'
                                                      ),
                                                    ),
                                                  );
                                                }
                                                Navigator.pop(context, true);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirmed != null && confirmed) {
                                      refreshData();
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
