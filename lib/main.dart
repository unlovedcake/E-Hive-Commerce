import 'package:adopt_a_pet/pages/Home/home-screen.dart';
import 'package:adopt_a_pet/pages/SignIn-SignUp/signin-screen.dart';
import 'package:adopt_a_pet/provider-controller/Provider-Controller.dart';
import 'package:adopt_a_pet/utilities/AssetStorageImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:splash_view/source/presentation/pages/splash_view.dart';
import 'package:splash_view/source/presentation/widgets/done.dart';
import 'package:provider/provider.dart';
import 'All-Constants/color_constants.dart';
import 'All-Constants/global_variable.dart';
import 'model/user-model.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// On click listner
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ProviderController()),
    ], child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? users;

  bool _isLogIn = false;

  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    isUserLoggedIn();

    loadFCM();
    listenFCM();
    super.initState();
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // final ByteArrayAndroidBitmap largeIcon =
      //     ByteArrayAndroidBitmap(await _getByteArrayFromUrl('https://via.placeholder.com/48x48'));
      // final ByteArrayAndroidBitmap bigPicture =
      //     ByteArrayAndroidBitmap(await _getByteArrayFromUrl('https://via.placeholder.com/400x800'));
      //
      // final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      //     bigPicture,
      //     largeIcon: largeIcon,
      //     contentTitle: notification?.title,
      //     htmlFormatContentTitle: true,
      //     summaryText: notification?.body,
      //     htmlFormatSummaryText: true);

      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id, channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              //styleInformation: bigPictureStyleInformation,  // it will display the url image
              icon: 'app_logo',

              //largeIcon: const DrawableResourceAndroidBitmap('ic_launcher'),
            ),
          ),
        );
      }
    });
  }

  isUserLoggedIn() {
    users = FirebaseAuth.instance.currentUser;
    if (users?.email == null) {
      _isLogIn = false;
    } else {
      getUserLoggedInInfo();
      _isLogIn = true;
    }
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void getUserLoggedInInfo() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('table-user')
        .where('email', isEqualTo: users?.email.toString() ?? "")
        .get();
    final List<DocumentSnapshot> document = result.docs;
    DocumentSnapshot documentSnapshot = document[0];
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.white, AppColors.logoColor]),
          //loadingIndicator: const RefreshProgressIndicator(),
          logo: SizedBox(
            height: 150,
            width: 150,
            child: Image.asset(AssetStorageImage.eCommerceLogo),
          ),
          done: Done(
            !_isLogIn ? const SignInScreen() : const HomeScreen(),
            animationDuration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
          )),
    );
  }
}
