import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:absen/utils/config.dart';
import 'package:flutter/material.dart';

class UserMaps extends StatefulWidget {
  final String username;

  const UserMaps({Key? key, required this.username}) : super(key: key);

  @override
  State<UserMaps> createState() => _UserMapsState();
}

class _UserMapsState extends State<UserMaps> {
  String formattedTime = DateFormat.Hm('id_ID').format(DateTime.now());
  String? _currentAddress;
  Position? _currentPosition;
  String _accountName = '';
  String selectedOption = 'Hadir';
  List<String> options = [
    'Hadir',
    'Sakit',
    'WFH',
    'Ijin',
    'Alpa',
  ];

  Future<void> _fetchAccountName() async {
    // final userId = '';

    try {
      final response = await http.get(
        Uri.parse('http://192.168.123.6:8000/getUserIdByUsername'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final accountName = jsonResponse['nama'];

        setState(() {
          _accountName = accountName;
        });
      } else {
        print('Gagal mengambil data dari API: ${response.statusCode}');
      }
    } catch (error) {
      print('Terjadi kesalahan saat menghubungi API: $error');
    }
  }

  Future<void> ceklokasi() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('GPS Tidak Aktif'),
            content: Text(
                'Untuk menggunakan fitur lokasi, aktifkan GPS perangkat Anda.'),
            actions: <Widget>[
              TextButton(
                child: Text('Tutup'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<Position> getCurrentLocation() async {
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    try {
      final position = await geolocator.getCurrentPosition(
          // desiredAccuracy: LocationAccuracy.high,
          );
      return position;
    } catch (e) {
      print("Error getting location: $e");
      return Future.error("Error getting location");
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void _updateTime() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (Timer timer) {
      setState(() {
        formattedTime = DateFormat('HH:mm:ss', 'id_ID').format(DateTime.now());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    ceklokasi();
    getCurrentLocation().then((position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng(_currentPosition!);
      });
    });
    _getCurrentPosition();
    _updateTime();
    _fetchAccountName();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('EEEE, dd MMMM y', 'id_ID').format(DateTime.now());
    Config().init(context);
    return Scaffold(
      body: Stack(
        children: [
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
          Positioned(
            top: 5,
            left: 15,
            child: Text(
              'Data Absensi',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Color.fromARGB(255, 240, 227, 116)),
            ),
          ),
          Positioned(
            top: 35,
            left: 15,
            child: Text(
              'Nama Karyawan',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 55,
            left: 15,
            child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _accountName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 15,
            child: Text(
              'Status Absen',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 15,
            child: Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width - 30,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue!;
                  });
                },
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      width: 300,
                      child: Text(
                        option,
                      ),
                    ),
                  );
                }).toList(),
                underline: Container(),
              ),
            ),
          ),
          Positioned(
            top: 170,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 230,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Positioned(
            top: 270,
            child: Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width - 10,
              child: FutureBuilder<Position>(
                future: getCurrentLocation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: 2.0,
                      height: 1.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final position = snapshot.data;
                    final locationText =
                        'Latitude: ${position?.latitude}, Longitude: ${position?.longitude}';
                    final alamatText = 'Lokasi: ${_currentAddress ?? ""}';
                    return Center(
                      child: Text(
                        alamatText,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: 330,
            left: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.blue,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.login,
                    size: 20,
                  ),
                  Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 330,
            right: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.red,
              ),
              child: Row(
                children: [
                  Text(
                    'Pulang',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.logout,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
