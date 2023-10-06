import 'dart:convert';

import 'package:absen/components/admin/admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Calender extends StatefulWidget {
  final username;

  const Calender({Key? key, required this.username}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchAndSetCurrentDate();
  }

  Future<String> getIpAddress() async {
    final response =
        await http.get(Uri.parse('https://api64.ipify.org?format=json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['ip'];
    } else {
      throw Exception('Failed to load IP address');
    }
  }

  Future<void> _fetchAndSetCurrentDate() async {
    final ipAddress = await getIpAddress();
    final date = DateTime.parse(ipAddress); // Ubah IP menjadi DateTime
    setState(() {
      _currentDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromARGB(255, 87, 178, 235),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      SizedBox(height: 1),
                      Text(
                        widget.username + ' administator',
                        style: TextStyle(
                          color: Colors.red,
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ikon kembali
          onPressed: () {
            // Navigasi ke halaman authDashboard
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Admin(username: widget.username),
              ),
            );
          },
        ),
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 241, 240, 241),
                Color.fromARGB(255, 87, 178, 235),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CalendarCarousel<Event>(
                  onDayPressed: (DateTime date, List<Event> events) {
                    setState(() => _currentDate = date);
                  },
                  weekendTextStyle: const TextStyle(
                    color: Colors.red,
                  ),
                  thisMonthDayBorderColor: Colors.grey,
                  customDayBuilder: (
                    /// you can provide your own build function to make custom day containers
                    bool isSelectable,
                    int index,
                    bool isSelectedDay,
                    bool isToday,
                    bool isPrevMonthDay,
                    TextStyle textStyle,
                    bool isNextMonthDay,
                    bool isThisMonthDay,
                    DateTime day,
                  ) {
                    return null;
                  },
                  weekFormat: false,
                  height: 360.0,
                  todayButtonColor: Colors.black54,
                  selectedDateTime: _currentDate,
                  markedDateShowIcon: true,
                  markedDateIconMaxShown: 1,
                  daysHaveCircularBorder: false,
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
