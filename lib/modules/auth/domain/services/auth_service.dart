import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:listadecoisa/core/interfaces/local_database_inter.dart';
import 'package:listadecoisa/core/interfaces/remote_database_inter.dart';
import 'package:listadecoisa/modules/auth/domain/models/user.dart';

class AuthService {
  final IRemoteDataBase remoteDataBase;
  final ILocalDatabase localDatabase;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AuthService(this.remoteDataBase, this.localDatabase);

  Future<String> criaUser(UserP user) async {
    if (user.login == null) {
      throw Exception('E-mail não pode estar vazio');
    }
    if (user.senha == null) {
      throw Exception('Senha não pode estar vazio');
    }
    final userFire = await firebaseAuth.createUserWithEmailAndPassword(
      email: user.login!,
      password: user.senha!,
    );

    user.id = userFire.user!.uid;
    await remoteDataBase.createUser(user);
    return userFire.user!.uid;
  }

  Future<UserP?> login({
    required String email,
    required String password,
  }) async {
    final user = await firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return remoteDataBase.getUser(user.user!.uid);
  }

  Future<UserP?> criaUserAnonimo() async {
    final UserP user = UserP();
    final axui = await localDatabase.get(id: 'userAnonimo') ?? '';
    if (axui.isNotEmpty) {
      final result = await remoteDataBase.getUser(axui);
      user.id = result!.id;
    } else {
      final value = await firebaseAuth.signInAnonymously();
      user.id = value.user!.uid;
      await remoteDataBase.createUser(user);
      await localDatabase.update(objeto: user.id, id: 'userAnonimo');
    }

    return user;
  }

  Future<void> resetarSenha({required UserP user}) async {
    if (user.login == null) {
      throw Exception('E-mail não pode estar vazio');
    }
    await firebaseAuth.sendPasswordResetEmail(email: user.login!);
  }

  Future<UserP?> criaUserGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final value = await FirebaseAuth.instance.signInWithCredential(credential);
    final result = await remoteDataBase.getUser(value.user!.uid);
    if (result != null) {
      return result;
    }
    final userTemp = UserP(
      id: value.user!.uid,
      login: value.user!.email,
      nome: value.user!.displayName,
      senha: '',
    );
    await remoteDataBase.createUser(userTemp);
    return userTemp;
  }
}
