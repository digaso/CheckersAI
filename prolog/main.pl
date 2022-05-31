:-use_module(library(lists)).

board(game_board(A,B,C,E,F,G,H)):-
  functor(A, l, 8),
  functor(B, l, 8),
  functor(C, l, 8),
  functor(D, l, 8),
  functor(E, l, 8),
  functor(F, l, 8),
  functor(G, l, 8),
  functor(H, l, 8).

emptyBoard(game_board(
  l(0,1,0,1,0,1,0,1),
  l(1,0,1,0,1,0,1,0),
  l(0,1,0,1,0,1,0,1),
  l(1,0,1,0,1,0,1,0),
  l(0,1,0,1,0,1,0,1),
  l(1,0,1,0,1,0,1,0),
  l(0,1,0,1,0,1,0,1),
  l(1,0,1,0,1,0,1,0)
  )).

