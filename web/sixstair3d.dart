import 'dart:html';
import 'sixstair_view/sixstair_view.dart';

PuzzleView mainView;

void main() {
  PuzzleRep rep = new PuzzleRep();
  mainView = new PuzzleView(querySelector('#canvas'));
  mainView.puzzleRep = rep;
  mainView.draw();
}
