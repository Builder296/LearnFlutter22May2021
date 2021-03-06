import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_flutter/cont/color.dart';
import 'package:learn_flutter/models/user_models.dart';
import 'package:learn_flutter/screens/home.dart';
import 'package:learn_flutter/services/user_service.dart';
import 'package:learn_flutter/widgets/logo.dart';

enum Language {
  th,
  en,
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Language languageSelected = Language.th;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.red[500],
      body: Container(
        padding: EdgeInsets.only(
          top: Get.mediaQuery.padding.top,
          bottom: Get.mediaQuery.padding.bottom,
        ),
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // top widget
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: Get.height * 0.1,
                  ),
                  width: Get.width,
                  child: Logo(),
                ),
                Container(
                  width: Get.width * 0.8,
                  height: 44,
                  margin: EdgeInsets.only(
                    top: Get.height * 0.1,
                  ),
                  child: loginButton(),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // left widgt - need help
                  needHelp(),
                  GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                        title: "เลือกภาษา",
                        content: Column(
                          children: [
                            languageMenu(
                                language: Language.th,
                                label: 'ภาษาไทย',
                                languageSelected: languageSelected),
                            languageMenu(
                                language: Language.en,
                                label: 'ภาษาอังกฤษ',
                                languageSelected: languageSelected)
                          ],
                        ),
                      );
                    },
                    child: Image.asset(
                      imagePathLanguage(languageSelected),
                      width: 24,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String imagePathLanguage(Language languageSelected) {
    return languageSelected == Language.th
        ? "assets/thai-flag.png"
        : "assets/eng-flag.png";
  }

  ListTile languageMenu(
      {required Language language,
      required String label,
      required Language languageSelected}) {
    return ListTile(
      leading: Image.asset(
        imagePathLanguage(language),
        width: 24,
      ),
      title: Text(label),
      trailing: language == languageSelected
          ? Icon(
              Icons.check,
              color: Colors.grey,
            )
          : null,
      onTap: () {
        setState(() {
          // re-render build()
          this.languageSelected = language;
        });
        // close dialog after select
        Get.back(); // porps stack out
      },
    );
  }

  Row needHelp() {
    return Row(
      children: [
        Text(
          "ต้องการความช่วยเหลือ ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Text(
          "คลิก",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      child: Text(
        'เข้าใช้งาน',
        style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.yellow.shade700),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 8,
          ),
        ),
      ),
      onPressed: () async {
        // await UserService().getUser()
        try {
          UserModel user = await UserService().getUser();
          Get.to(HomeScreen(
              fname: user.fname,
              lname: user.lname! // should be use with try catch for null value
              ));
        } catch (e) {
          print("getUser: $e");
        }

        // UserService().getUser().then((user) => {
        //       Get.to(HomeScreen(
        //         fname: user.fname,
        //         lname: user.lname! // should be use with try catch for null value
        //       )) // click and go to home screen
        //     }).catchError((error) {
        //       print("getUser: $error");
        //       // handle exception
        //     });

        // state management มีหลากหลายตัว
        // Get.to(HomeScreen()); // click and go to home screen
        // Navigator.of(context).push(
        //   // push stack
        //   MaterialPageRoute(
        //     builder: (context) => HomeScreen(),
        //   ),
        // );
      },
    );
  }
}
