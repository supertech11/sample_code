import 'package:flutter/material.dart';

class Ride {
  String cardTitle;
  IconData icon;
  int tasksRemaining;
  double taskCompletion;

  Ride(this.cardTitle, this.icon, this.tasksRemaining, this.taskCompletion);
}
