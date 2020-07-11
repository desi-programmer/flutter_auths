import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final gooleSignIn = GoogleSignIn();

// many unhandled google error exist
// will push them soon
Future<bool> googleSignIn() async {
  GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();

  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = await auth.signInWithCredential(credential);

    FirebaseUser user = await auth.currentUser();
    print(user.uid);

    return Future.value(true);
  }
}

Future<bool> signin(String email, String password) async {
  try {
    AuthResult result =
        await auth.signInWithEmailAndPassword(email: email, password: email);
    // FirebaseUser user = result.user;
    return Future.value(true);
  } catch (e) {
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        print('serror');
    }
  }
}

// change to Future<FirebaseUser> for returning a user
Future<bool> signUp(String email, String password) async {
  try {
    AuthResult result = await auth.createUserWithEmailAndPassword(
        email: email, password: email);
    // FirebaseUser user = result.user;
    return Future.value(true);
  } catch (e) {
    switch (e.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        print('serror');
    }
    
  }
}


Future<bool> signOutUser() async {
  FirebaseUser user = await auth.currentUser();

  if (user.providerData[1].providerId == 'google.com') {
    await gooleSignIn.disconnect();
  }
  await auth.signOut();
return Future.value(true);
}
