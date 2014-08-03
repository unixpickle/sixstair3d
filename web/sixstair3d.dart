import 'dart:html';
import 'sixstair_view/sixstair_view.dart';

PuzzleView mainView;

void main() {
  mainView = new PuzzleView(querySelector('#canvas'));
  mainView.draw();
}
