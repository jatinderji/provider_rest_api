import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:provider_rest_api/providers/pets_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final provider = Provider.of<PetsProvider>(context, listen: false);
    provider.getDataFromAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('build called');
    final provider = Provider.of<PetsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider API Call'),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? getLoadingUI()
          : provider.error.isNotEmpty
              ? getErrorUI(provider.error)
              : getBodyUI(),
    );
  }

  Widget getLoadingUI() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SpinKitFadingCircle(
            color: Colors.blue,
            size: 80,
          ),
          Text(
            'Loading...',
            style: TextStyle(fontSize: 20, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget getErrorUI(String error) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(color: Colors.red, fontSize: 22),
      ),
    );
  }

  Widget getBodyUI() {
    final provider = Provider.of<PetsProvider>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              provider.search(value);
            },
            decoration: InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: Consumer(
            builder: (context, PetsProvider petsProvider, child) =>
                ListView.builder(
              itemCount: petsProvider.serachedPets.data.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                      petsProvider.serachedPets.data[index].petImage),
                  backgroundColor: Colors.white,
                ),
                title: Text(petsProvider.serachedPets.data[index].userName),
                trailing: petsProvider.serachedPets.data[index].isFriendly
                    ? const SizedBox()
                    : const Icon(
                        Icons.pets,
                        color: Colors.red,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
