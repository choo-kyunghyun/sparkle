# Sparkle

![Sparkle](assets/splash.png)

Sparkle is an open-source [GameMaker](https://gamemaker.io/en) project. The goal of this project is to make the various features as easy to use as possible. This project is in its early stages and there may be inconsistent changes.

## Features

### Master object

A single game object manages all systems. This allows for a quick understanding of the entire code and makes maintenance easy.

### UI manager

The project provides a UI manager. Buttons placed in the room editor are automatically managed by the manager. This makes it easy to add and manage UI elements.

### Camera

A camera object that supports both 2D and 3D is provided. You only need to select one of the pre-written update functions. This allows for easy application of camera settings suitable for various game genres.

## License

Sparkle is licensed under the MIT License. For more details, see the [LICENSE](LICENSE) file in the repository.

## Resources

These are helpful resources for indie developers creating video games.

| Name | Description | Link |
| ---- | ----------- | ---- |
| Aseprite | Sprite editor | [Aseprite](https://www.aseprite.org/) <br> [Steam](https://store.steampowered.com/app/431730/Aseprite/) |
| facebookresearch/audiocraft | Audio generation tools | [GitHub](https://github.com/facebookresearch/audiocraft) <br> [Demo](https://huggingface.co/spaces/facebook/MusicGen) |
| GameMaker | The Ultimate 2D Game engine | [Blog](https://gamemaker.io/en/blog) <br> [Manual](https://manual.gamemaker.io/) <br> [Marketplace](https://marketplace.gamemaker.io/) <br> [Tutorials](https://gamemaker.io/en/tutorials) |
| Google Fonts | Free fonts | [Noto Sans](https://fonts.google.com/noto/specimen/Noto+Sans) |
| itch.io | Game assets marketplace | [Game assets](https://itch.io/game-assets) |
| nisrulz/app-privacy-policy-generator | Privacy policy generator | [GitHub](https://github.com/nisrulz/app-privacy-policy-generator) <br> [Web](https://app-privacy-policy-generator.nisrulz.com/) |
| Stable Diffusion | AI-based image generation | [Stable Diffusion](https://stability.ai/stable-image) <br> [AUTOMATIC1111/stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui) <br> [comfyanonymous/ComfyUI](https://github.com/comfyanonymous/ComfyUI) |
| Visual Studio Code | Code editor | [Visual Studio Code](https://code.visualstudio.com/) <br> [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) <br> [GitHub Copilot Chat](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat) <br> [Stitch](https://marketplace.visualstudio.com/items?itemName=bscotch.bscotch-stitch-vscode) |

## Project Status

| Type | Item | Description | Status |
| ---- | ---- | ----------- | ------ |
| ~~Feature~~ | ~~Sparkle wiki~~ | ~~Comprehensive documentation and guides for the project~~ New code editor supports markdown. I am considering changing to an internal manual instead of GitHub wiki. | ~~Planned~~ |
| Feature | Actor | Implement actor object, faction system, pathfinding script, buffs and debuffs system, and actor manager | Planned |
| Feature | Items and inventory | Implement items and actor inventory | Planned |
| Feature | Item upgrade system | Implement item upgrade system including weapon modding | Planned |
| Feature | Audio manager | Implement a comprehensive audio system | Planned |
| Feature | Crossfading | Crossfading for bgm transition | Planned |
| Feature | Dialogue | In-game dialogues system with external files support | Planned |
| Feature | Input manager | Input manager with gamepad support and presets | Planned |
| Feature | Gesture | Support gestures | Planned |
| Feature | Tilemap | Custom tilemap scripts for tilemap manipulation | Planned |
| Feature | Gravity | Simple gravity for any axis | Planned |
| Feature | `obj_collider` | Special collider object for platformer | Planned |
| Feature | FPS camera | A camera update script for FPS games | Planned |
| Feature | HUD and UI Rework | According to the GameMaker Roadmap, Flex Panel will be added in August and UI Layer will be added in October. | Planned |
| Feature | `draw_text_transformed_format()` | Implement more draw_text_format functions | Planned |
| Feature | Chapter 1 | Demo chapter for rpg | Planned |
| Feature | Chapter 2 | Demo chapter for platformer | Planned |
| Feature | Chapter 3 | Demo chapter for top-view shooting | Planned |
| Issues | `draw_apply_format()` causes framerate drop | Parsing is performed in the Draw event. | Fix in progress |
| Issues | Camera pitch | The pitch of the camera must be clamped. | Investigating |
| Issues | Performance of `draw_text_format()` | Parsing is handled in the Draw event, causing serious frame drops. | Pending |
| Improvement | Code refactoring | Refactor code for better maintainability | Ongoing |
| Improvement | Optimize rendering | Improve rendering performance | Planned |
| Improvement | New project logo | According to the GameMaker Roadmap, GameMaker will support SVG vectors. | Planned |
