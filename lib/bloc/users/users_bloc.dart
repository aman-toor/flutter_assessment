import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_service.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final ApiService apiService;

  UsersBloc({required this.apiService}) : super(UsersInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final users = await apiService.fetchUsers();
        emit(UsersLoaded(users));
      } catch (e) {
        emit(UsersError(e.toString()));
      }
    });
  }
}
