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
  Pets serachedPets = Pets(data: []);
  String searchText = '';

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
    updateData();
  }

  updateData() {
    serachedPets.data.clear();
    if (searchText.isEmpty) {
      serachedPets.data.addAll(pets.data);
    } else {
      serachedPets.data.addAll(pets.data
          .where((element) =>
              element.userName.toLowerCase().startsWith(searchText))
          .toList());
    }
    notifyListeners();
  }

  search(String username) {
    searchText = username;
    updateData();
  }
  //
}
