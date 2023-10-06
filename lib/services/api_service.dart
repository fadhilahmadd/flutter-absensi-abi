import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.123.6:8000';

  static Future<Map<String, dynamic>> login(
      String username, String password, [userId]) async {
    final Uri loginUri = Uri.parse('$baseUrl/login');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> bodyData = {
      'username': username,
      'password': password,      
    };

    final response = await http.post(
      loginUri,
      headers: headers,
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(errorData['message']);
    } else {
      throw Exception('Login gagal');
    }
  }

  static Future<Map<String, dynamic>> register(String nama, String username,
      String password, String konfirmasiPassword, int isAdmin) async {
    final Uri registerUri = Uri.parse('$baseUrl/register');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> bodyData = {
      'nama': nama,
      'username': username,
      'password': password,
      'konfirmasi_password': konfirmasiPassword,
      'is_admin': isAdmin,
    };

    final response = await http.post(
      registerUri,
      headers: headers,
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(errorData['message']);
    } else {
      throw Exception('Pendaftaran gagal');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final Uri usersUri = Uri.parse('$baseUrl/user');
    final response = await http.get(usersUri);

    if (response.statusCode == 200) {
      final List<dynamic> userList = json.decode(response.body);
      return userList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil user data');
    }
  }

  static Future<Map<String, dynamic>> getUser(int userId) async {
    final Uri userUri = Uri.parse('$baseUrl/user/$userId');
    final response = await http.get(userUri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User tidak ditemukan');
    } else {
      throw Exception('Gagal mengambil user data');
    }
  }

  static Future<void> editUser(int userId, String nama, String username,
      String password, String konfirmasiPassword, int isAdmin) async {
    final Uri editUserUri = Uri.parse('$baseUrl/edit/$userId');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> bodyData = {
      'nama': nama, 
      'username': username,
      'password': password,
      'konfirmasi_password': konfirmasiPassword,
      'is_admin': isAdmin,
    };

    final response = await http.put(
      editUserUri,
      headers: headers,
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 200) {
    } else if (response.statusCode == 404) {
      throw Exception('User tidak ditemukan');
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(errorData['message']);
    } else {
      throw Exception('Gagal mengedit user');
    }
  }

  static Future<int> getUserIdByUsername(String username) async {
    final Uri userByUsernameUri = Uri.parse('$baseUrl/user/username/$username');
    final response = await http.get(userByUsernameUri);

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      return userData[
          'id']; // Assuming 'id' is the field in the response that represents the user's ID
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to get user ID by username');
    }
  }

  Future<String> getIpAddress(response) async {
    final response =
        await http.get(Uri.parse('https://api64.ipify.org?format=json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['ip'];
    } else {
      throw Exception('Failed to load IP address');
    }
  }
}
