/// * 2022-01
class WindowPlacement {
  int offsetX, offsetY;
  int width, height;

  bool get isValid {
    return (width > 0 && height > 0) &&
        (offsetX >= 0 && offsetX < width) &&
        (offsetY >= 0 && offsetY < height);
  }

  WindowPlacement({
    required this.offsetX,
    required this.offsetY,
    required this.width,
    required this.height,
  });
}
