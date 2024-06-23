import 'package:flutter/material.dart';
import 'package:vivarium/search/models/nature_model.dart';
import 'package:vivarium/search/views/search_detail_screen.dart';

class CategoryGridView extends StatelessWidget {
  final String category;
  final Set<String> likedNatures;
  final Function(String) onHeartTap;
  final VoidCallback onRefresh;
  final List<NatureModel> natures;

  const CategoryGridView({
    super.key,
    required this.category,
    required this.likedNatures,
    required this.onHeartTap,
    required this.onRefresh,
    required this.natures,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: natures.length,
      padding: const EdgeInsets.all(5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        childAspectRatio: 9 / 19,
      ),
      itemBuilder: (context, index) {
        var natural = natures[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchDetailScreen(
                  nature: natural,
                ),
              ),
            ).then((isLiked) {
              if (isLiked != null) {
                onRefresh();
              }
            });
          },
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AspectRatio(
                      aspectRatio: 9 / 15,
                      child: Image.network(
                        natural.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => onHeartTap(natural.title),
                    icon: Icon(
                      likedNatures.contains(natural.title)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                    ),
                    iconSize: 35,
                    color: Colors.red,
                  ),
                ],
              ),
              Text(
                natural.title,
                style: const TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
