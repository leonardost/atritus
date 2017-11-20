CONFIG = {}

CONFIG.VERSION = "v1.3.0"
CONFIG.scale = 2
CONFIG.COLORS = {
    { 0, 0, 255 },
    { 255, 0, 0 },
    { 0, 255, 0 },
    { 255, 255, 0 },
    { 0, 255, 255 },
    { 255, 0, 255 },
    { 255, 255, 255 }
}

-- bottle size
CONFIG.BOTTLE_WIDTH = 10
CONFIG.BOTTLE_HEIGHT = 21

-- game configuration
CONFIG.tableOfPoints = { 10, 25, 75, 200 }
CONFIG.linesClearedToPassLevels = { 10, 20, 30, 40, 50, 60, 70, 80 }
CONFIG.velocityOfLevels = { 1, 0.8, 0.6, 0.3, 0.1, 0.08, 0.06, 0.05 }
CONFIG.showShadow = true

CONFIG.debug = false
CONFIG.nextPiece = 1
CONFIG.startingX = 4
CONFIG.startingY = 0
