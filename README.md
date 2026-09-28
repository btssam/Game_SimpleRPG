# Simple RPG

A retro turn-based JRPG prototype built in **Godot 3.5 LTS**. Created to evaluate and test core JRPG engine architecture, overworld party movement, dynamic menus, and speed-ordered turn-based combat.

**Play in Browser:** [Simple RPG on itch.io](https://btssam.itch.io/simple-rpg)

---

## Engine Requirements

> [!WARNING]
> **Use Godot 3.5.x LTS.**
> This project was developed in Godot 3.x (`config_version=4`). Opening this in Godot 4.x will trigger automatic project conversion that will break GDScript syntax (such as `yield`, `scancode`, and export typing).

### How to Run Locally
1. Download and install **Godot 3.5 (Standard Edition)** from [godotengine.org](https://godotengine.org/download/3.x/).
2. Clone this repository:
   ```bash
   git clone https://github.com/btssam/Game_FinalFantasyClone.git
   ```
3. Open Godot, click **Import**, select `project.godot` inside the cloned folder, and click **Import & Edit**.
4. Press **F5** (or the Play button) to run the game.

---

## Features Implemented

- **Overworld Systems:**
  - Tilemap-based town and open field levels.
  - Trailing party movement (followers step-queue behind the player character).
  - NPC interactions with dialogue text boxes.
  - Step-based random encounter calculation.
  - Equipment and inventory systems with live stat updates.
- **Turn-Based Combat System:**
  - Speed-ordered action queue determining combat turn order.
  - Persistent party status and death tracking across encounters.
  - Commands: Attack, Skills (MP-cost), Items (consumables), and Flee.
  - Dynamic battle UI and targeting.

---

## Controls

| Action | Key / Input |
| :--- | :--- |
| **Movement / Menu Navigation** | Arrow Keys / WASD |
| **Interact / Select** | Space / Enter |
| **Menu (Overworld) / Cancel (Battle)** | Escape |
| **Debug Instant Battle / Flee** | `~` (Tilde) |
| **Mute Music** | Ctrl + M |

---

## Credits & Attribution

- **Game Design & Programming:** Ben Samara
- **Actors, Monsters, UI & Icons:** *Aeon Warriors* by [JosephSeraph](https://opengameart.org/users/josephseraph) (CC0)
- **Audio & Music:** *JRPG Music Pack* by [Juhani Junkala (SubspaceAudio)](https://opengameart.org/users/subspaceaudio) (CC0)
- **Battle Backgrounds:** [Nidhoggn](https://opengameart.org/content/backgrounds-3) (CC0)

---

## License

The code and engine architecture of this project are licensed under the [MIT License](LICENSE). Third-party art and sound assets remain in the Public Domain under CC0.
