import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivarium/search/models/nature_model.dart';

class SearchDetailScreen extends StatefulWidget {
  final Nature nature;

  const SearchDetailScreen({
    super.key,
    required this.nature,
  });

  @override
  State<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  late SharedPreferences favorites;
  bool isLiked = false;

  Future initFavorites() async {
    favorites = await SharedPreferences.getInstance();
    final likedNatures = favorites.getStringList('likedNatures');
    if (likedNatures != null &&
        likedNatures.contains(widget.nature.id.toString())) {
      setState(() {
        isLiked = true;
      });
    } else {
      await favorites.setStringList('likedNatures', []);
    }
  }

  @override
  void initState() {
    super.initState();
    initFavorites();
  }

  void onHeartTap() async {
    final likedNatures = favorites.getStringList('likedNatures');
    if (likedNatures != null) {
      setState(() {
        if (isLiked) {
          likedNatures.remove(widget.nature.id.toString());
        } else {
          likedNatures.add(widget.nature.id.toString());
        }
        isLiked = !isLiked;
      });
      await favorites.setStringList('likedNatures', likedNatures);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nature = widget.nature;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline,
              color: Colors.red,
            ),
            iconSize: 30,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              nature.imageUrl,
              fit: BoxFit.cover,
              height: 300,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              nature.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              "💡제품 설명💡",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DottedBorder(
              borderType: BorderType.RRect,
              color: Colors.grey,
              strokeWidth: 1,
              dashPattern: const [8, 4],
              radius: const Radius.circular(12),
              child: Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    nature.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
