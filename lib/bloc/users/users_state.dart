abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<dynamic> users;

  UsersLoaded(this.users);
}

class UsersError extends UsersState {
  final String error;

  UsersError(this.error);
}
