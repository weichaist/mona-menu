import 'package:flutter_test/flutter_test.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/screens/top_level_components/money/to_jpy_string.dart';
import 'package:mona_diner/services/post_search.dart';

void main() {
  group('PostSearch.restaurantPostsByUsers', () {
    test('ANDs the restaurant filters and ORs the users', () {
      final filters = PostSearch.restaurantPostsByUsers(
        restaurantUid: 'r1',
        userUids: ['u1', 'u2'],
        menuGroup: 'lunch',
      );
      expect(filters, [
        'active:true',
        ['postedBy:u1', 'postedBy:u2'],
        'restaurantUid:r1',
        ['menuGroup:lunch'],
      ]);
    });

    test('adds the category filter when one is selected', () {
      final filters = PostSearch.restaurantPostsByUsers(
        restaurantUid: 'r1',
        userUids: ['u1'],
        menuGroup: 'dinner',
        category: 'Pasta',
      );
      expect(filters, contains('menuItemCategories:Pasta'));
    });
  });

  test('PostSearchPage.isLastPage', () {
    const page = PostSearchPage(posts: [], page: 1, nbPages: 2, nbHits: 30);
    expect(page.isLastPage, isTrue);
    const first = PostSearchPage(posts: [], page: 0, nbPages: 2, nbHits: 30);
    expect(first.isLastPage, isFalse);
  });

  test('MonaMenuPost.fromAlgolia reads a record indexed by the functions', () {
    final post = MonaMenuPost.fromAlgolia({
      'objectID': 'p1',
      'postId': 'p1',
      'menuItemName': 'Margherita',
      'menuItemCategories': ['Pizza'],
      'menuItemId': 'm1',
      'restaurantUid': 'r1',
      'comment': 'Great crust',
      'images': [
        {'url': 'https://example.com/a.jpg', 'ref': 'posts/a.jpg'},
      ],
      'postedBy': 'u1',
      'postedAt': {'_seconds': 1650000000, '_nanoseconds': 0},
    });
    expect(post.postId, 'p1');
    expect(post.userComment, 'Great crust');
    expect(post.userImages, ['https://example.com/a.jpg']);
    expect(post.userImagesWithRef!.single['ref'], 'posts/a.jpg');
    expect(
      post.postedAt!.toUtc(),
      DateTime.fromMillisecondsSinceEpoch(1650000000 * 1000, isUtc: true),
    );
  });

  test('toJPYString formats yen without decimals', () {
    expect(toJPYString(1200), '\u{FFE5}1,200'); // full-width yen sign
  });
}
