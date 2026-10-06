# Asset Library submission - Crisp Juice Free

Paste these into https://godotengine.org/asset-library/asset/submit (log in first). Nothing has been submitted or pushed yet.
The repository URL assumes the GitHub account is `Anipixels` and the repository is named as suggested; adjust if not.

| Field | Value |
|---|---|
| Asset Name (title) | Crisp Juice Free - 8 Casual Game VFX |
| Category | 2D Tools |
| Godot version | 4.3 (tested only on 4.7.2 stable (the .NET editor build, run headless on Windows 11); see the note below) |
| Version | 1.0.0 |
| Repository host | GitHub |
| Repository URL | https://github.com/Anipixels/crisp-juice-free |
| Issues URL | https://github.com/Anipixels/crisp-juice-free/issues |
| Download Commit | the full 40-character hash of the commit you pushed (`git rev-parse HEAD`) |
| Icon URL | https://raw.githubusercontent.com/Anipixels/crisp-juice-free/main/icon.png |
| License | CC-BY-4.0 (the form takes one licence; the description says the GDScript is MIT) |
| Suggested repo name | crisp-juice-free |

Preview: type **Image**, image URL and thumbnail URL both
`https://raw.githubusercontent.com/Anipixels/crisp-juice-free/main/screenshot.png`

## Short description

(For the GitHub repository "About" line; the Asset Library form has no short-description field.)

8 free sprite-sheet effects for casual and puzzle games (gem burst, coins, stars, confetti, impacts, sparkle) as ready scenes, with a one-line spawn helper.

## Description (long)

```
Eight sprite-sheet effects for casual and puzzle games, as ready-to-use scenes:
gem burst, match pop, star burst, coin burst, confetti burst, shockwave ring, tap ripple and a looping sparkle.

- Drag a scene into your level: it plays at once and frees itself when it finishes.
- Or spawn from code in one line: CrispVfx.spawn(scene, parent, position)
- Each effect is one Sprite2D with the CrispVfx script: fps, loop, autoplay and free_on_finish in the Inspector, play() / stop(), a finished signal.
- Plain PNG sheets (192 or 256 px cells, 30 fps, straight alpha) with a sheets.json, so they also work in AnimatedSprite2D.
- Demo scene included: addons/crisp_juice_free/demo/vfx_demo.tscn (click to play an effect).

Installs into addons/crisp_juice_free. GDScript only. Written for Godot 4.3+, tested on 4.7.2.

This is the free sampler of Crisp Juice, which has 68 effects (these 8 and 60 more): https://anipixels.itch.io/crisp-juice

Licence: sprite sheets and scenes CC BY 4.0 (credit "Crisp Juice Free by Anipixels" with the link above); GDScript MIT.
How it was made: the sprite sheets are generated procedurally by code written with an AI assistant (Claude). No AI image generators.
```

## Notes before you submit

- Godot version: the addon is written for 4.3+, but it has only been run on 4.7.2. Choosing "4.3" in the form is a claim that
  it works there. If you would rather claim only what was tested, pick the newest 4.x entry the form offers instead.
- The `.gitattributes` file marks everything except `addons/` as `export-ignore`, so the zip the Asset Library downloads
  contains only `addons/crisp_juice_free/` (with its own README and licence copy).
