import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = await firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return user.user!;
  }

  Future<void> resetarSenha({required User user}) async {
    if (user.email == null) {
      throw Exception('E-mail não pode estar vazio');
    }
    await firebaseAuth.sendPasswordResetEmail(email: user.email!);
  }

  Future<User> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn.instance.authenticate();

    // Obtain the auth details from the request
    final googleAuth = googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final result = await FirebaseAuth.instance.signInWithCredential(credential);
    // Once signed in, return the UserCredential
    return result.user!;
  }

  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String nome,
  }) async {
    if (email.isEmpty) {
      throw Exception('E-mail não pode estar vazio');
    }
    if (password.isEmpty) {
      throw Exception('Senha não pode estar vazio');
    }
    final user = await firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    if (nome.trim().isNotEmpty) {
      await firebaseAuth.currentUser!.updateDisplayName(nome.trim());
    }
    return user.user!;
  }

  User? get currentUser => firebaseAuth.currentUser;
}
