import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api/environment.dart';
import '../../models/student.dart';
import '../../utils/shared_pref.dart';

class StudentsProvider {
  final String _url = Environment.API_URL;
  final String _api = '/api/apoderado';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<List<Student>?> getStudents(int id) async {
    try {
      final user = SharedPref().read('user');
      final token = (await user)['token'];

      Uri url = Uri.http(_url, '$_api/$id/estudiantes');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      
      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body)['data'];

      // ignore: avoid_print
      print('DATA: $data');

      Student results = Student.fromJsonList(data);
      return results.toList;
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return null;
    }
  }

  // Future<List<Student>?> getPendingStudents() async {
  //   try {
  //     Uri url = Uri.http(_url, '$_api/getPending');
  //     Map<String, String> headers = {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //     };
  //     final res = await http.get(url, headers: headers);
  //     final data = json.decode(res.body)['data'];

  //     // ignore: avoid_print
  //     print('DATA: $data');

  //     Student results = Student.fromJsonList(data);
  //     return results.toList;
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print('Error: $e');
  //     return null;
  //   }
  // }

  // Future<Stream?> createWithImage(
  //     Student Student, File? photo, File? audio) async {
  //   try {
  //     Uri url = Uri.http(_url, '$_api/create');
  //     final request = http.MultipartRequest('POST', url);

  //     if (photo != null) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //         'photo',
  //         photo.path,
  //       ));
  //     }

  //     if (audio != null) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //         'voice_note',
  //         audio.path,
  //       ));
  //     }

  //     request.fields['problem_description'] = Student.problemDescription;
  //     request.fields['status'] = Student.status;
  //     request.fields['latitude'] = Student.latitude;
  //     request.fields['longitude'] = Student.longitude;
  //     request.fields['vehicle_id'] = Student.vehicleId;
  //     request.fields['customer_id'] = Student.customerId;

  //     final response = await request.send(); // Se envia peticion a la api
  //     return response.stream.transform(utf8.decoder);
  //   } catch (error) {
  //     // ignore: avoid_print
  //     print('Error: $error');
  //     return null;
  //   }
  // }
}
