:-use_module(library(lists)).

queen(wq).
queen(bq).

next_player(white,black).
next_player(black,white).

player(white, w).
player(white,wq).
player(black, b).
player(black,bq).

maximizing(white).
minimizing(black).

board(game_board(A,B,C,D,E,F,G,H)):-
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
board_initialize_empty(game_board(A,B,C,D,E,F,G,H)):-
	board(game_board(A,B,C,D,E,F,G,H)),
	board_initialize_empty_odd(A),
	board_initialize_empty_even(B),
	board_initialize_empty_odd(C),
	board_initialize_empty_even(D),
	board_initialize_empty_odd(E),
	board_initialize_empty_even(F),
	board_initialize_empty_odd(G),
	board_initialize_empty_even(H).

board_initialize_game(game_board(A,B,C,D,E,F,G,H)):-
	board(game_board(A,B,C,D,E,F,G,H)),
	board_initialize_game_odd(A,b),
	board_initialize_game_even(B,b),
	board_initialize_game_odd(C,b),
	board_initialize_empty_even(D),
	board_initialize_empty_odd(E),
	board_initialize_game_even(F,w),
	board_initialize_game_odd(G,w),
	board_initialize_game_even(H,w).

board_initialize_empty_odd(A):-
	arg(1,A,0), arg(2,A,1),
	arg(3,A,0), arg(4,A,1),
	arg(5,A,0), arg(6,A,1),
	arg(7,A,0), arg(8,A,1).

board_initialize_empty_even(A):-
	arg(1,A,1), arg(2,A,0),
	arg(3,A,1), arg(4,A,0),
	arg(5,A,1), arg(6,A,0),
	arg(7,A,1), arg(8,A,0).

board_initialize_game_odd(Line,Player):-
	arg(1,Line,0), arg(2,Line,Player),
	arg(3,Line,0), arg(4,Line,Player),
	arg(5,Line,0), arg(6,Line,Player),
	arg(7,Line,0), arg(8,Line,Player).

board_initialize_game_even(Line,Player):-
	arg(1,Line,Player), arg(2,Line,0),
	arg(3,Line,Player), arg(4,Line,0),
	arg(5,Line,Player), arg(6,Line,0),
	arg(7,Line,Player), arg(8,Line,0).

board_print_line(Line):-
	board_print_line_element(Line,1),
	board_print_line_element(Line,2),
	board_print_line_element(Line,3),
	board_print_line_element(Line,4),
	board_print_line_element(Line,5),
	board_print_line_element(Line,6),
	board_print_line_element(Line,7),
	board_print_line_element(Line,8),
	nl.

board_print_line_element(Line, Index):-
  arg(Index, Line, Element),
  write(Element),
	tab(2).

board_print(game_board(A,B,C,D,E,F,G,H)):-
	tab(3), print(1), tab(2),print(2), tab(2),
	print(3), tab(2),print(4), tab(2),
	print(5), tab(2),print(6), tab(2),
	print(7), tab(2),print(8), tab(2), nl,
	print(1), tab(2),
	board_print_line(A),
	print(2), tab(2),
	board_print_line(B),
	print(3), tab(2),
	board_print_line(C),
	print(4), tab(2),
	board_print_line(D),
	print(5), tab(2),
	board_print_line(E),
	print(6), tab(2),
	board_print_line(F),
	print(7), tab(2),
	board_print_line(G),
	print(8), tab(2),
	board_print_line(H).

main:-
	abolish(current/2),
  board_initialize_game(Board),
	assert(current(white,Board)),
	write('Prolog checkers'), nl,
	play.
play:-
	current(Player,Board),
	board_print(Board).