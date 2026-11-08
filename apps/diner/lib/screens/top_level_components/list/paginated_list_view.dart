import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';

class PaginatedListView extends StatefulWidget {
  final Query query;
  final int pageSize;
  final Widget Function(BuildContext, Map<String, dynamic>) build;
  const PaginatedListView({
    super.key,
    required this.query,
    required this.pageSize,
    required this.build,
  });
  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  @override
  void initState() {
    super.initState();
    _query = widget.query;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchOutstandingOrders();
    });
  }

  late Query _query;
  List<Map<String, dynamic>> list = [];
  bool _isLoading = false;
  bool _allFetched = false;
  DocumentSnapshot? _lastDocument;

  Future<void> _reload() async {
    _query = widget.query;
    list.clear();
    _isLoading = false;
    _allFetched = false;
    _lastDocument = null;
    await _fetchOutstandingOrders();
  }

  Future<void> _fetchOutstandingOrders() async {
    if (_isLoading || _allFetched) {
      return;
    } else {
      _isLoading = true;
      if (_lastDocument != null) {
        _query = _query
            .startAfterDocument(_lastDocument!)
            .limit(widget.pageSize);
      } else {
        _query = _query.limit(widget.pageSize);
      }
      final List<Map<String, dynamic>> paginatedOrders = await _query
          .get()
          .then((snap) {
            if (snap.docs.isNotEmpty) {
              _lastDocument = snap.docs.last;
              return snap.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();
            } else {
              _lastDocument = null;
              return [];
            }
          });
      list.addAll(paginatedOrders);
      if (paginatedOrders.length < widget.pageSize) {
        _allFetched = true;
      }
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (list.isNotEmpty) {
      return NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          if (scrollEnd.metrics.pixels >= scrollEnd.metrics.maxScrollExtent &&
              !_isLoading) {
            _fetchOutstandingOrders();
          }
          return true;
        },
        child: RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: () async {
            await _reload();
          },
          child: ListView.builder(
            physics: _allFetched
                ? const ClampingScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            itemBuilder: (context, index) {
              if (index < list.length) {
                Map<String, dynamic> data = list[index];
                return widget.build(context, data);
              } else {
                if (!_allFetched) {
                  return const SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                } else {
                  return const SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Center(
                      child: Icon(
                        CupertinoIcons.arrow_up_to_line_alt,
                        color: kPrimaryColor,
                      ),
                    ),
                  );
                }
              }
            },
            itemCount: list.length + 1,
          ),
        ),
      );
    } else {
      return const SizedBox(
        width: double.infinity,
        height: 120,
        child: Center(child: CupertinoActivityIndicator()),
      );
    }
  }
}
