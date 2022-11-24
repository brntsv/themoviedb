import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:flutter_themoviedb/library/default_widgets/inherited/notifier_provider.dart';
import 'package:flutter_themoviedb/ui/widgets/movie_list/serial_list_model.dart';
import 'package:flutter_themoviedb/ui/widgets/movie_list/serial_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedIndex = 1;
  final serialListModel = SerialListModel();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    return setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    serialListModel.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SafeArea(child: Text('TMDB')),
        actions: [
          IconButton(
            onPressed: () => SessionDataProvider().setSessionId(null),
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const Text('Новое', style: optionStyle),
          NotifierProvider(
            create: () => serialListModel,
            isManagerModel: false,
            child: const SerialListWidget(),
          ),
          const Text('Фильмы', style: optionStyle),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        // selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
