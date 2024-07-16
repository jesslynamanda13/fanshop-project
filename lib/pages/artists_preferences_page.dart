import 'package:fanshop/arguments/user_argument.dart';
import 'package:fanshop/models/artist_model.dart';
import 'package:fanshop/widgets/artist_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArtistPreferencesPage extends StatefulWidget {
  final String uid;
  final String username;
  final String name;
  const ArtistPreferencesPage(
      {super.key,
      required this.uid,
      required this.username,
      required this.name});

  @override
  _ArtistPreferencesPageState createState() => _ArtistPreferencesPageState();
}

class _ArtistPreferencesPageState extends State<ArtistPreferencesPage> {
  late Future<List<ArtistModel>> futureArtists;
  List<String> selectedArtists = [];

  @override
  void initState() {
    super.initState();
    futureArtists = fetchArtists();
  }

  Future<List<ArtistModel>> fetchArtists() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await _firestore.collection('artists').get();

    return querySnapshot.docs
        .map((doc) => ArtistModel.fromFirestore(doc))
        .toList();
  }

  void onArtistSelectionChanged(String artistName, bool? isSelected) {
    setState(() {
      if (isSelected == true) {
        selectedArtists.add(artistName);
        print("Selected artists: $selectedArtists");
      } else {
        selectedArtists.remove(artistName);
      }
    });
  }

  void _continue(String uid) async {
    print("Selected artists: $selectedArtists");
    print("User ID: $uid");
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    try {
      QuerySnapshot querySnapshot =
          await usersCollection.where('uid', isEqualTo: uid).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await usersCollection.doc(docId).set({
          'preferences': selectedArtists,
        }, SetOptions(merge: true));
        Navigator.of(context).pushNamed("/homepage",
            arguments: UserArgument(widget.uid, widget.username, widget.name));
      } else {
        print("User with UID $uid not found in Firestore");
      }
    } catch (error) {
      print("Failed to update user preferences: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserArgument;
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Explore your",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                const Text(
                  "favorite artists.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Select your favorite artists to get started.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20.0),
                SingleChildScrollView(
                  child: Expanded(
                    child: FutureBuilder<List<ArtistModel>>(
                      future: futureArtists,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading artists'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('No artists found'));
                        } else {
                          List<ArtistModel> artists = snapshot.data!;
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: artists.map((artist) {
                                bool isSelected =
                                    selectedArtists.contains(artist.name);
                                return ArtistCard(
                                  artist: artist,
                                  isSelected: isSelected,
                                  onChanged: (bool? value) {
                                    onArtistSelectionChanged(
                                        artist.name, value);
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF202020),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/homepage",
                          arguments: UserArgument(
                              widget.uid, widget.username, widget.name));
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _continue(args.uid);
                    },
                    child: const Text("Continue",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
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
