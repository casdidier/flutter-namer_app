import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet...'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 300 / 80,
            children: List.generate(appState.favorites.length, (index) {
              return Padding(
                padding: EdgeInsets.all(2.0),
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<MyAppState>().onDelete(index);
                    },
                  ),
                  title: Text(appState.favorites[index].asLowerCase),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
