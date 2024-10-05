import 'package:flutter/material.dart';
import 'package:flutter_application/app/modules/3_favorite/controllers/favorite_controller.dart';
import 'package:get/get.dart';

class FavoriteView extends StatelessWidget {
  FavoriteView({super.key});
  final FavoriteController controller = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Obx(
          () => ListView.builder(
            itemCount: controller.favoriteItems.length,
            itemBuilder: (context, index) {
              final item = controller.favoriteItems[index];
              return FavoriteItemCard(
                item: item,
                index: index,
              );
            },
          ),
        ),
      ),
    );
  }
}

class FavoriteItemCard extends StatefulWidget {
  final Map<String, String> item;
  final int index;

  const FavoriteItemCard({super.key, required this.item, required this.index});

  @override
  // ignore: library_private_types_in_public_api
  _FavoriteItemCardState createState() => _FavoriteItemCardState();
}

class _FavoriteItemCardState extends State<FavoriteItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Define the slide transition animation
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0), // Start from above
      end: const Offset(0.0, 0.0), // Slide to original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation with a slight delay
    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Dismissible(
        key: Key(widget.item['title']!), // Unique key based on the title
        direction: DismissDirection.endToStart, // Swipe left to right
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.red,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {
          // Hapus item dari controller ketika di swipe
          Get.find<FavoriteController>().removeItem(widget.index);

          // Tampilkan snackbar atau notifikasi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.item['title']} removed')),
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.item['image']!),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item['title']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.item['location']!,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.item['price']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}