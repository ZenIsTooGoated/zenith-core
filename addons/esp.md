# ESP Script Documentation


## Features
- **Player ESP**: Draws boxes around players.
- **Health Bar**: Displays the remaining health of players.
- **Tracers**: Lines connecting players to a fixed screen position.
- **Distance Display**: Shows the distance of a player.
- **Name Display**: Displays the name of the player.
- **Team Check**: Optionally hides teammates from ESP.
- **Team Colors**: Colors ESP elements based on the player's team color.


## Loadstring
```lua
local espLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/ZenIsTooGoated/zenith-core/refs/heads/main/addons/esp.lua"))()
```

## Configuration
The script uses `getgenv().ESPSettings` for customization.

### Default Configuration
```lua
getgenv().ESPSettings = {
    enabled = true,
    player = true,

    appearance = {
        boxes = true,
        names = true,
        distance = true,
        tracers = false,
        healthbar = true,

        font = 3,
        outlineColor = Color3.fromRGB(0, 0, 0),
        defaultColor = Color3.fromRGB(255, 255, 255),
    },

    behavior = {
        teamcheck = false,
        teamcolors = false,
    },
}
```

### Setting Explanations
#### **General Settings**
| Setting       | Type    | Description                                  |
|--------------|--------|----------------------------------------------|
| `enabled`    | Boolean | Enables or disables the ESP entirely.        |
| `player`     | Boolean | Enables ESP for players.                     |

#### **Appearance Settings**
| Setting         | Type      | Description                                    |
|----------------|----------|------------------------------------------------|
| `boxes`        | Boolean  | Draws a box around each player.                |
| `names`        | Boolean  | Displays the player's name above their head.   |
| `distance`     | Boolean  | Displays the player's distance.                |
| `tracers`      | Boolean  | Draws a line from the player to a fixed point. |
| `healthbar`    | Boolean  | Displays a health bar next to the player.      |
| `font`         | Integer  | Sets the font type for text elements.          |
| `outlineColor` | Color3   | Sets the color of outlines.                    |
| `defaultColor` | Color3   | Sets the default color of ESP elements.        |

#### **Behavior Settings**
| Setting        | Type    | Description                                      |
|---------------|--------|--------------------------------------------------|
| `teamcheck`   | Boolean | Hides ESP for teammates if enabled.             |
| `teamcolors`  | Boolean | Colors ESP elements based on team colors.       |

## Usage
### **Enable ESP**
```lua
getgenv().ESPSettings.enabled = true
```

### **Disable ESP**
```lua
getgenv().ESPSettings.enabled = false
```

### **Toggle Team Check**
```lua
getgenv().ESPSettings.behavior.teamcheck = true  -- Hide teammates
```

### **Change ESP Colors**
```lua
getgenv().ESPSettings.appearance.defaultColor = Color3.fromRGB(0, 255, 0)  -- Green
```

### **Show Health Bar**
```lua
getgenv().ESPSettings.appearance.healthbar = true
```


## Notes
- The script automatically updates ESP in real-time.
- The ESP respects team-check and health-check settings.
- The script supports toggling elements.

## Troubleshooting
| Issue              | Possible Cause | Solution |
|--------------------|---------------|----------|
| ESP not visible   | `enabled = false` | Set `enabled = true` |
| No health bars    | `healthbar = false` | Set `healthbar = true` |
| Tracers not working | `tracers = false` | Enable tracers in settings |


