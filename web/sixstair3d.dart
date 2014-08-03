import 'dart:html';
import 'sixstair_view/sixstair_view.dart';
import 'sixstair_animation/sixstair_animation.dart';

PuzzleView mainView;
AnimateRep rep;

typedef void MoveFunc();
List<MoveFunc> pending;

void turnClockwise() {
  rep.animateTurn(true, mainView.draw);
}

void turnCounterClockwise() {
  rep.animateTurn(false, mainView.draw);
}

void flip() {
  rep.animateFlip(mainView.draw);
}

void runNext(_) {
  if (pending.length == 0) return;
  MoveFunc func = pending[0];
  pending.removeAt(0);
  func();
  if (pending.length != 0) {
    rep.future.then(runNext);
  }
}

void pushMove(MoveFunc func) {
  pending.add(func);
  if (pending.length == 1) {
    rep.future.then(runNext);
  }
}

void main() {
  pending = [];
  
  rep = new AnimateRep();
  try {
    mainView = new PuzzleView(querySelector('#canvas'));
  } on UnsupportedError {
    window.alert('You must enable WebGL!');
    return;
  }
  mainView.puzzleRep = rep;
  mainView.draw();
  
  querySelector('#flip-button').onClick.listen((_) {
    pushMove(flip);
  });
  querySelector('#clock-button').onClick.listen((_) {
    pushMove(turnClockwise);
  });
  querySelector('#counter-button').onClick.listen((_) {
    pushMove(turnCounterClockwise);
  });
  window.onKeyDown.listen((KeyboardEvent e) {
    if (e.keyCode == 37) { // left
      pushMove(turnClockwise);
    } else if (e.keyCode == 39) { // right
      pushMove(turnCounterClockwise);
    } else if (e.keyCode == 32) { // space
      pushMove(flip);
    }
  });
}
