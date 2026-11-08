import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/size_config.dart';

class PhotoGalleryScreen extends StatelessWidget {
  final List<String> imageUrls;
  const PhotoGalleryScreen({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      body: InteractiveViewer(child: Body(imageUrls: imageUrls)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.back();
        },
        backgroundColor: kRestaurantColor,
        child: const Icon(CupertinoIcons.back),
      ),
    );
  }
}

class Body extends StatefulWidget {
  final List<String> imageUrls;

  const Body({super.key, required this.imageUrls});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _currentPage = 0;
  final PageController _controller = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );

  Widget _buildAnimatedStoryCard(String url, bool active) {
    // アクティブと非アクティブのアニメーション設定値
    final double top = active ? 0 : 36;
    final double side = active ? 0 : 36;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 36.0, right: side, left: side),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [kDefaultShadow],
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.contain),
      ),
    );
  }

  AnimatedContainer _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: _currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index ? kRestaurantColor : Colors.white,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: getScreenHeight() - 60,
              padding: const EdgeInsets.all(6.0),
              // width: getScreenWidth(),
              child: PageView.builder(
                onPageChanged: (val) {
                  setState(() {
                    _currentPage = val;
                  });
                },
                itemBuilder: (context, index) {
                  bool active = _currentPage == index;
                  return _buildAnimatedStoryCard(
                    widget.imageUrls[index],
                    active,
                  );
                },
                itemCount: widget.imageUrls.length,
                controller: _controller,
              ),
            ),
            SizedBox(
              height: 36,
              width: getScreenWidth(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) => _buildDot(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
