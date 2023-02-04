part of 'signup-screen.dart';

extension ExtensionSigninController on SignUpScreenState {
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

  signUp() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      user = userCredential.user;

      userModel?.docID = user?.uid ?? "";

      await user?.updateDisplayName(userModel?.firstName ?? "");
      await user?.updatePhotoURL(userModel?.imageUrl ?? "");

      await user?.reload();
      user = _auth.currentUser;

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('table-user')
          .where('email', isEqualTo: userModel?.email.toString() ?? "")
          .get();
      final List<DocumentSnapshot> document = result.docs;

      if (document.isEmpty) {
        userLoggedIn = UserModel(
            docID: userModel?.docID ?? "",
            firstName: nameController.text.toString(),
            lastName: userModel?.lastName ?? "",
            address: userModel?.address ?? "",
            phoneNumber: userModel?.phoneNumber ?? "",
            email: emailController.text.toString(),
            gender: userModel?.gender ?? "",
            birthDate: userModel?.birthDate ?? "",
            userType: userModel?.userType ?? "",
            token: token ?? "",
            imageUrl:
                "https://images.goodsmile.info/cgm/images/product/20210419/11099/83717/large/50dabf69c05e421243096235f67f7e64.jpg");

        await FirebaseFirestore.instance
            .collection("table-user")
            // .doc(user!.uid)
            .add(userLoggedIn?.toMap() ?? {})
            .then((uid) async {
          dismissLoadingView();
          gotoHomeScreen();
        });
      }
    } on FirebaseAuthException catch (error) {
      dismissLoadingView();
      switch (error.code) {
        case "invalid-email":
          displayErrorMessage("Your email address appears to be malformed.");

          break;
        case "email-already-in-use":
          displayErrorMessage("The account already exists for that email.");

          break;

        case "weak-password":
          displayErrorMessage("Weak Password.");
          break;
        case "operation-not-allowed":
          displayErrorMessage("Signing in with Email and Password is not enabled.");

          break;
        default:
          displayErrorMessage("Check Your Internet Access.");
      }
    }
  }
}
