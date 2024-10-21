import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
void initState() {
  super.initState();
  final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
  homeViewModel.fetchPosts(); // Asegúrate de que esto esté aquí
}

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final loginViewModel = Provider.of<LoginViewModel>(context);

    homeViewModel.updateLoginViewModel(loginViewModel);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // El input de publicación solo aparece si el usuario está logueado
          loginViewModel.loggedInUser.isNotEmpty
              ? _buildPublicationInput(homeViewModel)
              : const SizedBox.shrink(),
          const SizedBox(height: 16.0),
          _buildFilters(),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: homeViewModel.posts.length,
              itemBuilder: (context, index) {
                final post = homeViewModel.posts[index];
                final postId = post['id']; // Se obtiene el ID de la publicación

                return _buildPostCard(
                  id: postId,  // Pasar el ID al _buildPostCard
                  author: post['author'] ?? 'Anónimo',
                  title: post['title'] ?? '',
                  description: post['description'] ?? '',
                  likes: List<String>.from(post['likes'] ?? []),
                  homeViewModel: homeViewModel,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationInput(HomeViewModel viewModel) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  viewModel.addPost(title, description).then((_) {
                    titleController.clear();
                    descriptionController.clear();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al publicar: $error')),
                    );
                  });
                }
              },
              child: const Text('Publicar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Filtro 1')),
        ElevatedButton(onPressed: () {}, child: const Text('Filtro 2')),
        ElevatedButton(onPressed: () {}, child: const Text('Filtro 3')),
      ],
    );
  }

  // Se añade el ID al método _buildPostCard
  Widget _buildPostCard({
  required String id,  // Recibe el ID de la publicación
  required String author,
  required String title,
  required String description,
  required List<String> likes,  // Recibe la lista de likes
  required HomeViewModel homeViewModel,  // Recibe el viewModel
}) {
  final isLiked = likes.contains(homeViewModel.loggedInUser);

  return Center(
    child: SizedBox(
      width: 900,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.purple),
                  const SizedBox(width: 8.0),
                  Text(author, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Container(
                height: 150,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(description),
              const SizedBox(height: 8.0),
              ElevatedButton.icon(
  onPressed: () {
    try {
      homeViewModel.toggleLike(id, context); // Pasa el contexto aquí
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  },
  icon: Icon(
    Icons.favorite,
    color: isLiked ? Colors.red : Colors.grey, // Cambia el color según el estado del like
  ),
  label: const Text('Me gusta'),
),
            ],
          ),
        ),
      ),
    ),
  );
}

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
