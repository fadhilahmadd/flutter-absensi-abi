import 'package:absen/components/user/UserDashboard.dart';
import 'package:absen/components/user/UserProfile.dart';
import 'package:absen/components/user/maps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class User extends StatefulWidget {
  final String username;
  final int userId;

  const User({Key? key, required this.username, required this.userId}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  int currentPage = 0;
  final PageController _page = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 87, 178, 235),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      SizedBox(height: 1),
                      Text(
                        widget.username,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _page,
        onPageChanged: ((value) {
          setState(() {
            currentPage = value;
          });
        }),
        children: <Widget>[
          UserDashboard(username: widget.username, userId: widget.userId,),
          UserMaps(username: widget.username),
          UserProfile(username: widget.username),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page) {
          setState(() {
            currentPage = page;
            _page.animateToPage(
              page,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
            label: 'Absen',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.mapLocation,
            ),
            label: 'Lokasi',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.userLarge,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
