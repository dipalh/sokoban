# Sokoban (RISC-V Assembly)

🚀 A multiplayer, fully interactive implementation of the classic Sokoban puzzle game — built entirely in RISC-V Assembly. Challenge up to 255 players on dynamically generated boards, track your moves, and replay your game from memory.

## 🎮 What is Sokoban?

Sokoban is a Japanese logic puzzle where the player pushes boxes onto target locations within a confined space. This project reimagines the game with:
- Randomized solvable boards
- Multiplayer support
- Live move tracking
- Built-in leaderboard
- Replay mode

## 🧠 Features

- 🔁 **Multiplayer Mode**: Compete with up to 255 players on the same board. Ranked by fewest moves.
- 🔄 **Board Replay System**: Rewatch any player’s round using stored moves.
- 🧠 **Guaranteed Solvable Maps**: Map generation ensures no unsolvable states at start.
- 📊 **Leaderboard**: Automatically ranks players based on move efficiency.
- 🧼 **Reset Support**: Return to initial state without restarting the program.
- 🎨 **ASCII Graphics**: Clean text-based UI for real-time gameplay feedback.

## 🕹️ Controls

### During Your Turn:
| Key | Action              |
|-----|---------------------|
| `w` | Move Up             |
| `a` | Move Left           |
| `s` | Move Down           |
| `d` | Move Right          |
| `r` | Reset Board         |

### After All Players Finish:
| Key | Action                                 |
|-----|----------------------------------------|
| `n` | Start a new game                       |
| `r` | Replay a player's game                 |
| `p` | Start with a different player count    |
| `e` | Exit game                              |

## 🧱 Legend

| Icon | Meaning       |
|------|---------------|
| `[P]`| Player         |
| `[O]`| Box            |
| `[X]`| Target         |
| `[#]`| Wall (edge)    |
| `[ ]`| Empty space    |

## 🧩 How to Play

1. Enter the number of players (1–255).
2. Set the grid size (rows and columns must be > 2).
3. Each player takes turns trying to push the box `[O]` onto the target `[X]`.
4. Fewer moves = higher score.
5. If a box is pushed into an unsolvable state (e.g., cornered), the board resets and play resumes.
6. After all rounds, view the leaderboard or replay any game.

## 🧪 Running the Game (CPUlator)

This project runs using [CPUlator](https://cpulator.01xz.net/?sys=rv32-spim), an online RISC-V simulator.

### Steps:
1. Go to [https://cpulator.01xz.net/?sys=rv32-spim](https://cpulator.01xz.net/?sys=rv32-spim)
2. Click **File → Open**, and load `a1.s`
3. Click **Compile and Load** (or press `F5`)
4. Click **Continue** (or press `F3`)
5. Follow the on-screen prompts to start playing

> 💡 For wide boards (>30 columns), use “Show in a separate box” to extend the terminal window.

## 🏁 Example Flow

- Player 1 completes a 6x6 board in 14 moves  
- Player 2 completes it in 11 moves  
- Player 3 resets 3 times and finishes in 21 moves  

📊 **Leaderboard Output:**

Leaderboard:  
Player 2: 11 moves  
Player 1: 14 moves  
Player 3: 21 moves  

## 📁 Files
- `a1.s` – Full RISC-V Assembly source code

## 🛠️ Tech Stack
- RISC-V Assembly  
- CPUlator (online RISC-V simulation environment)

## 🙌 Credits
Created as part of a systems programming course at the University of Toronto. All code, logic, and enhancements (multiplayer, replay, scoreboard) implemented independently by Dipal Hingorani.

---
