import 'package:flutter/material.dart';
import 'package:flutter_assesment/bloc/users/users_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'api/api_service.dart';
import 'bloc/counter/counter_bloc.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(
          create: (context) => CounterBloc(),
        ),
        BlocProvider<UsersBloc>(
          create: (context) => UsersBloc(apiService: apiService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Assessment'),
      ),
    );
  }
}
