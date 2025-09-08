-- 🎮 Game Constants
-- Central configuration for Hex Flip game parameters

local constants = {}

-- 📐 Hexagon dimensions
constants.HEX_SIZE = 12  -- Radius of each hexagon in pixels
constants.HEX_WIDTH = constants.HEX_SIZE * 2  -- Width of hexagon
constants.HEX_HEIGHT = math.sqrt(3) * constants.HEX_SIZE  -- Height for flat-top hexagon

-- 🎯 Grid configuration
constants.GRID_RADIUS = 4  -- Number of hexagons from center to edge (4 for testing)
constants.GRID_CENTER_X = 200  -- Center of grid on screen
constants.GRID_CENTER_Y = 120  -- Center of grid on screen

-- 🖼️ Screen dimensions
constants.SCREEN_WIDTH = 400
constants.SCREEN_HEIGHT = 240

-- 🎮 Gameplay parameters
constants.CRANK_DEGREES_PER_ROTATION = 60  -- Degrees of crank needed for one 60° piece rotation
constants.ROTATION_STEPS = 6  -- Number of 60° rotations for full circle

-- 🎨 Visual settings
constants.HEX_LINE_WIDTH = 2  -- Line width for hexagon outlines
constants.PIECE_LINE_WIDTH = 3  -- Line width for piece hexagons
constants.GRID_COLOR = playdate.graphics.kColorBlack
constants.PIECE_COLOR = playdate.graphics.kColorBlack
constants.BACKGROUND_COLOR = playdate.graphics.kColorWhite

-- 🕹️ Input settings
constants.CURSOR_SPEED = 1  -- Hexagons to move per frame when holding D-pad
constants.CURSOR_ACCELERATION_FRAMES = 10  -- Frames before cursor speed increases
constants.CURSOR_FAST_SPEED = 2  -- Fast cursor speed after acceleration

-- 🎯 Game states
constants.GAME_STATE = {
    MENU = "menu",
    PLAYING = "playing",
    PAUSED = "paused",
    GAME_OVER = "gameover",
    VICTORY = "victory"
}

-- 📊 Scoring
constants.POINTS_PER_HEX_FLIPPED = 10
constants.COMBO_MULTIPLIER = 1.5  -- Score multiplier for chain reactions
constants.PERFECT_CLEAR_BONUS = 1000  -- Bonus for clearing entire board

-- ⏱️ Timing
constants.FLIP_ANIMATION_DURATION = 200  -- Milliseconds for hex flip animation
constants.PIECE_PLACE_ANIMATION_DURATION = 150  -- Milliseconds for piece placement
constants.VICTORY_ANIMATION_DURATION = 1000  -- Milliseconds for victory celebration

-- Set as global for Playdate SDK
_G.constants = constants