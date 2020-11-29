enum Priority {
HIGH,
MEDIUM,
LOW,
}

class Task {
  Task({this.title, this.priority, this.streak, this.lastStreak, this.daysPassedFromBeggining, this.daysTillGoal, this.totalDayCounter});

  String title;
  Priority priority;
  int streak;
  int lastStreak;
  int totalDayCounter;
  int daysPassedFromBeggining;
  int daysTillGoal;
}