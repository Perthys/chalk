export type ChalkColor = Color3 | string

export type StrokeJoins = "round" | "bevel" | "miter"
export type StrokeSizing = "fixed" | "scaled"

export type StrokeOptions = {
	Color: ChalkColor;
	Joins: StrokeJoins?;
	Thickness: number?;
	Transparency: number?;
	Sizing: StrokeSizing?;
}

export type MarkOptions = {
	Color: ChalkColor;
	Transparency: number?;
}

export type FaceType =
	"Legacy" | "Arial" | "ArialBold" | "SourceSans" | "SourceSansBold" | "SourceSansLight"
	| "SourceSansItalic" | "Bodoni" | "Garamond" | "Cartoon" | "Code" | "Highway"
	| "SciFi" | "Arcade" | "Fantasy" | "Antique" | "SourceSansSemibold" | "Gotham"
	| "GothamMedium" | "GothamBold" | "GothamBlack" | "AmaticSC" | "Bangers" | "Creepster"
	| "DenkOne" | "Fondamento" | "FredokaOne" | "GrenzeGotisch" | "IndieFlower" | "JosefinSans"
	| "Jura" | "Kalam" | "LuckiestGuy" | "Merriweather" | "Michroma" | "Nunito"
	| "Oswald" | "PatrickHand" | "PermanentMarker" | "Roboto" | "RobotoCondensed" | "RobotoMono"
	| "Sarpanch" | "SpecialElite" | "TitilliumWeb" | "Ubuntu" | "BuilderSans" | "BuilderSansMedium"
	| "BuilderSansBold" | "BuilderSansExtraBold" | "Arimo" | "ArimoBold"

export type WeightType =
	"Thin" | "ExtraLight" | "Light" | "Regular" | "Medium" | "SemiBold" | "Bold" | "ExtraBold" | "Heavy"
	| number

export type FamilyType =
	"AccanthisADFStd" | "AmaticSC" | "Arimo" | "Balthazar" | "Bangers" | "BuilderExtended"
	| "BuilderMono" | "BuilderSans" | "ComicNeueAngular" | "Creepster" | "DenkOne" | "Fondamento"
	| "FredokaOne" | "GrenzeGotisch" | "Guru" | "HighwayGothic" | "Inconsolata" | "IndieFlower"
	| "JosefinSans" | "Jura" | "Kalam" | "LegacyArial" | "LuckiestGuy" | "Merriweather"
	| "Michroma" | "Montserrat" | "Nunito" | "Oswald" | "PatrickHand" | "PermanentMarker"
	| "PressStart2P" | "Roboto" | "RobotoCondensed" | "RobotoMono" | "RomanAntique" | "Sarpanch"
	| "SourceSansPro" | "SpecialElite" | "TitilliumWeb" | "Ubuntu" | "Zekton"

export type ChalkType = ((...string) -> ...string) & {
	bold: ChalkType;
	italic: ChalkType;
	underline: ChalkType;
	strikethrough: ChalkType;
	uppercase: ChalkType;
	smallcaps: ChalkType;

	size: (size: number) -> ChalkType;
	face: (face: FaceType) -> ChalkType;
	family: ((family: FamilyType) -> ChalkType) & ((family: string) -> ChalkType);
	weight: (weight: WeightType) -> ChalkType;
	transparency: (transparency: number) -> ChalkType;
	stroke: (options: StrokeOptions) -> ChalkType;
	color: ((color: ChalkColor) -> ChalkType) & ((r: number, g: number, b: number) -> ChalkType);
	mark: (options: MarkOptions) -> ChalkType;

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
}


const Formats = {
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
		Start = `<stroke color="#%s" joins="%s" thickness="%s" transparency="%s"%s>`;
		End = "</stroke>";
	};
	["MARK"] = {
		Start = `<mark%s>`;
		End = "</mark>";
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

const ChalkData = {};
const ChalkObject = {}; ChalkObject.__index = ChalkObject;

const function GenerateCustomHandlerFunction(Type)
	return function(Argument)
		const FormatStart = Formats[Type].Start:format(Argument);

		return function(String)
			return `{FormatStart}{String}{Formats[Type].End}`
		end
	end
end

const function GenerateChalkDataFunction(Type)
	return function(String)
		const Type = Formats[Type]
		return `{Type.Start}{String}{Type.End}`
	end
end

const function ValidateHex(String)
	if typeof(String) ~= "string" then return end

	String = String:gsub("#", "")

	return string.match(String, `^%x%x%x%x%x%x$`)
end

const function ToHexString(Color: ChalkColor): string
	if typeof(Color) == "string" then
		return (Color:gsub("#", ""));
	end

	return Color:ToHex();
end


const CustomHandler = {
	["size"] = GenerateCustomHandlerFunction("FONT_SIZE");
	["face"] = GenerateCustomHandlerFunction("FONT_FACE");
	["family"] = function(Family: string)
		if not Family:find("://") then
			Family = Family:gsub("%.json$", "");
			Family = `rbxasset://fonts/families/{Family}.json`;
		end

		const FormatStart = Formats.FONT_FAMILY.Start:format(Family);

		return function(String)
			return `{FormatStart}{String}{Formats.FONT_FAMILY.End}`
		end
	end;
	["weight"] = GenerateCustomHandlerFunction("FONT_WEIGHT");
	["transparency"] = GenerateCustomHandlerFunction("FONT_TRANSPARENCY");
	["stroke"] = function(Data: StrokeOptions)
		const Color = ToHexString(Data.Color)
		const Joins = Data.Joins or "round";
		const Thickness = Data.Thickness or 1;
		const transparency = Data.Transparency or 0;
		const Sizing = Data.Sizing and ` sizing="{Data.Sizing}"` or "";

		const FormatStart = Formats.STROKE.Start:format(Color, Joins, Thickness, transparency, Sizing);

		return function(String)
			return `{FormatStart}{String}{Formats.STROKE.End}`
		end
	end;
	["color"] = function(...)
		const Args = {...}
		const IsHex = ValidateHex(Args[1]);
		const IsColor3 = typeof(Args[1]) == "Color3";

		const FirstArg = Args[1];

		local FormatStart;

		if IsHex then
			FormatStart = Formats.FONT_COLOR_HEX.Start:format((FirstArg:gsub("#", "")));
		else
			const Color =
				(IsColor3 and FirstArg) or
				Color3.fromRGB(FirstArg, Args[2], Args[3]);

			FormatStart = Formats.FONT_COLOR_RGB.Start:format(math.floor(Color.R * 255), math.floor(Color.G * 255), math.floor(Color.B * 255));
		end

		return function(String)
			return `{FormatStart}{String}{Formats.FONT_COLOR_RGB.End}`
		end
	end;
	["mark"] = function(Data: MarkOptions)
		local Attributes = ` color="#{ToHexString(Data.Color)}"`;

		if Data.Transparency then
			Attributes ..= ` transparency="{Data.Transparency}"`;
		end

		const FormatStart = Formats.MARK.Start:format(Attributes);

		return function(String)
			return `{FormatStart}{String}{Formats.MARK.End}`
		end
	end;
}

function ChalkObject.new(FirstObject)
	const self = {};
	const Meta = {}; 
	const Formatters = {}; self.Formatters = Formatters;

	local NextCall;
	local TrueSelf;

	function Meta:__call(...)
		const Arguments = {...};

		if NextCall then
			const Call = NextCall;

			NextCall = nil;

			return Call(unpack(Arguments));
		end

		const Results = {};

		for _, String in (Arguments) do
			for _, Value in (Formatters) do
				String = Value(String);
			end

			table.insert(Results, String);
		end

		return unpack(Results);
	end

	function Meta:__index(Index)
		const Handler = CustomHandler[Index];

		if (Handler) then
			NextCall = function(...)
				const Result = Handler(...);
				table.insert(Formatters, Result);

				return TrueSelf;
			end

			return TrueSelf;
		end

		const Formatter = ChalkData[Index];


		table.insert(Formatters, Formatter);

		return self;
	end

	Meta:__index(FirstObject);

	TrueSelf = setmetatable(self, Meta)

	return TrueSelf
end

const Chalk = (setmetatable({}, {
	__index = function(_, Index)
		return ChalkObject.new(Index);
	end;
	__newindex = function()
		return error "Chalk is READONLY";
	end
}) :: any) :: ChalkType;

ChalkData.white = Chalk.color(Color3.fromRGB(255, 255, 255));
ChalkData.black = Chalk.color(Color3.fromRGB(0, 0, 0));
ChalkData.red = Chalk.color(Color3.fromRGB(255, 0, 0));
ChalkData.brown = Chalk.color(Color3.fromRGB(153, 51, 0));
ChalkData.orange = Chalk.color(Color3.fromRGB(255, 153, 0));
ChalkData.yellow = Chalk.color(Color3.fromRGB(255, 255, 0));
ChalkData.lime = Chalk.color(Color3.fromRGB(153, 255, 0));
ChalkData.green = Chalk.color(Color3.fromRGB(0, 255, 0));
ChalkData.blue = Chalk.color(Color3.fromRGB(0, 0, 255));
ChalkData.purple = Chalk.color(Color3.fromRGB(102, 0, 153));
ChalkData.pink = Chalk.color(Color3.fromRGB(255, 0, 255));

ChalkData.bold = GenerateChalkDataFunction("BOLD");
ChalkData.italic = GenerateChalkDataFunction("ITALIC");
ChalkData.underline = GenerateChalkDataFunction("UNDERLINE");
ChalkData.strikethrough = GenerateChalkDataFunction("STRIKETHROUGH");
ChalkData.uppercase = GenerateChalkDataFunction("UPPERCASE");
ChalkData.smallcaps = GenerateChalkDataFunction("SMALLCAPS");

return Chalk :: ChalkType;

-- API List 

-- Chalk.bold
-- Chalk.italic
-- Chalk.underline
-- Chalk.strikethrough
-- Chalk.uppercase
-- Chalk.smallcaps

-- Chalk.size(<Size>) -- Number
-- Chalk.face(<Face>) -- FaceType (Enum.Font name, e.g. "Michroma")
-- Chalk.family(<Family>) -- Family name, auto-wrapped to rbxasset://fonts/families/<Name>.json; full rbxasset:// or rbxassetid:// paths pass through unchanged
-- Chalk.weight(<Weight>) -- WeightType ("Thin" | "ExtraLight" | "Light" | "Regular" | "Medium" | "SemiBold" | "Bold" | "ExtraBold" | "Heavy" or 100-900)
-- Chalk.transparency(<Transparency>) -- number 0-1
-- Chalk.stroke({Color = <Color>, Joins = <Joins>, Thickness = <Thickness>, Transparency = <Transparency>, Sizing = <Sizing>}) -- Color3 | Hex string, "round" | "bevel" | "miter", number, number, "fixed" | "scaled"
-- Chalk.color(<Color>) -- Color3 | Hex string, or R, G, B numbers
-- Chalk.mark({Color = <Color>, Transparency = <Transparency>}) -- Highlight the text with a background (mark) color; Color3 | Hex string, optional transparency 0-1

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

