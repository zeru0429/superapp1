import 'package:flutter/material.dart';
import 'package:superapp/apps/mezemur/components/card/custome_card.dart';
import 'package:superapp/apps/mezemur/components/card/circle.dart';

class CardRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Set the desired height for your cards
      child: ListView(
        scrollDirection: Axis.horizontal, // Horizontal scrolling
        children: [
          CircularAvatarCard(
            imageAsset: const AssetImage(
                'assets/images/orto.jpg'), // Replace with your asset path
            title: 'User 1',
            subtitle: 'Subtitle 1',
          ),
          CircularAvatarCard(
            imageAsset: const AssetImage(
                'assets/images/orto.jpg'), // Replace with your asset path
            title: 'User 2',
            subtitle: 'Subtitle 2',
          ),
// Add more CircularAvatarCard instances with different asset paths

          CustomCard(
            assetImageUrl:
                'assets/images/orto.jpg', // Replace with your asset image path
            title: 'Title',
            subtitle: 'Subtitle',
          ),
          CustomCard(
            assetImageUrl:
                'assets/images/orto.jpg', // Replace with your asset image path
            title: 'Title',
            subtitle: 'Subtitle',
          ),
          CustomCard(
            assetImageUrl:
                'assets/images/orto.jpg', // Replace with your asset image path
            title: 'Title',
            subtitle: 'Subtitle',
          ),
          CustomCard(
            assetImageUrl:
                'assets/images/orto.jpg', // Replace with your asset image path
            title: 'Title',
            subtitle: 'Subtitle',
          ),
          CustomCard(
            assetImageUrl:
                'assets/images/orto.jpg', // Replace with your asset image path
            title: 'Title',
            subtitle: 'Subtitle',
          ),
          CustomCard(
            assetImageUrl:
                'assets/images/orto.jpg', // Replace with your asset image path
            title: 'Title',
            subtitle: 'Subtitle',
          ),

          // Add more CustomCard widgets as needed
        ],
      ),
    );
  }
}
