import pygame
from checkersboard.constants import WIDTH, HEIGHT
from checkersboard.board import Board
import pyswip as prolog

FPS = 60
SCREEN = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption('Checkers')


def main():

    board = Board()
    run = True
    clock = pygame.time.Clock()

    while run:
        clock.tick(FPS)
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                run = False
            if event.type == pygame.MOUSEBUTTONDOWN:
                pass
        board.draw(SCREEN)
        pygame.display.update()
    pygame.quit()


main()
