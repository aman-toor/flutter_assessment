import 'package:flutter/material.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({super.key});

  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  late List<String> items;
  late List<String> filteredItems;

  @override
  void initState() {
    super.initState();
    items = List<String>.generate(20, (index) => "Item ${index + 1}");
    filteredItems = List<String>.from(items);
  }

  void filterList(String query) {
    setState(() {
      filteredItems = items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ItemSearch(items: items, filterList: filterList));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.list),
                title: Text(filteredItems[index]),
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ItemSearch extends SearchDelegate<String> {
  final List<String> items;
  final Function(String) filterList;

  ItemSearch({required this.items, required this.filterList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          filterList('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestions = query.isEmpty
        ? items
        : items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    return suggestions.isEmpty
        ? const Center(
      child: Text('No items found'),
    )
        : ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            close(context, suggestions[index]);
          },
        );
      },
    );
  }
}
