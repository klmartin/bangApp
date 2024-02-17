import 'package:google_sign_in/google_sign_in.dart';

/*
class AuthService {

  //Google Sign In
  signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from request

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credentials for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );


    // finally, lets sign in

    return await FirebaseAuth.instance.signInWithCredential(credential);


  }

}
*/
 class  AuthService {
    signIn() async {
   final _googleSignIn = GoogleSignIn();
   Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
 }

 }

