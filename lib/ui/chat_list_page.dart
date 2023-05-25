// generate chat ui page
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:see_me_now/data/log.dart';
import 'package:provider/provider.dart' show Consumer;
import 'package:see_me_now/data/topics_model.dart';
import 'package:see_me_now/data/models/topic.dart';
import 'package:see_me_now/ui/home_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Charts'),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    // show coming soon dialog...
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Coming Soon'),
                          content: const Text('This feature is coming soon.'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () => Get.toNamed('/setting'),
                  child: const Icon(Icons.more_vert),
                )),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: const AllChatsWidget(),
        ));
  }
}

class AllChatsWidget extends StatefulWidget {
  const AllChatsWidget({super.key});
  @override
  State<StatefulWidget> createState() => _AllChatsWidgetState();
}

class _AllChatsWidgetState extends State<AllChatsWidget> {
  bool init = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AllTopics>(
      builder: (context, allTopics, child) {
        if (!init) {
          init = true;
          allTopics.refreshFromDB();
        }
        Log.log.fine(
            'building home chat list page with topic: ${allTopics.topics.length}');
        return ListView.builder(
            itemCount: allTopics.topics.length,
            itemBuilder: (context, index) {
              Topic topic = allTopics.topics[index];
              if (topic.name != null && topic.lastMessagePreview != null) {
                return ListTile(
                  title: Text(topic.name!),
                  subtitle: Text(topic.lastMessagePreview!),
                  onTap: () => Get.toNamed('/chats/${topic.id}'),
                );
              } else {
                return const SizedBox();
              }
            });
      },
    );
  }
}

class LatestChatsWidget extends StatefulWidget {
  const LatestChatsWidget({super.key});

  // show latest chart as list view
  @override
  State<LatestChatsWidget> createState() => _LatestChatsWidgetState();
}

class _LatestChatsWidgetState extends State<LatestChatsWidget> {
  bool init = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<LatestTopics>(
      builder: (context, latestTopics, child) {
        if (!init) {
          init = true;
          latestTopics.refreshFromDB();
        }
        Log.log.fine(
            'building home page with topic: ${latestTopics.topics.length}');
        return ListView.builder(
            itemCount: latestTopics.topics.length,
            itemBuilder: (context, index) {
              Topic topic = latestTopics.topics[index];
              if (topic.name != null && topic.lastMessagePreview != null) {
                return ListTile(
                  title: Text(topic.name!),
                  subtitle: Text(topic.lastMessagePreview!),
                  onTap: () => Get.toNamed('/chats/${topic.id}'),
                );
              } else {
                return const SizedBox();
              }
            });
      },
    );
  }
}

class ExtensibleTopicList extends StatefulWidget {
  const ExtensibleTopicList({super.key});

  @override
  _ExtensibleTopicListState createState() => _ExtensibleTopicListState();
}

class _ExtensibleTopicListState extends State<ExtensibleTopicList> {
  bool _isExpanded = false;
  bool _init = false;
  final int _defaultShowCount = 2;
  final HomeController c = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Consumer<AllTopics>(
      builder: (context, allTopics, child) {
        if (!_init) {
          _init = true;
          allTopics.refreshFromDB();
        }
        int showCount = _defaultShowCount;
        int leftCount = 0;
        if (allTopics.topics.length > _defaultShowCount) {
          leftCount = allTopics.topics.length - _defaultShowCount;
        } else {
          showCount = allTopics.topics.length;
        }
        Log.log.fine(
            'building chat list with topic count: ${allTopics.topics.length}, show count: $showCount, left count: $leftCount');
        return Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: showCount,
                itemBuilder: (context, index) {
                  Topic topic = allTopics.topics[index];
                  if (topic.name != null && topic.lastMessagePreview != null) {
                    return ListTile(
                      title: Text(topic.name!),
                      subtitle: Text(topic.lastMessagePreview!),
                      // onTap: () => Get.toNamed('/chats/${topic.id}'),
                      onTap: () => c.setTopicId(topic.id),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
            leftCount > 0
                ? Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          onTap: () async {
                            _isExpanded = !_isExpanded;
                            setState(() {});
                          },
                          child: _isExpanded
                              ? const Icon(Icons.expand_less)
                              : const Icon(Icons.expand_more)),
                    ),
                  )
                : Container(),
            leftCount > 0 && _isExpanded
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: leftCount,
                      itemBuilder: (context, index) {
                        Topic topic = allTopics.topics[index + showCount];
                        if (topic.name != null &&
                            topic.lastMessagePreview != null) {
                          return ListTile(
                            title: Text(topic.name!),
                            subtitle: Text(topic.lastMessagePreview!),
                            // onTap: () => Get.toNamed('/chats/${topic.id}'),
                            onTap: () => c.setTopicId(topic.id),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
