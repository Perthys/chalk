export type ChalkType = {
	bold: ChalkType;
	italic: ChalkType;
	underline: ChalkType;
	strikethrough: ChalkType;
	uppercase: ChalkType;
	smallcaps: ChalkType;

	size: (size: number) -> ChalkType;
	face: (face: string) -> ChalkType;
	family: (family: string) -> ChalkType;
	weight: (weight: string) -> ChalkType;
	transparency: (transparency: number) -> ChalkType;
	stroke: (options: { Color: any, Joins: string, Thickness: number, Transparency: number }) -> ChalkType;
	color: (color: any) -> ChalkType;

	white: ChalkType;
	black: ChalkType;
	red: ChalkType;
	brown: ChalkType;
	orange: ChalkType;
	yellow: ChalkType;
	lime: ChalkType;
	green: ChalkType;
	blue: ChalkType;
	purple: ChalkType;
	pink: ChalkType;
};

local Formats = {
	["FONT_COLOR_RGB"] = {
		Start = `<font color="rgb(%s,%s,%s)">`;
		End = `</font>`;
	};
	["FONT_COLOR_HEX"] = {
		Start = `<font color="#%s">`;
		End = `</font>`;
	};
	["FONT_SIZE"] = {
		Start = `<font size="%d">`;
		End = `</font>`;
	};
	["FONT_FACE"] = {
		Start = `<font face="%s">`;
		End = "</font>"
	};
	["FONT_FAMILY"] = {
		Start = `<font family="%s">`;
		End = "</font>"
	};
	["FONT_WEIGHT"] = {
		Start = `<font weight="%s">`;
		End = "</font>"
	};
	["FONT_TRANSPARENCY"] = {
		Start = `<font transparency="%s">`;
		End = "</font>"
	};
	["STROKE"] = {
		Start = `<stroke color="#%s" joins="%s" thickness="%s" transparency="%s">`;
		End = "</stroke>";
	};
	["BOLD"] = {
		Start = `<b>`;
		End = `</b>`;
	};
	["ITALIC"] = {
		Start = `<i>`;
		End = `</i>`;
	};
	["UNDERLINE"] = {
		Start = "<u>";
		End = "</u>";
	};
	["STRIKETHROUGH"] = {
		Start = "<s>";
		End = "</s>";
	};
	["UPPERCASE"] = {
		Start = "<uppercase>";
		End = "</uppercase>";
	};
	["SMALLCAPS"] = {
		Start = "<smallcaps>";
		End = "</smallcaps>";
	}
}

local ChalkData = {};
local ChalkObject = {}; ChalkObject.__index = ChalkObject;

local function GenerateCustomHandlerFunction(Type)
	return function(Argument)
		local FormatStart = string.format(Formats[Type].Start, Argument);

		return function(String)
			return `{FormatStart}{String}{Formats[Type].End}`
		end
	end
end

local function GenerateChalkDataFunction(Type)
	return function(String)
		local Type = Formats[Type]
		return `{Type.Start}{String}{Type.End}`
	end
end

local function GenerateColorFunction(Color)
	return function(String)
		local R = math.floor(Color.r * 255);
		local G = math.floor(Color.g * 255);
		local B = math.floor(Color.b * 255);

		local FormatStart = string.format(Formats.FONT_COLOR_RGB.Start, R, G, B);

		return `{FormatStart}{String}{Formats.FONT_COLOR_RGB.End}`
	end
end

local function ValidateHex(String)
	if typeof(String) ~= "string" then return end

	String = string.gsub(String, "#", "")

	return string.match(String, `^%x%x%x%x%x%x$`)
end

local CustomHandler = {
	["size"] = GenerateCustomHandlerFunction("FONT_SIZE");
	["face"] = GenerateCustomHandlerFunction("FONT_FACE");
	["family"] = GenerateCustomHandlerFunction("FONT_FAMILY");
	["weight"] = GenerateCustomHandlerFunction("FONT_WEIGHT");
	["transparency"] = GenerateCustomHandlerFunction("FONT_TRANSPARENCY");
	["stroke"] = function(Data)
		local Color = Data.Color or "#FFFFFF";
		local Joins = Data.Joins or "Round";
		local Thickness = Data.Thickness or 1;
		local transparency = Data.Transparency or 0;

		local FormatStart = string.format(Formats.STROKE.Start, Color, Joins, Thickness, transparency);

		return function(String)
			return `{FormatStart}{String}{Formats.STROKE.End}`
		end
	end;
	["color"] = function(...)
		local Args = {...}
		local IsHex = ValidateHex(Args[1]);
		local IsColor3 = typeof(Args[1]) == "Color3";

		local FirstArg = Args[1];

		local Color = 
			(IsColor3 and FirstArg) or 
			Color3.fromRGB(FirstArg, Args[2], Args[3]);

		local FormatStart = (IsHex and string.format(Formats.FONT_COLOR_HEX.Start, string.gsub(FirstArg, "#", ""))) or
		string.format(Formats.FONT_COLOR_RGB.Start, math.floor(Color.R * 255), math.floor(Color.G * 255), math.floor(Color.B * 255));

		return function(String)
			return `{FormatStart}{String}{Formats.FONT_COLOR_RGB.End}`
		end
	end;
}

ChalkData.bold = GenerateChalkDataFunction("BOLD");
ChalkData.italic = GenerateChalkDataFunction("ITALIC");
ChalkData.underline = GenerateChalkDataFunction("UNDERLINE");
ChalkData.strikethrough = GenerateChalkDataFunction("STRIKETHROUGH");
ChalkData.uppercase = GenerateChalkDataFunction("UPPERCASE");
ChalkData.smallcaps = GenerateChalkDataFunction("SMALLCAPS");

local BrickColorCount = 1032

for Index = 1, BrickColorCount do
	local BrickColor = BrickColor.new(Index);

	local function Function(String)
		local R = math.floor(BrickColor.r * 255);
		local G = math.floor(BrickColor.g * 255);
		local B = math.floor(BrickColor.b * 255);

		local FormatStart = string.format(Formats.FONT_COLOR_RGB.Start, R, G, B);

		return `{FormatStart}{String}{Formats.FONT_COLOR_RGB.End}`
	end

	ChalkData[string.lower(BrickColor.Name)] = Function
	ChalkData[BrickColor.Name] = Function
	ChalkData[BrickColor] = Function
end

ChalkData.white = GenerateColorFunction(Color3.fromRGB(255, 255, 255));
ChalkData.black = GenerateColorFunction(Color3.fromRGB(0, 0, 0));
ChalkData.red = GenerateColorFunction(Color3.fromRGB(255, 0, 0));
ChalkData.brown = GenerateColorFunction(Color3.fromRGB(153, 51, 0));
ChalkData.orange = GenerateColorFunction(Color3.fromRGB(255, 153, 0));
ChalkData.yellow = GenerateColorFunction(Color3.fromRGB(255, 255, 0));
ChalkData.lime = GenerateColorFunction(Color3.fromRGB(153, 255, 0));
ChalkData.green = GenerateColorFunction(Color3.fromRGB(0, 255, 0));
ChalkData.blue = GenerateColorFunction(Color3.fromRGB(0, 0, 255));
ChalkData.purple = GenerateColorFunction(Color3.fromRGB(102, 0, 153));
ChalkData.pink = GenerateColorFunction(Color3.fromRGB(255, 0, 255));

function ChalkObject.new(FirstObject)
	local self = {};
	local Meta = {}; 
	local Formatters = {}; self.Formatters = Formatters;

	local NextCall;
	local TrueSelf;

	function Meta:__call(...)
		local Arguments = {...};

		if NextCall then
			local Call = NextCall;

			NextCall = nil;

			return Call(table.unpack(Arguments));
		end

		local Results = {};

		for _, String in (Arguments) do
			for _, Value in (Formatters) do
				String = Value(String);
			end

			table.insert(Results, String);
		end

		return table.unpack(Results);
	end

	function Meta:__index(Index)
		local CustomHandler = CustomHandler[Index];

		if (CustomHandler) then
			NextCall = function(...)
				local Result = CustomHandler(...);
				table.insert(Formatters, Result);

				return TrueSelf;
			end

			return TrueSelf;
		end

		local Formatter = ChalkData[Index];

		table.insert(Formatters, Formatter);

		return self;
	end

	Meta:__index(FirstObject);

	TrueSelf = setmetatable(self, Meta)

	return TrueSelf
end

local Chalk = setmetatable({}, {
	__index = function(_, Index)
		return ChalkObject.new(Index);
	end;
	__newindex = function()
		return error "Chalk is READONLY";
	end
}); 

return Chalk :: ChalkType;

-- API List 

-- Chalk.[<BrickColorName>]
-- Chalk.bold
-- Chalk.italic
-- Chalk.underline
-- Chalk.strikethrough
-- Chalk.uppercase
-- Chalk.smallcaps

-- Chalk.size(<Size>) -- Number
-- Chalk.face(<Face>) -- string
-- Chalk.family(<rbxasset://>) -- string
-- Chalk.weight(<Weight>) -- string
-- Chalk.transparency(<Transparency>) -- number 0-1
-- Chalk.stroke({Color = <Color>, Joins = <Joins>, Thickness = <Thickness>, Transparency = <Transparency>}) -- Color3, string, number, number
-- Chalk.color(<Color>) -- Color3, string, number, number, number

-- Chalk.white - Set the color to white
-- Chalk.black - Set the color to black
-- Chalk.red - Set the color to red
-- Chalk.brown - Set the color to brown
-- Chalk.orange - Set the color to orange
-- Chalk.yellow - Set the color to yellow
-- Chalk.lime - Set the color to lime
-- Chalk.green - Set the color to green
-- Chalk.blue - Set the color to blue
-- Chalk.purple - Set the color to purple
-- Chalk.pink - Set the color to pink


