import 'dart:html';
import 'sixstair_view/sixstair_view.dart';
import 'sixstair_animation/sixstair_animation.dart';

PuzzleView mainView;

void main() {
  AnimateRep rep = new AnimateRep();
  try {
    mainView = new PuzzleView(querySelector('#canvas'));
  } on UnsupportedError {
    window.alert('You must enable WebGL!');
    return;
  }
  mainView.puzzleRep = rep;
  mainView.draw();
  
  querySelector('#flip-button').onClick.listen((_) {
    rep.future.then((_) {
      rep.animateFlip(mainView.draw);
    });
  });
  querySelector('#clock-button').onClick.listen((_) {
    rep.future.then((_) {
      rep.animateTurn(true, mainView.draw);
    });
  });
  querySelector('#counter-button').onClick.listen((_) {
    rep.future.then((_) {
      rep.animateTurn(false, mainView.draw);
    });
  });
  window.onKeyDown.listen((KeyboardEvent e) {
    if (e.keyCode == 37) { // left
      rep.future.then((_) {
        rep.animateTurn(true, mainView.draw);
      });
    } else if (e.keyCode == 39) { // right
      rep.future.then((_) {
        rep.animateTurn(false, mainView.draw);
      });
    } else if (e.keyCode == 32) { // space
      rep.future.then((_) {
        rep.animateFlip(mainView.draw);
      });
    }
  });
}
