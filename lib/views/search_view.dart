import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String searchQuery = '';
  int selectedTabIndex = 0;

  // Dummy data for recent contacts and popular posts
  List<String> recentContacts = ['Alice', 'Bob', 'Charlie', 'Diana'];
  List<String> popularPosts = [
    'Exploring Flutter widgets',
    'Top 10 programming languages in 2023',
    'The future of AI and machine learning',
    'Is the metaverse the next big thing?'
  ];

  // Function to update the search query
  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Buscar'),
          bottom: TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            onTap: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
            tabs: [
              Tab(text: 'Publicaciones'),
              Tab(text: 'Amigos'),
              Tab(text: 'Grupos'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Buscar amigos, grupos, o publicaciones...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            // Show either search results or default content
            Expanded(
              child: searchQuery.isEmpty
                  ? _buildDefaultContent() // Here is the default content method
                  : _buildSearchResults(), // Here is the search results method
            ),
          ],
        ),
      ),
    );
  }

  // Here is the simplified _buildDefaultContent method
  Widget _buildDefaultContent() {
    return Center(
      child: Text('No search query. Showing default content.'),
    );
  }

  // Function to build search results based on selected category
  Widget _buildSearchResults() {
    List<String> searchResults = [];

    if (selectedTabIndex == 0) {
      // Search results for posts
      searchResults = popularPosts
          .where((post) => post.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    } else if (selectedTabIndex == 1) {
      // Search results for friends
      searchResults = recentContacts
          .where((friend) => friend.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    } else if (selectedTabIndex == 2) {
      // Search results for groups (You can add real group data here)
      searchResults = ['Grupo Flutter', 'Desarrolladores AI', 'Amantes de la tecnología']
          .where((group) => group.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: selectedTabIndex == 0
              ? Icon(Icons.article)
              : selectedTabIndex == 1
                  ? CircleAvatar(child: Text(searchResults[index][0]))
                  : Icon(Icons.group),
          title: Text(searchResults[index]),
          subtitle: Text('Resultado de búsqueda'),
        );
      },
    );
  }
}
