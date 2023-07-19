import 'package:discussit/core/utils.dart';
import 'package:discussit/features/auth/repository/auth_repo.dart';
import 'package:discussit/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.watch(AuthRepositoryProvider), ref: ref));

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    user.fold(
      (l) => showSnackBar(context, l.message),
      (UserModel) =>
          _ref.read(userProvider.notifier).update((state) => UserModel),
    );
  }
}
