# Tic Tac Toe - MIPS Assembly Edition 🎮

A fully functional Tic Tac Toe game written in MIPS assembly language with bitmap graphics display, and hosted on MARS. Built as our final project for CS2640.

## About

This project demonstrates advanced MIPS assembly programming concepts including:
- Two-player game logic
- Bitmap display graphics
- Input validation and error handling
- Win condition detection
- Modular code organization with separate files

Players take turns placing X's and O's on a 3x3 grid, with moves displayed both in the console and visually on a bitmap display.

## Features

- **Two-Player Gameplay** - Play against a friend locally
- **Visual Display** - Bitmap graphics showing the game board with colored pieces
- **Input Validation** - Prevents invalid moves and handles errors gracefully
- **Win Detection** - Automatically detects wins (rows, columns, diagonals) and ties
- **Color-Coded Players** - Red X's for Player 1, Blue O's for Player 2

## Getting Started

### Prerequisites

- **MARS** (MIPS Assembler and Runtime Simulator) version 4.5 or newer
- Download from: http://courses.missouristate.edu/KenVollmar/MARS/

### Installation

1. Clone this repository or download the files
2. Make sure **both files are in the same directory**:
   - `TicTacToe_main.asm` - Main game file
   - `Bitmap.asm` - Bitmap display functions

## How to Run

### Step 1: Configure Bitmap Display

Before running the game, you need to set up the Bitmap Display:

1. Open MARS
2. Go to **Tools → Bitmap Display**
3. Configure with these **exact** settings:
   ```
   Unit Width in Pixels:     8
   Unit Height in Pixels:    8
   Display Width in Pixels:  512
   Display Height in Pixels: 512
   Base address for display: 0x10008000 (heap)
   ```
4. Click **"Connect to MIPS"** (important!)
5. Keep the Bitmap Display window open

### Step 2: Load and Run

1. In MARS, open `TicTacToe_main.asm`
2. Click **Assemble** (or press F3)
3. Click **Run** (or press F5)
4. Follow the on-screen prompts!

## How to Play

1. **Start the game** - Press `Y` when prompted (or `N` to exit)
2. **Player 1's turn** - Enter X-coordinate (1-3), then Y-coordinate (1-3)
3. **Player 2's turn** - Same as above
4. **Win or Tie** - Game automatically detects when someone wins or if it's a tie

### Coordinate System
```
     1   2   3
   +---+---+---+
1  |   |   |   |
   +---+---+---+
2  |   |   |   |
   +---+---+---+
3  |   |   |   |
   +---+---+---+
```

## Visual Display

- **Background**: White
- **Grid Lines**: Gray
- **Player 1 (X)**: Red diagonal lines
- **Player 2 (O)**: Blue rectangle outlines

## File Structure

```
.
├── TicTacToe_main.asm    # Main game logic
├── Bitmap.asm            # Bitmap display functions
└── README.md             # This file
```

**Important:** Both `.asm` files must be in the same directory for the `.include` directive to work!

## Troubleshooting

### "Address out of range" error
- Make sure Bitmap Display is configured **before** running the code
- Verify the base address is set to `0x10008000 (heap)`
- Click "Connect to MIPS" before running

### "File not found" error
- Ensure both `.asm` files are in the same directory
- Check that the filename in the `.include` statement matches exactly

### Graphics not appearing
- Bitmap Display window must be open and connected
- Don't minimize or close the Bitmap Display window while running

## Team

**CS2640.02 - Group 5**
- Logan Bailey - Bitmap display implementation
- Marco Joson - Win condition checking
- Russell Salvador - Game logic and structure
- Jay Wu - Input validation and error handling

## Project Details

- **Course**: CS2640 - Computer Organization
- **Date**: December 2025
- **Language**: MIPS Assembly
- **Simulator**: MARS 4.5

## License

This project was created for educational purposes as part of CS2640 coursework.

## Acknowledgments

Thanks to our CS2640 instructor and classmates for their support throughout this project!

---

*Enjoy the game! Feel free to fork and improve it!* 🚀
