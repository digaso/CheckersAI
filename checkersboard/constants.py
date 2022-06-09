import pygame


WIDTH, HEIGHT = 800, 800
ROWS, COLS = 8, 8
SQUARE_SIZE = WIDTH//COLS

# rgb
RED = (255, 0, 0)
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
BLUE = (0, 0, 255)
GREY = (100, 100, 100)
GREEN = (0, 255, 0)

crown = pygame.transform.scale(pygame.image.load(
    "assets/crown.png"), (SQUARE_SIZE, SQUARE_SIZE))
