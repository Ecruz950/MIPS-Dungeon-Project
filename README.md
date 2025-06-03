# MIPS Dungeon Game

A console-based adventure game written in MIPS Assembly for CS 350: Computer Organization and Assembly Language Programming.

![GameDemo](Assets/Video/GameDemo.gif)

## Game Objective

Navigate your hero through a treacherous dungeon map filled with demons, potions, obstacles, and teleporting portals. The goal? Reach the exit gate to win! Use your wits and WASD keys to move wisely and avoid traps.

## Game Features

- **2D Console Map:** Top-down 8x8 grid view rendered in the console.
- **Character Movement:** Use `W`, `A`, `S`, and `D` keys to move your hero.
- **Obstacles:** Collision detection prevents moving into walls or out of bounds.
- **Portals:** Step on a portal (`'0'..'9'`) and instantly warp to its matching pair.
- **Potions:** Collect potions (`'+'`) to gain points. Once collected, they're gone forever.
- **Demons:** Step on a demon (`'@'`) and lose all your points—then respawn at the starting position.
- **Exit Gate:** Reach the gate (`'*'`) to win and terminate the game.

## Implementation Details

- **Memory-Mapped Map:** The static map is hardcoded as 64 consecutive bytes starting at `0x10002000`.
- **Dynamic State Tracking:** A dynamic copy of the map is used to track gameplay changes like player position and potion collection.
- **Game Loop:** The main loop updates the screen, waits for input, applies changes, and checks for termination.
- **State Machine Approach:** All gameplay components (player location, score, potion states, game running flag) are stored and updated in memory.
- **Modular Design:** Separated concerns into functions like initialization, map rendering, movement, and state updates.

## Controls

- `W` - Move Up  
- `A` - Move Left  
- `S` - Move Down  
- `D` - Move Right  
- `T` - Terminate the game manually (for testing)

## Map Symbols

| Symbol | Meaning            |
|--------|---------------------|
| `S`    | Player Start        |
| `*`    | Exit Gate           |
| `#`    | Wall / Obstacle     |
| `+`    | Potion              |
| `@`    | Demon               |
| `0-9`  | Portal pairs        |
| `' '`  | Empty Space         |

## How to Run

1. Load the assembly file into a MIPS emulator like [MARS](http://courses.missouristate.edu/KenVollmar/MARS/) or [QtSpim](https://sourceforge.net/projects/spimsimulator/).
2. Assemble and run the program.
3. Interact via the console using the control keys.
4. Watch the map update as you explore, collect items, and avoid dangers.


