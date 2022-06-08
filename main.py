import pygame
from checkersboard.constants import WIDTH, HEIGHT
from checkersboard.board import Board
from pyswip import Prolog

prolog = Prolog()
prolog.consult("main.pl")


def stringToArray(str):
    arr = str.replace("l(", "").replace(")", "").replace(" ", "").split(",")
    return arr


def getBoard():
    checkersboard = []
    for item in prolog.query("initializeGame(X)"):
        param = item["X"]
    for soln in prolog.query("initializeGame(game_board(A,B,C,D,E,F,G,H))."):
        for item in soln:
            checkersboard.append(stringToArray(soln[item]))
    return checkersboard, param


FPS = 60
SCREEN = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption('Checkers')


def main():

    checkersboard, param = getBoard()
    board = Board(checkersboard)

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
