import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nono Ice Cream Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
          primary: Colors.black,
          secondary: Colors.blue.shade900,
        ).copyWith(
          tertiary: Colors.grey,
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontFamily: 'RobotoMono',
          ),
        ),
        cardTheme: const CardTheme(
          color: Colors.grey,
          shadowColor: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
          ),
        ),
      ),
      home: const MyHomePage(title: 'Nono Ice Cream Shop'),
    );
  }
}

class IceCream {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String path;

  IceCream({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.path,
  });

  factory IceCream.fromJson(Map<String, dynamic> json) {
    return IceCream(
      id: json['_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      stock: json['stock'],
      path: json['path'],
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Where to Find Us'),
        backgroundColor: Colors.black,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(51.5074, -0.1278),
          initialZoom: 10.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(51.5074, -0.1278),
                width: 80,
                height: 80,
                child: FlutterLogo(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShopDescriptionPage extends StatelessWidget {
  const ShopDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Nono Ice Cream Shop'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Who are we?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "At Nono Ice Cream Shop, we provide a wide variety of delicious ice cream flavors made with the finest ingredients. Whether you're a fan of classic vanilla, fruity strawberry, or something more adventurous, we have something for everyone! All our employees are robots, programmed to serve you the best ice cream experience.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Image.asset(
                'assets/robot.png',
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Hours:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Monday - Friday: 10:00 AM - 8:00 PM\nSaturday: 12:00 PM - 10:00 PM\nSunday: Closed',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Go to Map',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<IceCream> iceCreams = [];
  bool isLoading = true;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchIceCreams();
  }

  Future<void> fetchIceCreams() async {
    try {
      final response = await http.get(Uri.parse(/*'http://172.31.35.70:5000/items'*  change the address by your's*/ )); 

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          iceCreams = data.map((json) => IceCream.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load ice creams');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nono Ice Cream Shop'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'All our Ice Creams',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : iceCreams.isEmpty
                      ? const Center(child: Text('No ice creams available'))
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: iceCreams.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildWidget(iceCreams[index], index);
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Go to Map',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShopDescriptionPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'About the Shop',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWidget(IceCream iceCream, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = (_selectedIndex == index) ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _selectedIndex == index ? 200 : 150,
        height: _selectedIndex == index ? 250 : 200,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Image.asset(
                    iceCream.path,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  iceCream.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('\$${iceCream.price.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('In Stock: ${iceCream.stock}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
