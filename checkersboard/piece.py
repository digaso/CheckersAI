import pygame
from .constants import GREEN, RED, SQUARE_SIZE, GREY, crown


class Piece:

    PADDING = 10
    OUTLINE = 2

    def __init__(self, row, col, color):
        self.row = row
        self.col = col
        self.color = color
        self.king = False
        self.optional = False
        self.piece_from = 0
        if self.color == RED:
            self.direction = -1
        else:
            self.direction = 1

        self.x = 0
        self.y = 0
        self.calc_pos()

    def toggle_optional(self):
        self.optional = not self.optional

    def calc_pos(self):
        self.x = SQUARE_SIZE*self.col + SQUARE_SIZE//2
        self.y = SQUARE_SIZE*self.row + SQUARE_SIZE//2

    def make_king(self):
        self.king = True

    def draw(self, win):
        radius = SQUARE_SIZE//2 - self.PADDING
        pygame.draw.circle(win, GREY, (self.x, self.y), radius + self.OUTLINE)
        if self.optional:
            pygame.draw.circle(win, GREEN, (self.x, self.y), radius)
        pygame.draw.circle(win, self.color, (self.x, self.y), radius)
        if self.king:
            win.blit(crown, (self.x - crown.get_width() //
                     2, self.y - crown.get_height()//2))

    def move(self, row, col):
        self.row = row
        self.col = col
        self.calc_pos()

    def __repr__(self):
        return str(self.color)

    def equals(self, piece):
        if piece == 0:
            return False
        return self.color == piece.color and self.king == piece.king and self.optional == piece.optional and self.row == piece.row and self.col == piece.col

    def isOptional(self):
        return self.optional
