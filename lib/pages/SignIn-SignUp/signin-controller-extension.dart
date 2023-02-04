part of 'signin-screen.dart';

extension ExtensionSigninController on SignInScreenState {
  void displayErrorMessage(String message) {
    ToastMessage.showMessage(message, context,
        offSetBy: 0,
        position: const StyledToastPosition(align: Alignment.topCenter, offset: 200.0),
        isShapedBorder: false);
  }

  void dismissLoadingView() {
    Navigator.pop(context);
  }

  void startShowLoadingView() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return LoadingIndicator();
      },
    );
  }

  void gotoHomeScreen() {
    Navigator.of(context).push(pageRouteAnimate(const HomeScreen()));
  }

  signIn() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('table-user')
          .where('email', isEqualTo: emailController.text)
          .get();
      final List<DocumentSnapshot> document = result.docs;

      DocumentSnapshot documentSnapshot = document[0];

      await _auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((id) async {
        if (document.isNotEmpty) {
          dismissLoadingView();
          gotoHomeScreen();

          userLoggedIn = UserModel(
              docID: documentSnapshot.id,
              firstName: documentSnapshot.get('firstName'),
              lastName: documentSnapshot.get('lastName'),
              address: documentSnapshot.get('address'),
              phoneNumber: documentSnapshot.get('phoneNumber'),
              email: documentSnapshot.get('email'),
              gender: documentSnapshot.get('gender'),
              birthDate: documentSnapshot.get('birthDate'),
              userType: documentSnapshot.get('userType'),
              token: documentSnapshot.get('token'),
              imageUrl: documentSnapshot.get('imageUrl'));
        }
      });
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();

      switch (error.code) {
        case "invalid-email":
          displayErrorMessage("Your email address appears to be invalid.");
          break;
        case "wrong-password":
          displayErrorMessage("Your password is wrong..");

          break;
        case "user-not-found":
          displayErrorMessage("User with this email doesn't exist");

          break;
        case "user-disabled":
          displayErrorMessage("User with this email has been disabled.");

          break;
        case "too-many-requests":
          displayErrorMessage("Too many requests.");

          break;
        case "operation-not-allowed":
          displayErrorMessage("Signing in with Email and Password is not enabled.");

          break;
        default:
          displayErrorMessage("Check Your Internet Access.");
      }
    }
  }

  Future<String?> signInwithGoogle() async {
    String? token = await FirebaseMessaging.instance.getToken();

    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential).then((value) async {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('table-user')
            .where('email', isEqualTo: googleSignInAccount.email.toString())
            .get();
        final List<DocumentSnapshot> document = result.docs;

        if (document.isEmpty) {
          await FirebaseFirestore.instance
              .collection("table-user")
              .add(userLoggedIn?.toMap() ?? {})
              .then((uid) async {
            dismissLoadingView();
            gotoHomeScreen();
          });
        } else {
          print("2");
          dismissLoadingView();
          gotoHomeScreen();
        }

        userLoggedIn = UserModel(
            docID: googleSignInAccount.id.toString(),
            firstName: googleSignInAccount.displayName.toString(),
            lastName: "",
            address: "",
            phoneNumber: "",
            email: googleSignInAccount.email.toString(),
            gender: "",
            birthDate: "",
            userType: "user",
            token: token,
            imageUrl: googleSignInAccount.photoUrl.toString());
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future signInWithFacebook() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      final LoginResult result = await FacebookAuth.instance.login();
      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      await _auth.signInWithCredential(facebookCredential).then((val) async {
        print("FACEBOOK SIGN IN");
        startShowLoadingView();
        final userData = await FacebookAuth.instance.getUserData();

        print(userData['email'].toString());

        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('table-user')
            .where('email', isEqualTo: userData['email'].toString())
            .get();
        final List<DocumentSnapshot> document = result.docs;

        if (document.isEmpty) {
          await FirebaseFirestore.instance
              .collection("table-user")
              .add(userLoggedIn?.toMap() ?? {})
              .then((uid) async {
            dismissLoadingView();
            gotoHomeScreen();
          });
        } else {
          dismissLoadingView();
          gotoHomeScreen();
        }

        userLoggedIn = UserModel(
            docID: userData['id'].toString(),
            firstName: userData['name'].toString(),
            lastName: "",
            address: "",
            phoneNumber: "",
            email: userData['email'].toString(),
            gender: "",
            birthDate: "",
            userType: "user",
            token: token,
            imageUrl: userData['picture']['data']['url'].toString());
      });
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
}
