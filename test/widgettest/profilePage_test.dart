// // profile page test

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:matchup/Pages/loginSignupPage.dart';
// import 'package:matchup/Pages/profilePage.dart';
// import 'package:matchup/bizlogic/User.dart';
// import 'package:matchup/bizlogic/peer.dart';
// import 'package:provider/provider.dart';

// import 'package:matchup/bizlogic/authentication.dart';
// import 'package:mockito/mockito.dart';
// import './assetBundle.dart';

// // pages that use scaffolds must be a descendant of some type of material app
// Future<Widget> makeTestableWidget(WidgetTester tester, Widget child, BaseAuth auth, User user) async{
//   final AssetBundle assetBundle = TestAssetBundle(<String, List<String>>{
//     'characterPortraits': <String>[
//       'assets/images/characterPortraits/Bowser.png',
//     ],
//   });

//   return DefaultAssetBundle(
//     bundle: assetBundle,
//     child: MultiProvider(
//       providers: 
//         <Provider>[
//           Provider<BaseAuth>(create: (context) => auth),
//           Provider<User>(create: (context) => user),
//           Provider<Future<void> Function(bool)>(create: (context){
//             return;
//           }),
//           ],
//         child: MaterialApp(
//           home: child,
//         ),
//       )
//   ,);
// }

// // mock for firebase auth functionality
// class MockAuth extends Mock implements BaseAuth{}

// class Keys{
//   static const Key MENU_BUTTON = Key("menuKT");
//   static const Key GO_TO_FRIENDS = Key("profileFL");
//   static const Key LOGOUT = Key("profileLog");
//   static const Key DELETE_USER = Key("profileDU");
//   static const Key SCAFFOLD = Key("MainScaffold");
// }

// void main() {
//   testWidgets('Profile Page Tests', (WidgetTester tester) async {

//     MockAuth mockAuth = new MockAuth();
//     String expectedEmail = "ktest@gmail.com";
//     String expectedPassword = "1234";
//     when(mockAuth.signIn(expectedEmail, expectedPassword)).thenAnswer((value){return Future.value("test id");});

//     bool didSignIn = false;
//     LogInSignupPage page = LogInSignupPage(loginCallback: (){
//       didSignIn = true;
//       return;
//     });


//     User user = User();
//     user.setUserId = "123";
//     user.setEmail = "testUser@domain.com";
//     user.setUserName = "testUser";
//     user.setMain = "Marth";
//     user.setSecondary = "Marth";
//     user.setRegion = "West Coast (WC)";
//     user.setFriendCode = "SW-1234-1234-1234";
//     user.setFriendCode = "SW-1234-1234-1234";

//     ProfilePage profile = ProfilePage();
    

//     await tester.pumpWidget(await makeTestableWidget(tester, profile, mockAuth, user));
//     await tester.pump();
//     Finder finder = find.byKey(Keys.MENU_BUTTON);
//     expect(finder, findsOneWidget);
//     await tester.tap(finder);
//     await tester.pump();

//     // Finder finder = find.byKey(Keys.GO_TO_FRIENDS);
//     // expect(finder, findsOneWidget);
//     // await tester.tap(finder); 
//     // await tester.pump();

//     // finder = find.byKey(Keys.LOGOUT);
//     // expect(finder, findsOneWidget);
//     // await tester.tap(finder); 
//     // await tester.pump();

//     // finder = find.byKey(Keys.DELETE_USER);
//     // expect(finder, findsOneWidget);

//   });
 
// }