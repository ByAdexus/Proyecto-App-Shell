import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final loggedInUsername = context.read<LoginViewModel>().loggedInUser;
    profileViewModel.loadUserData(loggedInUsername);
    profileViewModel.loadUserPosts(loggedInUsername);
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de Usuario')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                Flexible(flex: 2, child: _buildPostsSection(profileViewModel, context)),
                Flexible(flex: 1, child: _buildUserProfileSection(profileViewModel)),
              ],
            );
          } else {
            return _buildSingleColumnView(profileViewModel, context);
          }
        },
      ),
    );
  }

  Widget _buildSingleColumnView(ProfileViewModel profileViewModel, BuildContext context) {
    List<Widget> views = [
      _buildPostsSection(profileViewModel, context),
      _buildUserProfileSection(profileViewModel),
    ];

    return Column(
      children: [
        Expanded(child: views[_currentIndex]),
        BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Publicaciones'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ],
    );
  }

  Widget _buildPostsSection(ProfileViewModel profileViewModel, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mis Publicaciones', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: profileViewModel.posts.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(profileViewModel.posts[index]['title']),
                    subtitle: Text(profileViewModel.posts[index]['description']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(context, profileViewModel, index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await profileViewModel.deletePost(profileViewModel.posts[index]['id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Publicación eliminada')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ProfileViewModel profileViewModel, int index) {
    final titleController = TextEditingController(text: profileViewModel.posts[index]['title']);
    final descriptionController = TextEditingController(text: profileViewModel.posts[index]['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Publicación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await profileViewModel.updatePost(
                  profileViewModel.posts[index]['id'],
                  titleController.text,
                  descriptionController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserProfileSection(ProfileViewModel profileViewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos Personales', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_image.jpg'),
          ),
          const SizedBox(height: 16),
          Text('Nombre: ${profileViewModel.username}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Email: ${profileViewModel.email}', style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
