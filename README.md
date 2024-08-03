# Sparkle

![Sparkle](assets/splash.png)

Sparkle is an open-source [GameMaker](https://gamemaker.io/en) project. The goal of this project is to make the various features as easy to use as possible. This project is in its early stages and there may be inconsistent changes.

## Features

### Button

Provides an button object that is based on the finite state machine. Default structures are provided and you can use them as easily as writing CSS and JavaScript code.

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

### Planned Features

| Feature | Description |
| ------- | ----------- |
| Sparkle wiki | Comprehensive documentation and guides for the project |
| Actor object with management system | Manage actors within the game |
| Factions for actors | Create faction parent objects for actors |
| Buffs and debuffs | Implement a system for buffs and debuffs |
| Items and inventory system | Develop a system for items and inventory management |
| Weapon upgrades and gun modding | Develop a system for weapon upgrades and modifications |
| Audio system | Implement a comprehensive audio system |
| Background music | Background music and crossfades |
| Dialogue system | Create a system for in-game dialogues |
| Input manager | Input object with presets |
| Gamepad support | Add support for gamepad controllers |
| Gesture input | Implement gesture-based input controls |
| Custom tilemap scripts | Create custom scripts for tilemap manipulation |
| Simple gravity for any axis | Implement gravity that works on any axis |
| Collider object | Develop special colliders for platformer |
| Camera update script for FPS | Create a script to update the camera for FPS games |
| UI system using Flex Panels | According to the GameMaker Roadmap, Flex Panel will be added in August and UI Layer will be added in October. |
| Chapter 1 | Demo chapter for rpg games |
| Chapter 2 | Demo chapter for platformer games |

### Known Issues

| Issue | Description | Status |
| ----- | ----------- | ------ |
| Text is drawn above the tooltip box | The tooltip must be separated from the button object. | Fix in progress |
| Camera pitch | The pitch of the camera must be clamped. | Investigating |
| Performance of `draw_text_format()` | Parsing is handled in the Draw event, causing serious frame drops. | Pending |

### Improvements

| Improvement | Description | Status |
| ----------- | ----------- | ------ |
| Code refactoring | Refactor code for better maintainability | Ongoing |
| Optimize rendering | Improve rendering performance | Planned |
| draw_text_transformed_format | Writing `draw_text_transformed_format()` | Planned |
