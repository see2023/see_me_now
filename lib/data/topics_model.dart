import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/models/topic.dart';

class LatestTopics extends ChangeNotifier {
  int showCount;
  bool hasMore = true;
  final List<Topic> _topics = [];
  UnmodifiableListView<Topic> get topics => UnmodifiableListView(_topics);

  LatestTopics({this.showCount = 2});

  Future<bool> refreshFromDB() async {
    try {
      var newItems = await DB.getTopics(0, showCount);
      _topics.clear();
      _topics.addAll(newItems);
      if (newItems.length < showCount) {
        hasMore = false;
      }
      notifyListeners();
      Log.log.fine('refreshing LatestTopics with ${newItems.length} items');
      return true;
    } catch (e) {
      Log.log.warning('refresh error: $e');
      return false;
    }
  }

  void update(int topicId, String lastMessage, {bool notify = true}) {
    bool found = false;
    var preview =
        lastMessage.substring(0, min(DB.previewLen, lastMessage.length));
    for (var i = 0; i < _topics.length; i++) {
      if (_topics[i].id == topicId) {
        _topics[i].lastMessagePreview = preview;
        _topics[i].updatedAt = DateTime.now();
        found = true;
        Log.log.fine(
            'setting topic update topic $topicId in ${_topics.length} items');
        break;
      }
    }
    _topics.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

    if (found && notify) {
      notifyListeners();
    }
  }

  void removeAll({bool notify = false}) {
    _topics.clear();
    if (notify) {
      notifyListeners();
    }
  }
}

class AllTopics extends LatestTopics {
  int incCount = 50;

  AllTopics({this.incCount = 50, super.showCount = 50});

  Future<bool> getMoreData() async {
    try {
      var newItems = await DB.getTopics(_topics.length, incCount);
      _topics.addAll(newItems);
      if (newItems.length < showCount) {
        hasMore = false;
      }
      notifyListeners();
      return true;
    } catch (e) {
      Log.log.warning('getIncData error: $e');
      return false;
    }
  }
}
