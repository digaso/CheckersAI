from pprint import pprint
from numpy import pi
import pygame
from checkersboard.constants import BLACK, BLUE, RED, SQUARE_SIZE, WHITE, WIDTH, HEIGHT
from checkersboard.board import Board
from pyswip import Prolog
from checkersboard.piece import Piece
from utils.button import Button

prolog = Prolog()
prolog.consult("main.pl")


def findPieceMove(moves, piece: Piece):
    pieceMoves = []
    pieces = []
    for move in moves:
        if move["from_col"] == piece.col+1 and move["from_row"] == piece.row+1:
            pieceMoves.append(move)
    for move in pieceMoves:
        new_piece = {"row": move["to_col"]-1, "col": move["to_row"]-1}
        pieces.append(new_piece)
    return pieces


def stringToArray(str):
    arr = str.replace("l(", "").replace(")", "").replace(
        " ", "").split(",")
    return arr


def getAvailableMoves(param_board: str):
    moves = []
    for soln in prolog.query("listAvailableMoves( {},black, Moves)".format(param_board)):
        for i in range(len(soln["Moves"])):
            moves.append(formatMove(soln["Moves"][i], param_board))
    moves_str = soln["Moves"]
    return moves, moves_str


def getBoard():
    checkersboard = []
    for item in prolog.query("initializeGame(X)"):
        param = item["X"]
    for soln in prolog.query("initializeGame(game_board(A,B,C,D,E,F,G,H))."):
        for item in soln:
            checkersboard.append(stringToArray(soln[item]))
    return checkersboard, param


def formatMove(string: str, helper: str):
    string = str(string)
    eat = False
    if(string[0] == 'm'):
        positions = string.replace(helper, "").replace(
            " ", "").replace('m(', "").replace(')', "").split(",")
    elif(string[0] == 'e'):
        positions = string.replace(helper, "").replace(
            " ", "").replace("e(", "").replace(',)', "").split(",")
    else:
        positions = string.replace(helper, "").replace(
            " ", "").replace('Functor(8774285,5', "").replace(',)', "").replace('[,', '').split(",")
    print(positions)
    print("<---------------------------------------------------------------------->")
    move = {
        "from_col": int(positions[0]),
        "from_row": int(positions[1]),
        "to_col": int(positions[2]),
        "to_row": int(positions[3])
    }
    return move


def makeMoveComputer(human_turn: bool, param_board: str, board: Board):
    eval = 0
    if human_turn:
        player = "black"
    else:
        player = "white"

    newBoard = []
    for soln in prolog.query("makeMove( {}, {}, game_board(A,B,C,D,E,F,G,H), _, _)".format(player, param_board)):
        for item in soln:
            newBoard.append(stringToArray(soln[item]))
    for item in prolog.query("makeMove( {}, {}, NewBoard, Eval, NextMove)".format(player, param_board)):
        newBoard_str = item['NewBoard']
        eval = item["Eval"]
        nextMove = item["NextMove"]

    move = formatMove(nextMove, helper=newBoard_str)
    return eval, newBoard, newBoard_str, move


def play():
    return True


def get_row_col_from_mouse_pos(mouse_pos):
    x, y = mouse_pos
    row = y // SQUARE_SIZE
    col = x // SQUARE_SIZE
    return row, col


def move_piece_player(piece: Piece, moves_str, piece_moves, helper, allMoves):
    i = 0
    param = ""
    newBoard = []
    for item in allMoves:
        if item["from_col"] == piece.piece_from.col+1 and item["from_row"] == piece.piece_from.row+1 and item["to_col"] == piece.col+1 and item["to_row"] == piece.row+1:
            break
        i += 1
    for item in prolog.query("movePiece(black, {}, {}, NewBoard)".format(helper, moves_str[i])):
        param = item["NewBoard"]
    for item in prolog.query("movePiece(black, {}, {}, game_board(A,B,C,D,E,F,G,H))".format(helper, moves_str[i])):
        for j in item:
            newBoard.append(stringToArray(item[j]))
    return newBoard, param


global playing
global run

FPS = 60
SCREEN = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption('Checkers')


def main():

    pygame.init()

    button1 = Button(
        "Play",
        (WIDTH//2, HEIGHT//2),
        font=50,
        bg="grey",
        command=play)
    checkersboard, param_board = getBoard()
    board = Board(checkersboard)
    clock = pygame.time.Clock()
    playing = False
    human_turn = False
    run = True
    selected = 0
    eval, newBoard, param_board, move = makeMoveComputer(
        human_turn, param_board, board)
    board = Board(newBoard)
    print("============= after computer play =============")
    human_turn = not human_turn
    while run:
        clock.tick(FPS)

        if playing:
            if human_turn:
                for event in pygame.event.get():
                    if event.type == pygame.QUIT:
                        run = False
                    if event.type == pygame.MOUSEBUTTONDOWN:
                        pos = pygame.mouse.get_pos()
                        row, col = get_row_col_from_mouse_pos(pos)
                        piece = board.get_piece(row, col)
                        if piece != 0 and piece.color == RED:
                            if not piece.equals(selected):
                                board.dont_show_moves()
                                selected = piece
                            moves, moves_str = getAvailableMoves(
                                param_board)
                            pieceMoves = findPieceMove(moves, piece)
                            board.show_moves(pieceMoves, piece)
                        elif piece != 0 and piece.color == BLUE:
                            newBoard, param_board = move_piece_player(
                                piece, moves_str, pieceMoves, param_board, moves)
                            board = Board(newBoard)
                            board.draw(SCREEN)
                            human_turn = not human_turn
                            selected = 0

                        else:
                            selected = 0
                            board.dont_show_moves()
            else:
                eval, newBoard, param_board, move = makeMoveComputer(
                    human_turn, param_board, board)
                board = Board(newBoard)
                print("============= after computer play =============")
                human_turn = not human_turn

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    run = False
            board.draw(SCREEN)
        else:
            if button1.update() == True:
                playing = True
            button1.show(SCREEN)
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    run = False

        pygame.display.update()
    pygame.quit()


main()
