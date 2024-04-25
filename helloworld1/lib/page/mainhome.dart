import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloworld1/model/petani.dart';
import 'package:helloworld1/page/home.dart';
import 'package:helloworld1/page/list_petani-page.dart';
import 'package:helloworld1/page/long_list.dart';
import 'package:helloworld1/page/profile.dart';
import 'package:helloworld1/page/setting.dart';
import 'package:helloworld1/service/apiStatic.dart';

void main() {
  runApp(const Mymain());
}

class Mymain extends StatelessWidget {
  const Mymain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return MaterialApp(
      title: 'Resep Makanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
      ),
      navigatorKey: GlobalKey
      <NavigatorState>(),
      home: const MyHomePage(title: 'Home Screen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late Future<List<Petani>> futurePetani; // Perbaikan tipe data Future

  final ApiService apiStatic = ApiService();

  @override
  void initState() {
    super.initState();
    futurePetani =
        apiStatic.fetchPetani(); // Perbaikan inisialisasi futurePetani
  }

  final List
  <Widget> _screens = [
    const Home(),
    const SettingScreen(),
    const ProfileScreen(),
    const LongList(),
  ];

  final List<String> _appBarTitles = const [
    'Rumah',
    'Settings',
    'Profile',
    'History', // Mengubah 'Long List' menjadi 'History'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
      ),
      body: _screens[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Malia Aiswarya"),
              accountEmail: Text("maliaaiswarya@gmail.com"),
              currentAccountPicture: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://i.pinimg.com/564x/c5/ec/52/c5ec52d3afb7835851bf583481a731ba.jpg'),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/bg_profile.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
              child: ListTile(
                title: Text('Setting'),
                trailing: Icon(Icons.settings),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide.none,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LongList()),
                );
              },
              child: ListTile(
                title: Text('History'), // Mengubah 'Long List' menjadi 'History'
                trailing: Icon(Icons.list),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide.none,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DatasScreen(futurePetani: futurePetani)),
                );
              },
              child: ListTile(
                title: Text('Petani Page'), // Mengubah 'Long List' menjadi 'History'
                trailing: Icon(Icons.list),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide.none,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History', // Mengubah 'Long List' menjadi 'History'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
