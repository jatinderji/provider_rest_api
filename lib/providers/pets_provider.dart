import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider_rest_api/models/pets.dart';
import 'package:http/http.dart' as http;

class PetsProvider extends ChangeNotifier {
  static const apiEndpoint =
      'https://jatinderji.github.io/users_pets_api/users_pets.json';

  bool isLoading = true;
  String error = '';
  Pets pets = Pets(data: []);

  //
  getDataFromAPI() async {
    try {
      Response response = await http.get(Uri.parse(apiEndpoint));
      if (response.statusCode == 200) {
        pets = petsFromJson(response.body);
      } else {
        error = response.statusCode.toString();
      }
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
  //
}
