import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/users/users_bloc.dart';
import '../bloc/users/users_event.dart';
import '../bloc/users/users_state.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(
                context: context,
                delegate: UserSearch(usersBloc: context.read<UsersBloc>())),
          ),
        ],
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is UsersInitial) {
            context.read<UsersBloc>().add(FetchUsers());
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(state.users[index]['name']),
                  subtitle: Text(state.users[index]['email']),
                );
              },
            );
          } else if (state is UsersError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class UserSearch extends SearchDelegate<String> {
  final UsersBloc usersBloc;

  UserSearch({required this.usersBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
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
    final List<dynamic> users = (usersBloc.state as UsersLoaded).users;
    final List<dynamic> suggestions = query.isEmpty
        ? users
        : users
            .where((user) =>
                user['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
    if (suggestions.isEmpty) {
      return const Center(
        child: Text('No users found'),
      );
    }
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(suggestions[index]['name']),
          subtitle: Text(suggestions[index]['email']),
        );
      },
    );
  }
}
