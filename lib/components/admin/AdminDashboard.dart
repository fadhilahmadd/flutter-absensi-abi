import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../services/api_service.dart';

class AdminDashboard extends StatefulWidget {
  final String username;

  const AdminDashboard({Key? key, required this.username}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<dynamic> userList = [];
  List<dynamic> filteredUserList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final users = await ApiService.getAllUsers();

      setState(() {
        userList = users;
        filteredUserList = users;
      });
    } catch (e) {
      print('Failed to load users: $e');
    }
  }

  void filterUsers(String query) {
    final List<dynamic> filteredUsers = userList.where((user) {
      final String nama = user['nama'].toLowerCase();
      return nama.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredUserList = filteredUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 241, 240, 241),
                  Color.fromARGB(255, 241, 240, 241),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterUsers(value);
                },
                decoration: InputDecoration(
                  labelText: 'Cari berdasarkan nama',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          userList.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: Container(
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
                    child: ListView.builder(
                      itemCount: filteredUserList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final userData = filteredUserList[index];
                        return ListTile(
                          title: Text('User ID: ${userData['user_id']}'),
                          subtitle: Text('Name: ${userData['nama']}'),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
