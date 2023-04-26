import 'package:flutter/material.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/task.dart';
import 'package:get/get.dart';

// show task detail and let user score it
// ignore: must_be_immutable
class RatingWidget extends StatefulWidget {
  SeeTask? task;
  SeeGoal? goal;
  final int maxRating;
  final Function(int) onRatingSubmit;
  RatingWidget(
      {Key? key,
      this.goal,
      this.task,
      this.maxRating = 10,
      required this.onRatingSubmit})
      : super(key: key);

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    String timeUsedInMinutes = '';
    if (widget.task == null) {
      return Container();
    }
    DateTime now = DateTime.now();
    String startTime;
    if (widget.task!.startTime != null) {
      timeUsedInMinutes = now
          .difference(widget.task?.startTime ?? DateTime.now())
          .inMinutes
          .toString();
      startTime = widget.task?.startTime?.toString().substring(11, 16) ?? '';
    } else {
      timeUsedInMinutes = now
          .difference(widget.task?.insertTime ?? DateTime.now())
          .inMinutes
          .toString();
      startTime = widget.task?.insertTime.toString().substring(11, 16) ?? '';
    }
    timeUsedInMinutes += ' min';
    Log.log.fine(
        'rendering RatingWidget, timeUsedInMinutes: $timeUsedInMinutes, startTime: ${widget.task?.startTime}, endTime: ${widget.task?.endTime}');
    // start time, show only hour:min
    return Material(
      child: Container(
        padding:
            const EdgeInsets.only(top: 60, left: 10, right: 10, bottom: 30),
        child: Column(
          children: [
            //show task name, description and start time
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    widget.goal?.name ?? '',
                    textAlign: TextAlign.left,
                    softWrap: true,
                  ),
                  Text(
                    widget.task?.description ?? '',
                    textAlign: TextAlign.left,
                    softWrap: true,
                  ),
                  Text(
                    startTime,
                    textAlign: TextAlign.left,
                    softWrap: true,
                  ),
                  Text(
                    timeUsedInMinutes.toString(),
                    textAlign: TextAlign.left,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            // score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(widget.maxRating, (index) {
                return Flexible(
                  child: IconButton(
                    icon: Icon(
                      rating > index ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                  ),
                );
              }),
            ),
            // submit button
            IconButton(
              onPressed: () {
                widget.onRatingSubmit(rating);
                Get.back();
              },
              icon: const Icon(Icons.done),
            ),
          ],
        ),
      ),
    );
  }
}
