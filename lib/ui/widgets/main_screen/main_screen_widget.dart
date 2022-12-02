import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/factories/screen_factory.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedIndex = 1;
  final _screenFactory = ScreenFactory();

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB', style: TextStyle(fontSize: 27)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _screenFactory.makeNewsList(),
          _screenFactory.makeSerialList(),
          _screenFactory.makeMovieList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: 'Новое',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Сериалы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Фильмы',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
