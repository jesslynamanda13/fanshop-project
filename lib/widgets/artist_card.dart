import 'package:fanshop/models/artist_model.dart';
import 'package:flutter/material.dart';

class ArtistCard extends StatelessWidget {
  final ArtistModel artist;
  final bool isSelected;
  final Function(bool?) onChanged;

  const ArtistCard({
    Key? key,
    required this.artist,
    required this.isSelected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: isSelected,
                onChanged: onChanged,
                activeColor: const Color.fromARGB(255, 255, 247,
                    178), // Set the color to yellow when selected
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(artist.imageUrl),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 200,
                child: Text(
                  artist.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'DM Sans',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
