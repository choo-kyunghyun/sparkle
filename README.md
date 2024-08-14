# Sparkle

![Sparkle](assets/splash.png)

Sparkle is an open-source [GameMaker](https://gamemaker.io/en) project. The goal of this project is to make the various features as easy to use as possible. This project is in its early stages and there may be inconsistent changes.

## Features

### Hierarchy

The project has a unique hierarchical structure. Each game element exists as a sub-element of the top-level element called Game. This makes maintenance easy and improves code readability.

### UI Manager

The UI elements placed in the Room editor are automatically managed by the manager. Each element is automatically updated.

### Camera

A camera object that supports both 2D and 3D is provided. Various methods and update scripts are available. You can place the configuration object in the Room editor to select and use the desired camera. Update scripts for different genres of games are provided.

### Input Manager

Input Manager When binding input keys, they are stored as functions rather than constants. This allows you to manage all types of inputs, such as keyboard, mouse, and gamepad, in a single table. It supports key setting presets.

### Delta Time

Everything will move independently of the frame rate.

### Actor Manager

In this project, both players and non-playable characters are actors. An actor object is provided, and the actor manager will manage them.

### Audio Manager

The audio manager will be supported in the future.

### String

Do you want to use various colors and fonts in a single string? Use String. You can change the color in the middle of the string with color tags like `<color=#666666>`, or change the font in the middle with font tags like `<font=fnt_sparkle>`. This String is used in various UIs of this project.

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
| Improvement | Code refactoring | Refactor code for better maintainability | In Progress |
| Feature | Input manager | Input manager with gamepad support and presets | In Progress |
| Issue | `fnt_sparkle` | There is a significant readability issue with the Sparkle font. Some characters need to be recreated. | In Progress |
| Improvement | String | Implement more `draw_text_*` and `string_*` functions | Planned |
| Improvement | `obj_level` and level manager | Rework | Planned |
| Feature | Screenshot | Screenshot | Planned |
| Feature | Documents | New code editor supports markdown. I am considering changing to an internal manual instead of GitHub wiki. | Planned |
| Feature | Actor | Implement actor object, faction system, pathfinding script, buffs and debuffs system, and actor manager | Planned |
| Feature | Gravity | Simple gravity for any axis | Planned |
| Feature | `obj_collider` | Special collider object for platformer | Planned |
| Feature | FPS camera | A camera update method for FPS games | Planned |
| Issue | Camera pitch | The pitch of the camera must be clamped. | Planned |
| Feature | Items and inventory | Implement items and actor inventory | Planned |
| Feature | Item upgrade system | Implement item upgrade system including weapon modding | Planned |
| Feature | Dialogue | In-game dialogues system with external files support | Planned |
| Feature | Audio manager | Implement a comprehensive audio system | Planned |
| Feature | Crossfading | Crossfading for bgm transition | Planned |
| Feature | Tilemap | Custom tilemap scripts for tilemap manipulation | Planned |
| Improvement | Optimize rendering | Improve rendering performance | Planned |
| Demo | Chapter 1 | Demo chapter for Platformer | Planned |
| Demo | Chapter 2 | Demo chapter for Bullet Hell | Planned |
| Demo | Chapter 3 | Demo chapter for RPG | Planned |
| Improvement | HUD and UI Rework | According to the GameMaker Roadmap, Flex Panel will be added in August and UI Layer will be added in October. | Planned |
| Improvement | JavaScript | The project’s scripts will be rewritten in JavaScript. Starting from the end of 2024, JavaScript will be available in GameMaker. Since JavaScript has more users than GML and can receive more assistance from GitHub Copilot, the scripts written in GML will be rewritten in JavaScript if there are no major issues. | Planned |
