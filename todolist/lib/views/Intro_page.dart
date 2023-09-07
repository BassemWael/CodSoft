import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_todo_list/views/Home_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 90.0, bottom: 40, left: 55.0),
              child: Row(
                children: [
                  Text('How it ',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  Text('works',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Image.asset('assets/images/intropage.jpg'),
            const Text('Manage Your',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
            const Text(
              'Everyday task list',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 8),
              child: Text(
                'This application helps you with your everyday',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 5),
              child: Text(
                'tasks and helps you manage your time',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 5),
              child: Text(
                'and finish as much as you can',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 25),
              child: Text(
                'A helpful tip: To delete something',
                style: TextStyle(
                    color: Color.fromARGB(255, 242, 160, 37), fontSize: 18),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 5),
              child: Text(
                'just swipe it to right or left',
                style: TextStyle(
                    color: Color.fromARGB(255, 242, 160, 37), fontSize: 18),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            // Skip button
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ElevatedButton(
                onPressed: () {
                  // Update the flag to indicate the user has seen the intro
                  updateIntroFlag();
                  // Navigate to the home page
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(252, 252, 92, 72),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.only(
                      left: 40.0, right: 40.0, top: 15, bottom: 15),
                  elevation: 10,
                ),
                child: const Text('Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to update the flag
  void updateIntroFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }
}
