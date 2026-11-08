import 'package:algoliasearch/algoliasearch_lite.dart';
import 'package:mona_diner/config.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';

/// One page of posts returned by Algolia.
class PostSearchPage {
  const PostSearchPage({
    required this.posts,
    required this.page,
    required this.nbPages,
    required this.nbHits,
  });

  final List<MonaMenuPost> posts;
  final int page;
  final int nbPages;
  final int nbHits;

  bool get isLastPage => page >= nbPages - 1;
}

/// Searches the `posts` index that the Cloud Functions keep in sync with the
/// Firestore `posts` collection.
class PostSearch {
  PostSearch._();

  static final SearchClient _client = SearchClient(
    appId: AppConfig.algoliaAppId,
    apiKey: AppConfig.algoliaSearchKey,
  );

  static const postsIndex = 'posts';

  /// Builds Algolia facet filters for a restaurant's posts by a set of users.
  ///
  /// Top-level entries are ANDed; a nested list is ORed.
  static List<dynamic> restaurantPostsByUsers({
    required String restaurantUid,
    required List<String> userUids,
    required String menuGroup,
    String category = '',
  }) {
    return [
      'active:true',
      userUids.map((uid) => 'postedBy:$uid').toList(),
      'restaurantUid:$restaurantUid',
      if (category.isNotEmpty) 'menuItemCategories:$category',
      ['menuGroup:$menuGroup'],
    ];
  }

  static Future<PostSearchPage> search({
    required List<dynamic> facetFilters,
    int page = 0,
    int hitsPerPage = 24,
  }) async {
    final res = await _client.searchIndex(
      request: SearchForHits(
        indexName: postsIndex,
        query: '',
        facetFilters: facetFilters,
        hitsPerPage: hitsPerPage,
        page: page,
      ),
    );
    return PostSearchPage(
      posts: res.hits
          .map((hit) => MonaMenuPost.fromAlgolia(hit.toJson()))
          .toList(),
      page: res.page ?? page,
      nbPages: res.nbPages ?? 0,
      nbHits: res.nbHits ?? 0,
    );
  }
}
