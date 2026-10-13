# Lament of Laurence

A small 2D platformer built with Lua and the LÖVE framework.

This was my project for the first programming course of my college degree,
**Algorithm I (Algoritmos I)**. It is the first game I ever wrote, so it
doubles as a learning record as much as a game.

Lua is a Brazilian programming language, created at PUC-Rio in 1993. Using it
for a college algorithms course was a good fit: it is small, fast, and easy to
read.

## About the game

You play as Laurence. The game is a short side-scrolling platformer with
enemies, pickups, a life bar, and a few endings. It was inspired by classic
Castlevania.

The game still has a few bugs. It was a first project, and it is kept here as
it was written.

## How to run it

The project targets LÖVE 11.x. Install LÖVE first, then run the game folder.

### 1. Install LÖVE

- Linux: install from your package manager (for example `sudo apt install love`)
  or download the AppImage from https://love2d.org/.
- Windows: download and run the installer from https://love2d.org/.
- macOS: `brew install --cask love`, or use the `.dmg` from https://love2d.org/.
- WSL: LÖVE opens a graphical window, so it needs WSLg (Windows 11, or an
  updated Windows 10) or an X server. Install LÖVE inside the WSL distro the
  same way as Linux, then run it as below.

Check the install:

```
love --version
```

### 2. Run the game

From the project root (the folder that contains `main.lua` and `conf.lua`):

```
love .
```

On Windows you can also drag the project folder onto `love.exe`, or run:

```
love.exe C:\path\to\lament-love-2d
```

The game opens fullscreen (desktop mode). There is no quit keybind: use the
"Surrender" button in the menu, or close the window.

## Controls

- Left / Right arrows: move
- Space or Up arrow: jump
- Mouse: menu navigation (Start / Quit)

## Map

Levels were built with Tiled, the map editor from https://www.mapeditor.org/.
The map data lives in `map.lua` and is loaded at runtime through the STI
library.

## Libraries used

- anim8 - sprite animation for LÖVE (https://github.com/kikito/anim8)
- STI - Simple Tiled Implementation, loads the Tiled map in-game
  (https://github.com/karai17/Simple-Tiled-Implementation)
- button_love - button helper for the menu, written by a classmate
  (Vinicius Costa, https://github.com/costvin15/buttonLove2d)

The camera used to rely on STALKER-X. It has since been replaced by a small
self-contained camera module in `modules/camera.lua`, so the project no longer
depends on an external camera library.

## Notes

- Built for the third grade of the Algorithm I course.
- Some parts of the code are in Portuguese, following the course and the
  author's first language.

## What is a man?

A miserable little pile of secrets.
