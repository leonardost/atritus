local pieces = {}

-- I
pieces[1] = {
    color = CONFIG.COLORS[1],
    blocks = {
        { 1, 1, 1, 1,
          0, 0, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 0, 1, 0, 0,
          0, 1, 0, 0,
          0, 1, 0, 0,
          0, 1, 0, 0 },
        { 1, 1, 1, 1,
          0, 0, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 0, 1, 0, 0,
          0, 1, 0, 0,
          0, 1, 0, 0,
          0, 1, 0, 0 }
    }
}
-- Z
pieces[2] = {
    color = CONFIG.COLORS[2],
    blocks = {
        { 1, 1, 0, 0,
          0, 1, 1, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 0, 1, 0, 0,
          1, 1, 0, 0,
          1, 0, 0, 0,
          0, 0, 0, 0 },
        { 1, 1, 0, 0,
          0, 1, 1, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 0, 1, 0, 0,
          1, 1, 0, 0,
          1, 0, 0, 0,
          0, 0, 0, 0 }
    }
}
-- S
pieces[3] = {
    color = CONFIG.COLORS[3],
    blocks = {
        { 0, 1, 1, 0,
          1, 1, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 1, 0, 0, 0,
          1, 1, 0, 0,
          0, 1, 0, 0,
          0, 0, 0, 0 },
        { 0, 1, 1, 0,
          1, 1, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 1, 0, 0, 0,
          1, 1, 0, 0,
          0, 1, 0, 0,
          0, 0, 0, 0 }
    }
}
-- L invertido
pieces[4] = {
    color = CONFIG.COLORS[4],
    blocks = {
        { 1, 0, 0, 0,
          1, 1, 1, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 1, 1, 0, 0,
          1, 0, 0, 0,
          1, 0, 0, 0,
          0, 0, 0, 0 },
        { 1, 1, 1, 0,
          0, 0, 1, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 0, 1, 0, 0,
          0, 1, 0, 0,
          1, 1, 0, 0,
          0, 0, 0, 0 }
    }
}
-- L
pieces[5] = {
    color = CONFIG.COLORS[5],
    blocks = {
        { 0, 0, 1, 0,
          1, 1, 1, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 1, 0, 0, 0,
          1, 0, 0, 0,
          1, 1, 0, 0,
          0, 0, 0, 0 },
        { 1, 1, 1, 0,
          1, 0, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 1, 1, 0, 0,
          0, 1, 0, 0,
          0, 1, 0, 0,
          0, 0, 0, 0 }
    }
}
-- T
pieces[6] = {
    color = CONFIG.COLORS[6],
    blocks = {
        { 0, 1, 0, 0,
          1, 1, 1, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 0, 1, 0, 0,
          0, 1, 1, 0,
          0, 1, 0, 0,
          0, 0, 0, 0 },
        { 0, 0, 0, 0,
          1, 1, 1, 0,
          0, 1, 0, 0,
          0, 0, 0, 0 },
        { 0, 1, 0, 0,
          1, 1, 0, 0,
          0, 1, 0, 0,
          0, 0, 0, 0 }
    }
}
-- O
pieces[7] = {
    color = CONFIG.COLORS[7],
    blocks = {
        { 1, 1, 0, 0,
          1, 1, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 1, 1, 0, 0,
          1, 1, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 1, 1, 0, 0,
          1, 1, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 },
        { 1, 1, 0, 0,
          1, 1, 0, 0,
          0, 0, 0, 0,
          0, 0, 0, 0 }
    }
}

return pieces
