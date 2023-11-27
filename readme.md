<h1 align="center">
	<br>
	<br>
	<img width="320" src="media/logo.svg" alt="Chalk">
	<br>
	<br>
	<br>
</h1>

> Rich Text styling done right

## Highlights

- Expressive API
- Highly performant
- No dependencies
- Ability to nest styles
- Auto-detects color support
- Clean and focused
- Actively maintained
- Extremely Lightweight (less than 250 lines)

## Install

```lua
-- Run in Roblox Studio Console
local HttpService = game:GetService("HttpService"); 
local ReplicatedStorage = game:GetService("ReplicatedStorage");

HttpService.HttpEnabled = true

local ChalkModule = Instance.new("ModuleScript");
ChalkModule.Name = "Chalk";
ChalkModule.Parent = ReplicatedStorage;

local Request = HttpService:RequestAsync({
    Url = "https://raw.githubusercontent.com/Perthys/chalk/main/source/main.lua";
    Method = "GET";
});

if Request.Success and Request.StatusCode == 200 then
    ChalkModule.Source = Request.Body

    print("Successfully installed Chalk module. At:", ChalkModule);
else
    error("Failed to install Chalk module.");
end
```

## Usage

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Chalk = require(ReplicatedStorage:WaitForChild("Chalk"));

local TextBox = script.Parent;

TextBox.Text = chalk.blue('Hello world!')

```

Chalk comes with an easy to use composable API where you just chain and nest the styles you want.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Chalk = require(ReplicatedStorage:WaitForChild("Chalk"));

local TextBox = script.Parent;

TextBox.Text = Chalk.blue("Hello") .. 'World' .. chalk.red("!")
TextBox.Text = Chalk.blue.bold("Hello world!")
TextBox.Text = Chalk.blue("Hello", "World!", "Foo", "bar", "biz", "baz")
TextBox.Text = Chalk.red("Hello", Chalk.underline("world") .. "!")
TextBox.Text = Chalk.green(
    "I am a green line " ..
    Chalk.blue.underline.bold("with a blue substring") ..
    " that becomes green again!"
)

TextBox.Text = ([[
CPU: %s
RAM: %s
DISK: %s
]]):format(
    Chalk.red("90%"),
    Chalk.green("40%"),
    Chalk.yellow("70%")
)

TextBox.Text = Chalk.color(123, 45, 67).underline("Underlined reddish color")
TextBox.Text = Chalk.color("#DEADED").bold("Bold gray!")
```

Easily define your own themes:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Chalk = require(ReplicatedStorage:WaitForChild("Chalk"));

local TextBox = script.Parent;

local error = Chalk.bold.red;
local warning = Chalk.color("#FFA500");

TextBox.Text = error("Error!") 
TextBox.Text = warning("Warning!");
```

Take advantage of string substitution:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Chalk = require(ReplicatedStorage:WaitForChild("Chalk"));

local TextBox = script.Parent;

local Name = "Sindre";
TextBox.Text = Chalk.green(("Hello %s"):format(Name))
```

## API

### chalk.`<style>[.<style>...](string, [string...])`

Example: `chalk.red.bold.underline('Hello', 'world');`

Chain [styles](#styles) and call the last one as a method with a string argument. Order doesn't matter, and earlier styles take precedent in case of a conflict. This simply means that `chalk.red.yellow.green` is equivalent to `chalk.red`.

## Styles

### Modifiers
- `Chalk.bold` - Make the text bold
- `Chalk.italic` - Make the text italic
- `Chalk.underline` - Underline the text
- `Chalk.strikethrough` - Strike through the text
- `Chalk.uppercase` - Convert text to uppercase
- `Chalk.smallcaps` - Convert text to small capitals

- `Chalk.color(Hex) | Chalk.color(R, G, B) | Chalk.color(Color3.new())` - Set the color
- `Chalk.size([<Size>])` - Set the size of the text (Number)
- `Chalk.face([<Face>])` - Set the typeface of the text (String)
- `Chalk.family([<rbxasset://>])` - Set the font family from an asset (String)
- `Chalk.weight([<Weight>])` - Set the font weight (String)
- `Chalk.transparency([<Transparency>])` - Set the transparency of the text (Number 0-1)
- `Chalk.stroke({Color = [<Color>], Joins = [<Joins>], Thickness = [<Thickness>], Transparency = [<Transparency>]})` - Define stroke properties: color (Color3), joins (String), thickness (Number), and transparency (Number)

### Colors

- `Chalk[<BrickColorName>]` - Set the color to a BrickColor [`Colors`](https://create.roblox.com/docs/reference/engine/datatypes/BrickColor#r)
- `Chalk.white` - Set the color to white
- `Chalk.black` - Set the color to black
- `Chalk.red` - Set the color to red
- `Chalk.brown` - Set the color to brown
- `Chalk.orange` - Set the color to orange
- `Chalk.yellow` - Set the color to yellow
- `Chalk.lime` - Set the color to lime
- `Chalk.green` - Set the color to green
- `Chalk.blue` - Set the color to blue
- `Chalk.purple` - Set the color to purple
- `Chalk.pink` - Set the color to pink
  
## Color3, 256 RGB, Hex and BrickColor support

Chalk supports Color3, 256 RGB, Hex and BrickColor.

Examples:

- `chalk.color('#DEADED').underline('Hello, world!')`
- `chalk.color(15, 100, 204)`
- `chalk.color(Color3.fromRGB(100, 255, 255))`
- `chalk.nougat`

The following color models can be used:

- [`rgb`](https://en.wikipedia.org/wiki/RGB_color_model) - Example: `chalk.color(255, 136, 0).bold('Orange!')`
- [`hex`](https://en.wikipedia.org/wiki/Web_colors#Hex_triplet) - Example: `chalk.color('#FF8800').bold('Orange!')`
- [`Color3`](https://create.roblox.com/docs/reference/engine/datatypes/Color3) - Example: `chalk.color(Color3.fromRGB(255, 136, 0)).bold("Orange")`
- ["BrickColor](https://create.roblox.com/docs/reference/engine/datatypes/BrickColor) - Example `chalk["Earth orange"]`


## Origin story
I wanted to make the [`npm package`](https://www.npmjs.com/package/chalk) [`chalk`](https://github.com/chalk/chalk) for roblox luau [`richtext`](https://create.roblox.com/docs/ui/rich-text) because I really did not want to do styling manually.

## Side Note
ROBLOX PLEASE ADD CONSOLE STYLING I KNOW ITS POSSIBLE JUST ENABLE RICH TEXT

If roblox adds support for background text directly with richtext i will also add support

## Maintainers

- [Perth](https://github.com/Perthys) | `Perthys#0`
