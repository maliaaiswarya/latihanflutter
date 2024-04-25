import 'package:flutter/material.dart';
import 'package:helloworld1/model/petani.dart';
import 'package:helloworld1/service/apiStatic.dart';
import 'package:helloworld1/page/petaniPage.dart';
void main() {
  runApp(const LongList());
}

class LongList extends StatefulWidget {
  const LongList({super.key});

  @override
  State<LongList> createState() => _LongListState();
}

class _LongListState extends State<LongList> {
  late Future<List<Petani>> futurePetani;

  final ApiService apiStatic = ApiService();
  
  @override
  void initState() {
    super.initState();
    futurePetani = 
    apiStatic.fetchPetani();
  }

  void _navigatetoPetaniPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PetaniPage(futurePetani: futurePetani)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Petani>>(
            future: futurePetani,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the future
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Display an error message if there's an error
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // Display the list of Petani if data is available
                final List<Petani> petaniList = snapshot.data!;
                return ListView.builder(
                  itemCount: petaniList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Display each Petani's name
                    return Text('${petaniList[index].nama}');
                  },
                );
              } else {
                // Default case: Display a message when there's no data
                return const Text('No data available');
              }
            },
          ),
        ),
      ),
    );
  }
}