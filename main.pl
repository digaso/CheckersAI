:-use_module(library(lists)).

board(game_board(A,B,C,D,E,F,G,H)):-
	functor(A,l,8), 
	functor(B,l,8),
	functor(C,l,8),
	functor(D,l,8), 
	functor(E,l,8), 
	functor(F,l,8), 
	functor(G,l,8), 
	functor(H,l,8).

emptyBoard(
	    game_board(
		       l(0, 1, 0, 1, 0, 1, 0, 1),
		       l(1, 0, 1, 0, 1, 0, 1, 0),
		       l(0, 1, 0, 1, 0, 1, 0, 1),
		       l(1, 0, 1, 0, 1, 0, 1, 0),
		       l(0, 1, 0, 1, 0, 1, 0, 1),
		       l(1, 0, 1, 0, 1, 0, 1, 0),
		       l(0, 1, 0, 1, 0, 1, 0, 1),
		       l(1, 0, 1, 0, 1, 0, 1, 0)
		      )).

initializeEmpty(game_board(A,B,C,D,E,F,G,H)):-
	board(game_board(A,B,C,D,E,F,G,H)),
	initializeEmpty_odd(A),
	initializeEmpty_even(B),
	initializeEmpty_odd(C),
	initializeEmpty_even(D),
	initializeEmpty_odd(E),
	initializeEmpty_even(F),
	initializeEmpty_odd(G),
	initializeEmpty_even(H).

initializeGame(game_board(A,B,C,D,E,F,G,H)):-
	board(game_board(A,B,C,D,E,F,G,H)),
	initializeGame_odd(A,w),
	initializeGame_even(B,w),
	initializeGame_odd(C,w),
	initializeEmpty_even(D),
	initializeEmpty_odd(E),
	initializeGame_even(F,b),
	initializeGame_odd(G,b),
	initializeGame_even(H,b).

initializeEmpty_odd(A):-
	arg(1,A,0), arg(2,A,1),
	arg(3,A,0), arg(4,A,1),
	arg(5,A,0), arg(6,A,1),
	arg(7,A,0), arg(8,A,1).

initializeEmpty_even(A):-
	arg(1,A,1), arg(2,A,0),
	arg(3,A,1), arg(4,A,0),
	arg(5,A,1), arg(6,A,0),
	arg(7,A,1), arg(8,A,0).

initializeGame_odd(Line,Player):-
	arg(1,Line,0), arg(2,Line,Player),
	arg(3,Line,0), arg(4,Line,Player),
	arg(5,Line,0), arg(6,Line,Player),
	arg(7,Line,0), arg(8,Line,Player).

initializeGame_even(Line,Player):-
	arg(1,Line,Player), arg(2,Line,0),
	arg(3,Line,Player), arg(4,Line,0),
	arg(5,Line,Player), arg(6,Line,0),
	arg(7,Line,Player), arg(8,Line,0).


boardPrint(game_board(A,B,C,D,E,F,G,H)):-
	tab(3),print(1), tab(2),print(2), tab(2),
	print(3), tab(2),print(4), tab(2),
	print(5), tab(2),print(6), tab(2),
	print(7), tab(2),print(8), tab(2), nl,
	print(1), tab(2),
	boardPrintLine(A),
	print(2), tab(2),
	boardPrintLine(B),
	print(3), tab(2),
	boardPrintLine(C),
	print(4), tab(2),
	boardPrintLine(D),
	print(5), tab(2),
	boardPrintLine(E),
	print(6), tab(2),
	boardPrintLine(F),
	print(7), tab(2),
	boardPrintLine(G),
	print(8), tab(2),
	boardPrintLine(H).

boardPrintLine(Line):-
	boardPrintElement(Line,1),
	boardPrintElement(Line,2),
	boardPrintElement(Line,3),
	boardPrintElement(Line,4),
	boardPrintElement(Line,5),
	boardPrintElement(Line,6),
	boardPrintElement(Line,7),
	boardPrintElement(Line,8),
	nl.

boardPrintElement(Line,Index):-
  arg(Index, Line, Element),
  write(Element),
	tab(2).

pos(Board, X, Y, E):-
	arg(Y,Board,T),
	arg(X,T,E).
 
replace(Board, X, Y, Element, New_Board):-
	functor(New_Board,game_board,8),
	replaceBoard(Board,X,Y,Element,New_Board,1).

replaceBoard(_,_,_,_,_,Iterator):- Iterator > 8, !.
replaceBoard(Board, X, Y, Element, New_Board, Iterator):-
	Iterator == Y, !,
	arg(Y,Board,Line),
	functor(New_Line,l,8),
	replaceLine(Line, X, Element, New_Line, 1),
	arg(Iterator,New_Board,New_Line),
	Iterator_Next is Iterator + 1,
	replaceBoard(Board, X, Y, Element, New_Board, Iterator_Next).
replaceBoard(Board, X, Y, Element, New_Board, Iterator):-
	arg(Iterator,Board,Line),
	arg(Iterator,New_Board,Line),
	Iterator_Next is Iterator + 1,
	replaceBoard(Board, X, Y, Element, New_Board, Iterator_Next).

replaceLine(_,_,_,_, Iterator):- Iterator > 8, !.
replaceLine(Line, X, Element, New_Line, Iterator):-
	Iterator == X, !,
	arg(X,New_Line,Element),
	Iterator_Next is Iterator + 1,
	replaceLine(Line, X, Element, New_Line, Iterator_Next).
replaceLine(Line, X, Element, New_Line, Iterator):-
	arg(Iterator,Line,Old),
	arg(Iterator,New_Line,Old),
	Iterator_Next is Iterator + 1,
	replaceLine(Line, X, Element, New_Line, Iterator_Next).

removeBoard(Board,X,Y,New_Board):-
	emptyBoard(Empty_Board),
	pos(Empty_Board,X,Y,Place),
	replace(Board,X,Y,Place,New_Board).

move(Board,Xi,Yi,Xf,Yf,New_Board):-
	pos(Board,Xi,Yi,Piece),
	removeBoard(Board,Xi,Yi,Temp_Board),
	promote(Yf,Piece,Piece2),
	replace(Temp_Board,Xf,Yf,Piece2,New_Board).
promote(8,w,wq):- !.
promote(1,b,bq):- !.
promote(_,Piece,Piece).

occupied(Board,X,Y):-
	pos(Board,X,Y,Element),
	\+number(Element).

enemy(Board,X,Y,Player):-
	pos(Board,X,Y,Piece),
	nextPlayer(Player,N),
	playerPiece(N,Piece), !.

nextEatMove(Board,w,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X > 2, Y > 2,
	X1 is X - 1, Y1 is Y - 1,
	enemy(Board,X1,Y1,white),
	X2 is X - 2, Y2 is Y - 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextEatMove(Board,b,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X < 7, Y > 2,
	X1 is X + 1, Y1 is Y - 1,
	enemy(Board,X1,Y1,black),
	X2 is X + 2, Y2 is Y - 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextEatMove(Board,w,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X > 2, Y < 7,
	X1 is X - 1, Y1 is Y + 1,
	enemy(Board,X1,Y1,white),
	X2 is X - 2, Y2 is Y + 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextEatMove(Board,w,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X < 7, Y < 7,
	X1 is X + 1, Y1 is Y + 1,
	enemy(Board,X1,Y1,white),
	X2 is X + 2, Y2 is Y + 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextEatMove(Board,bq,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X > 2, Y > 2,
	X1 is X - 1, Y1 is Y - 1,
	enemy(Board,X1,Y1,black),
	X2 is X - 2, Y2 is Y - 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextEatMove(Board,bq,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X < 7, Y > 2,
	X1 is X + 1, Y1 is Y - 1,
	enemy(Board,X1,Y1,black),
	X2 is X + 2, Y2 is Y - 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextEatMove(Board,bq,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X > 2, Y < 7,
	X1 is X - 1, Y1 is Y + 1,
	enemy(Board,X1,Y1,black),
	X2 is X - 2, Y2 is Y + 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextEatMove(Board,bq,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X < 7, Y < 7,
	X1 is X + 1, Y1 is Y + 1,
	enemy(Board,X1,Y1,black),
	X2 is X + 2, Y2 is Y + 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextEatMove(Board,wq,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X > 2, Y < 7,
	X1 is X - 1, Y1 is Y + 1,
	enemy(Board,X1,Y1,white),
	X2 is X - 2, Y2 is Y + 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextEatMove(Board,wq,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X < 7, Y < 7,
	X1 is X + 1, Y1 is Y + 1,
	enemy(Board,X1,Y1,white),
	X2 is X + 2, Y2 is Y + 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextEatMove(Board,wq,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X > 2, Y > 2,
	X1 is X - 1, Y1 is Y - 1,
	enemy(Board,X1,Y1,white),
	X2 is X - 2, Y2 is Y - 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextEatMove(Board,wq,X,Y,e(X,Y,X2,Y2,New_Board)):-
	X < 7, Y > 2,
	X1 is X + 1, Y1 is Y - 1,
	enemy(Board,X1,Y1,white),
	X2 is X + 2, Y2 is Y - 2,
	\+occupied(Board,X2,Y2),
	move(Board,X,Y,X2,Y2,Temp_Board),
	removeBoard(Temp_Board,X1,Y1,New_Board).

nextMove(Board,b,X,Y,m(X,Y,X1,Y1,New_Board)):-
	X > 1, Y > 1,
	X1 is X - 1, Y1 is Y - 1,
	\+occupied(Board,X1,Y1),
	move(Board,X,Y,X1,Y1,New_Board).

nextMove(Board,b,X,Y,m(X,Y,X1,Y1,New_Board)):-
	X < 8, Y > 1,
	X1 is X + 1, Y1 is Y - 1,
	\+occupied(Board,X1,Y1),
	move(Board,X,Y,X1,Y1,New_Board).

nextMove(Board,w,X,Y,m(X,Y,X1,Y1,New_Board)):-
	X > 1, Y < 8, 
	X1 is X - 1, Y1 is Y + 1,
	\+occupied(Board,X1,Y1),
	move(Board,X,Y,X1,Y1,New_Board).

nextMove(Board,w,X,Y,m(X,Y,X1,Y1,New_Board)):-
	X < 8, Y < 8,
	X1 is X + 1, Y1 is Y + 1,
	\+occupied(Board,X1,Y1),
	move(Board,X,Y,X1,Y1,New_Board).

nextMove(Board,Piece,X,Y,m(X,Y,X1,Y1,New_Board)):-
	queen(Piece),
	X > 1, Y > 1,
	X1 is X - 1, Y1 is Y - 1,
	\+occupied(Board,X1,Y1),
	move(Board,X,Y,X1,Y1,New_Board).

nextMove(Board,Piece,X,Y,m(X,Y,X1,Y1,New_Board)):-
	queen(Piece),
	X < 8, Y > 1,
	X1 is X + 1, Y1 is Y - 1,
	\+occupied(Board,X1,Y1),
	move(Board,X,Y,X1,Y1,New_Board).


nextMove(Board,Piece,X,Y,m(X,Y,X1,Y1,New_Board)):-
	queen(Piece),
	X > 1, Y < 8,
	X1 is X - 1, Y1 is Y + 1,
	\+occupied(Board,X1,Y1),
	move(Board,X,Y,X1,Y1,New_Board).

nextMove(Board,Piece,X,Y,m(X,Y,X1,Y1,New_Board)):-
	queen(Piece),
	X < 8, Y < 8,
	X1 is X + 1, Y1 is Y + 1,
	\+occupied(Board,X1,Y1),
	move(Board,X,Y,X1,Y1,New_Board).

queen(wq).
queen(bq).

listAvailableMoves(Board,Player,Moves):-
	listAllPositions(Board,Player,Positions),
	listAvailableMovesAux(Board,Positions,Moves), 
	Moves \= [].

listAvailableMovesAux(Board,Positions,Moves):-
	listAllEatMoves(Board,Positions,Moves),
	Moves \= [], !.
listAvailableMovesAux(Board,Positions,Moves):-
	listAllMoves(Board,Positions,Moves).

listAllEatMoves(_,[],[]):- !.
listAllEatMoves(Board,[p(E,X,Y)|Positions],Moves):-
	bagof(M,chainEat(Board,p(E,X,Y),M),Move), !,
	listAllEatMoves(Board,Positions,Move2),
	append(Move,Move2,Move3), 
	removeEmpty(Move3,Moves).
listAllEatMoves(Board,[_|Positions],Moves):-
	listAllEatMoves(Board,Positions,Moves).

listAllMoves(_,[],[]):- !.
listAllMoves(Board,[p(E,X,Y)|Positions],Moves):-
	bagof(M,nextMove(Board,E,X,Y,M),Move), !,
	listAllMoves(Board,Positions,Move2),
	append(Move,Move2,Moves). 
listAllMoves(Board,[_|Positions],Moves):-
	listAllMoves(Board,Positions,Moves).

listAllPositions(Board,Player,Positions):-
	bagof(Pos, listAllPositions_aux(Board,Player,Pos), Positions).

listAllPositions_aux(Board,Player,p(E,X,Y)):-
	member(X,[1,2,3,4,5,6,7,8]),
	member(Y,[1,2,3,4,5,6,7,8]),
	pos(Board,X,Y,E),
	playerPiece(Player,E).


chainEat(Board,p(E,X,Y),[e(X,Y,X1,Y1,Board2)|Moves]):-
	nextEatMove(Board,E,X,Y,e(X,Y,X1,Y1,Board2)),
	pos(Board2,X1,Y1,E1),
	chainEat(Board2,p(E1,X1,Y1),Moves).
chainEat(Board,p(E,X,Y),[]):-
	\+nextEatMove(Board,E,X,Y,_).


removeEmpty([],[]):- !.
removeEmpty([[]|L],L1):- !, removeEmpty(L,L1).
removeEmpty([X|L],[X|L1]):- removeEmpty(L,L1).

nextPlayer(white,black).
nextPlayer(black,white).

playerPiece(white,w).
playerPiece(white,wq).
playerPiece(black,b).
playerPiece(black,bq).

boardWeight(w,_,1,5).
boardWeight(w,_,2,3).
boardWeight(w,_,3,2).
boardWeight(w,_,6,2).
boardWeight(w,_,7,3).
boardWeight(w,_,8,5).
boardWeight(w,_,_,1).
boardWeight(b,_,1,5).
boardWeight(b,_,2,3).
boardWeight(b,_,3,2).
boardWeight(b,_,6,2).
boardWeight(b,_,7,3).
boardWeight(b,_,8,5).
boardWeight(b,_,_,1).
boardWeight(_,_,_,1).

boardEvaluation(Board, 200, _):-
    \+listAvailableMoves(Board,black,_),
    listAvailableMoves(Board,white,_), !.
boardEvaluation(Board, -200, _):-
    \+listAvailableMoves(Board,white,_),
    listAvailableMoves(Board,black,_), !.

boardEvaluation(_, 0, Iterator) :-  Iterator > 8, !.
boardEvaluation(Board, Eval, Iterator) :- 
    arg(Iterator, Board, Line), !,
    lineEvaluation(Line, LineEval, Iterator, 1),
    IteratorNext is Iterator + 1,
    boardEvaluation(Board, RemainingEval, IteratorNext),
    Eval is LineEval + RemainingEval.
    
lineEvaluation(_, 0, _, Column) :- Column > 8, !.
lineEvaluation(Line, Eval, Row, Column) :-
	arg(Column, Line, Piece), !,
	pieceValue(Piece, PieceValue),
	boardWeight(Piece,Column,Row,W),
	IteratorNext is Column + 1,
	lineEvaluation(Line, RemainingEval, Row, IteratorNext),
	Eval is RemainingEval + PieceValue * W.

minimax(Player, Board, NextMove, Eval, Depth) :-
	Depth < 5,
	NewDepth is Depth + 1,
	nextPlayer(Player, OtherPlayer),
	listAvailableMoves(Board, OtherPlayer, Moves),
	best(OtherPlayer, Moves, NextMove, Eval, NewDepth), !.

minimax(_, Board, _, Eval, _) :-
	boardEvaluation(Board, Eval, 1), !.

best(Player, [Move], Move, Eval, Depth) :-
	boardMove(Move, Board),
	minimax(Player, Board, _, Eval, Depth), !.

best(Player, [Move|Moves], BestMove, BestEval, Depth) :-
	dechain(Move, Move1),
	boardMove(Move1, Board),
	minimax(Player, Board, _, Eval, Depth),
	best(Player, Moves, BestMove1, BestEval1, Depth),
	better(Player, Move1, Eval, BestMove1, BestEval1, BestMove, BestEval).

dechain([Move],Move).
dechain([_|Moves],Last) :- last(Moves, Last).
dechain(Move, Move).

maximizing(white).
minimizing(black).

boardMove(m(_,_,_,_, Board), Board).
boardMove(e(_,_,_,_, Board), Board).
better(Player, Move1, Eval1, _, Eval2, Move1, Eval1) :-
	maximizing(Player),
	Eval1 >= Eval2, !.
better(Player, _, Eval1, Move2, Eval2, Move2, Eval2) :-
	maximizing(Player),
	Eval2 >= Eval1, !.

better(Player, Move1, Eval1, _, Eval2, Move1, Eval1) :-
	minimizing(Player),
	Eval1 =< Eval2, !.
better(Player, _, Eval1, Move2, Eval2, Move2, Eval2) :-
	minimizing(Player),
	Eval2 =< Eval1, !.

pieceValue(1, 0).
pieceValue(0, 0).
pieceValue(w, 1).
pieceValue(b, -1).
pieceValue(wq, 5).
pieceValue(bq, -5).

alphaBeta(Player, Alpha, Beta, Board, NextMove, Eval, Depth) :-
	Depth < 40,
	NewDepth is Depth + 1,
	listAvailableMoves(Board, Player, Moves),
	bestBounded(Player, Alpha, Beta, Moves, NextMove, Eval, NewDepth), !.

alphaBeta(_, _, _, Board, _, Eval, _) :-
	boardEvaluation(Board, Eval, 1), !.

bestBounded(Player, Alpha, Beta, [Move|Moves], BestMove, BestEval, Depth) :-
	dechain(Move, Move1),
	boardMove(Move1, Board),
	nextPlayer(Player, NextPlayer),
	alphaBeta(NextPlayer, Alpha, Beta, Board, _, Eval, Depth),
	goodEnough(Player, Moves, Alpha, Beta, Move1, Eval, BestMove, BestEval, Depth).

goodEnough(_, [], _, _, Move, Eval, Move, Eval, _) :- !.

goodEnough(Player, _, Alpha, _, Move, Eval, Move, Eval, _) :-
	minimizing(Player), Eval > Alpha, !.

goodEnough(Player, _, _, Beta, Move, Eval, Move, Eval, _) :-
	maximizing(Player), Eval < Beta, !.

goodEnough(Player, Moves, Alpha, Beta, Move, Eval, BestMove, BestEval, Depth) :-
	boundsNew(Player, Alpha, Beta, Eval, NewAlpha, NewBeta),
	bestBounded(Player, NewAlpha, NewBeta, Moves, Move1, Eval1, Depth),
	better(Player, Move, Eval, Move1, Eval1, BestMove, BestEval).

boundsNew(Player, Alpha, Beta, Eval, Eval, Beta) :-
	minimizing(Player), Eval > Alpha, !.


boundsNew(Player, Alpha, Beta, Eval, Alpha, Eval) :-
	maximizing(Player), Eval < Beta, !.

printAllMoves(_, []) :- !,  nl.

printAllMoves(Num, [m(X1,Y1,X2,Y2,_)|Moves]) :- !, 
	write(Num), write(': ('), write(X1), write(','), write(Y1),
	write(') -> ('),
	write(X2), write(','), write(Y2), write(')'), nl,
	NextNum is Num + 1,
	printAllMoves(NextNum, Moves).


printAllMoves(Num, [Chain|Moves]) :- !, 
	write(Num), write(': '),
	printChains(Chain),
	NextNum is Num + 1,
	printAllMoves(NextNum, Moves).

printChains([e(X1,Y1,X2,Y2,_)]) :- !, 
	write('('), write(X1), write(','), write(Y1),
	write(') -> ('),
	write(X2), write(','), write(Y2), write(')'), nl.

printChains([e(X1,Y1,X2,Y2,_)|Chain]) :- !, 
	write('('), write(X1), write(','), write(Y1),
	write(') -> ('),
	write(X2), write(','), write(Y2), write(') -> '),
	printChains(Chain).

printMove(m(X1, Y1, X2, Y2, _)) :- !, 
	write('('), write(X1), write(','), write(Y1),
	write(') -> ('),
	write(X2), write(','), write(Y2), write(')'), nl.
printMove(e(X1, Y1, X2, Y2, _)) :- !, 
	write('('), write(X1), write(','), write(Y1),
	write(') -> ('),
	write(X2), write(','), write(Y2), write(')'), nl.

main:-
	abolish(current/2),
	initializeGame(Board),
	assert(current(white, Board)),
	write('Prolog checkers'), nl,
	write('To play select one of the options available:\n3. for example (the dot in the end is important!)\n'),
	play.

play:-
    current(Player, Board),
    boardPrint(Board),
    makeMove(Player, Board).

makeMove(white, Board, NewBoard, Eval, NextMove):-
    alphaBeta(white, -1000, 1000, Board, NextMove, Eval, 0),    
    nonvar(NextMove), !,
    boardMove(NextMove, NewBoard),
	  abolish(current/2),                                      
    assert(current(black, NewBoard)).                 
	
makeMove(white, Board, _, _, _, _):-
    listAvailableMoves(Board, black, _), !,
    write('Black (human) wins the game.'),nl.
makeMove(white,_, _, _, _, _):-
    write('Draw.'),nl.
makeMove(black,Board, _, _, _, _) :-
    listAvailableMoves(Board, black, Moves), !,
    write('Black (human) turn to play.'), nl,
    printAllMoves(1, Moves),
    repeat, 
    read(Option),
    nth1(Option, Moves, Move), !, 
    dechain(Move,Move1),
    boardMove(Move1,NewBoard),
    abolish(current/2),
    assert(current(white,NewBoard)).
makeMove(black,Board, _, _, _, _ ) :-
    listAvailableMoves(Board, white, _), !,
    write('White (computer) wins the game.'),nl.
makeMove(black,_, _, _, _, _):-
    write('Draw.'), nl.

movePiece(black,Board, Move, NewBoard) :-
	dechain(Move,Move1),
  boardMove(Move1,NewBoard).