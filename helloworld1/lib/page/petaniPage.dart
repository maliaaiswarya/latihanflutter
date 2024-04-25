import 'package:flutter/material.dart';
import 'package:helloworld1/model/petani.dart';
import 'package:helloworld1/page/detail_page_petani.dart';

class PetaniPage extends StatefulWidget {
  const PetaniPage({
    super.key,
    required this.futurePetani,
  });

  final Future<List<Petani>> futurePetani;

  @override
  State<PetaniPage> createState() => _HomePageState();
}

class _HomePageState extends State<PetaniPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Petani>>(
        future: widget.futurePetani,
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
            return Container(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: petaniList.length,
                itemBuilder: (BuildContext context, int index) => Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => DetailPetaniPage(
                              petani: petaniList[index],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage("${petaniList[index].foto}"),
                                radius: 20,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '${petaniList[index].nama}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Add code for edit action here
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Add code for delete action here
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            // Default case: Display a message when there's no data
            return const Text('No data available');
          }
        },
      ),
    );
  }
}