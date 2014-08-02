import 'dart:html';
import 'view.dart';

PuzzleView mainView;

void main() {
  mainView = new PuzzleView(querySelector('#canvas'));
  mainView.draw();
}
