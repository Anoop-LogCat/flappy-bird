double barrierHeight(double value, double maxHeight) {
  double percentage = value.abs() * 100;
  double x = (percentage * (maxHeight / 2)) / 100;
  return x;
}
