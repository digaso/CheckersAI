import pygame
from .constants import BLACK, COLS, GREY, RED, ROWS, SQUARE_SIZE, WHITE
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
                else:
                    self.board[n_row].append(0)

                n_col += 1
            n_col = 0
            n_row += 1

    def draw(self, win):
        self.draw_squares(win)
        for row in range(ROWS):
            for col in range(COLS):
                if self.board[row][col] != 0:
                    self.board[row][col].draw(win)
