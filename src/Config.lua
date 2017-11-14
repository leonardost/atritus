CONFIG = {}

CONFIG.VERSION = "v0.1.0"
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
CONFIG.linesClearedToPassLevels = { 10, 20, 30, 40, 50 }
CONFIG.velocityOfLevels = { 1, 0.5, 0.3, 0.1, 0.07 }
