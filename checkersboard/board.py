import pygame
from .constants import BLACK, BLUE, COLS, GREY, RED, ROWS, SQUARE_SIZE, WHITE
from .piece import Piece


class Board:
    def __init__(self, checkersboard):
        self.board = []
        self.checkersboard = checkersboard
        self.selected_piece = None
        self.red_left = self.white_left = 12
        self.create_board()

    def draw_squares(self, win):
        win.fill(BLACK)
        for row in range(ROWS):
            for col in range(row % 2, ROWS, 2):
                pygame.draw.rect(win, GREY, (row*SQUARE_SIZE,
                                 col*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE))

    def get_piece(self, row, col):
        return self.board[row][col]

    def move(self, piece, row, col):
        self.board[piece.row][piece.col], self.board[row][col] = self.board[row][col], self.board[piece.row][piece.col]
        piece.move(row, col)

        if row == ROWS or row == 0:
            piece.make_king()
            if piece.color == WHITE:
                self.white_kings += 1
            else:
                self.red_kings += 1

    def show_moves(self, moves, piece: Piece):
        for move in moves:
            ghostpiece = Piece(move['col'], move['row'], BLUE)
            ghostpiece.optional = True
            ghostpiece.piece_from = piece
            self.board[move['col']][move['row']] = ghostpiece

    def dont_show_moves(self):
        for row in range(ROWS):
            for col in range(COLS):
                if self.board[row][col] != 0 and self.board[row][col].optional:
                    self.board[row][col] = 0

    def create_board(self):
        n_row = 0
        n_col = 0
        for row in self.checkersboard:
            self.board.append([])
            for col in row:
                if col == 'w':
                    self.board[n_row].append(Piece(n_row, n_col, WHITE))
                elif col == 'b':
                    self.board[n_row].append(Piece(n_row, n_col, RED))
                elif col == 'wq':
                    self.board[n_row].append(Piece(n_row, n_col, WHITE))
                    self.board[n_row][n_col].make_king()
                elif col == 'bq':
                    self.board[n_row].append(Piece(n_row, n_col, RED))
                    self.board[n_row][n_col].make_king()
                else:
                    self.board[n_row].append(0)

                n_col += 1
            n_col = 0
            n_row += 1

    def draw(self, win):
        self.draw_squares(win)
        for row in range(ROWS):
            for col in range(COLS):
                if self.board[row][col] == 1:
                    self.board[row][col].draw(win)
                if self.board[row][col] != 0:
                    self.board[row][col].draw(win)
