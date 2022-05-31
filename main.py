import pygame
from  checkersboard.constants import WIDTH, HEIGHT

FPS = 60
SCREEN = pygame.display.set_mode((WIDTH,HEIGHT))
pygame.display.set_caption('Checkers')

def main():
    run = True
    clock = pygame.time.Clock()

    while run:
        clock.tick(FPS)
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                run = False
    pygame.quit()
main()
