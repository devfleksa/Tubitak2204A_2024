import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_oa/view/auth/login_view.dart';
import 'package:firebase_oa/view/home/home_view.dart';
import 'package:firebase_oa/view/auth/sign_in_view.dart';
import 'package:get/get.dart';

class AuthenticationRepo extends GetxController {
  static AuthenticationRepo get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());

    ever(firebaseUser, _setInitialScreen);

    super.onReady();
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const SignInView())
        : Get.offAll(() => const HomeView());
  }

  Future createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(
              () => const HomeView(),
            )
          : Get.offAll(
              () => const LoginView(),
            );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(
              () => const HomeView(),
            )
          : Get.offAll(
              () => const LoginView(),
            );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> logout() async => await _auth.signOut();
}
