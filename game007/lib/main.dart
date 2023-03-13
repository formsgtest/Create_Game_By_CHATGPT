import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Space Shooter Game',
      home: SpaceShooterGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SpaceShooterGame extends StatefulWidget {
  const SpaceShooterGame({Key? key}) : super(key: key);

  @override
  _SpaceShooterGameState createState() => _SpaceShooterGameState();
}

class _SpaceShooterGameState extends State<SpaceShooterGame> {
  int _selectedIndex = 0;
  List<Widget> _pages = [MainPage(), ShopPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Space Shooter Game',
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store_sharp),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text('This is the main page.', style: TextStyle(fontSize: 30)),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            //create a Dialog to show level selection
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Select Your Level ^^'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        //start level 1
                        Navigator.of(context).pop();
                      },
                      child: const Text('Level 1'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //start level 2
                        Navigator.of(context).pop();
                      },
                      child: const Text('Level 2'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //start level 3
                        Navigator.of(context).pop();
                      },
                      child: const Text('Level 3'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Play'),
        ),
      ],
    );
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String _selectedItem = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Container(
                color: _selectedItem == 'Ship' ? Colors.grey : null,
                child: ListTile(
                  title: const Text('Ship'),
                  onTap: () {
                    setState(() {
                      _selectedItem = 'Ship';
                    });
                  },
                ),
              ),
              Container(
                color: _selectedItem == 'Weapon' ? Colors.grey : null,
                child: ListTile(
                  title: const Text('Weapon'),
                  onTap: () {
                    setState(() {
                      _selectedItem = 'Weapon';
                    });
                  },
                ),
              ),
              Container(
                color: _selectedItem == 'Shield' ? Colors.grey : null,
                child: ListTile(
                  title: const Text('Shield'),
                  onTap: () {
                    setState(() {
                      _selectedItem = 'Shield';
                    });
                  },
                ),
              ),
              Container(
                color: _selectedItem == 'Power Up' ? Colors.grey : null,
                child: ListTile(
                  title: const Text('Power Up'),
                  onTap: () {
                    setState(() {
                      _selectedItem = 'Power Up';
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_selectedItem.isNotEmpty) {
              _buySelectedItem();
            }
          },
          child: const Text('Buy Selected Item'),
        ),
      ],
    );
  }

  void _buySelectedItem() {
    print('Buying $_selectedItem');
  }
}



class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Profile page.', style: TextStyle(fontSize: 30)),
    );
  }
}
