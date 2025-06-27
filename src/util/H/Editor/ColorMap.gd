@tool

# https://github.com/godotengine/godot/blob/master/editor/themes/editor_color_map.cpp

const MAPPING : Dictionary[Color, Color] = {
	Color("#478cbf"): Color("#478cbf"), # Godot Blue
	Color("#414042"): Color("#414042"), # Godot Gray

	Color("#ffffff"): Color("#414141"), # Pure white
	Color("#fefefe"): Color("#fefefe"), # Forced light color
	Color("#000000"): Color("#bfbfbf"), # Pure black
	Color("#010101"): Color("#010101"), # Forced dark color

	# Keep pure RGB colors as is, but list them for explicitness.
	Color("#ff0000"): Color("#ff0000"), # Pure red
	Color("#00ff00"): Color("#00ff00"), # Pure green
	Color("#0000ff"): Color("#0000ff"), # Pure blue

	# GUI Colors
	Color("#e0e0e0"): Color("#5a5a5a"), # Common icon color
	Color("#808080"): Color("#808080"), # GUI disabled color
	Color("#b3b3b3"): Color("#363636"), # GUI disabled light color
	Color("#699ce8"): Color("#699ce8"), # GUI highlight color
	Color("#f9f9f9"): Color("#606060"), # Scrollbar grabber highlight color

	Color("#c38ef1"): Color("#a85de9"), # Animation
	Color("#8da5f3"): Color("#3d64dd"), # 2D Node
	Color("#7582a8"): Color("#6d83c8"), # 2D Node Abstract
	Color("#fc7f7f"): Color("#cd3838"), # 3D Node
	Color("#b56d6d"): Color("#be6a6a"), # 3D Node Abstract
	Color("#99c4ff"): Color("#4589e6"), # 2D Non-Node
	Color("#869ebf"): Color("#7097cd"), # 2D Non-Node Abstract
	Color("#ffa6bd"): Color("#e65c7f"), # 3D Non-Node
	Color("#bf909c"): Color("#cd8b9c"), # 3D Non-Node Abstract
	Color("#8eef97"): Color("#2fa139"), # GUI Control
	Color("#76ad7b"): Color("#64a66a"), # GUI Control Abstract

	Color("#5fb2ff"): Color("#0079f0"), # Selection (blue)
	Color("#003e7a"): Color("#2b74bb"), # Selection (darker blue)
	Color("#f7f5cf"): Color("#615f3a"), # Gizmo (yellow)

	# Rainbow
	Color("#ff4545"): Color("#ff2929"), # Red
	Color("#ffe345"): Color("#ffe337"), # Yellow
	Color("#80ff45"): Color("#74ff34"), # Green
	Color("#45ffa2"): Color("#2cff98"), # Aqua
	Color("#45d7ff"): Color("#22ccff"), # Blue
	Color("#8045ff"): Color("#702aff"), # Purple
	Color("#ff4596"): Color("#ff2781"), # Pink

	# Audio gradients
	Color("#e1da5b"): Color("#d6cf4b"), # Yellow

	Color("#62aeff"): Color("#1678e0"), # Frozen gradient top
	Color("#75d1e6"): Color("#41acc5"), # Frozen gradient middle
	Color("#84ffee"): Color("#49ccba"), # Frozen gradient bottom

	Color("#f70000"): Color("#c91616"), # Color track red
	Color("#eec315"): Color("#d58c0b"), # Color track orange
	Color("#dbee15"): Color("#b7d10a"), # Color track yellow
	Color("#288027"): Color("#218309"), # Color track green

	# Other objects
	Color("#ffca5f"): Color("#fea900"), # Mesh resource (orange)
	Color("#2998ff"): Color("#68b6ff"), # Shape resource (blue)
	Color("#a2d2ff"): Color("#4998e3"), # Shape resource (light blue)
	Color("#69c4d4"): Color("#29a3cc"), # Input event highlight (light blue)

	# Animation editor tracks
	# The property track icon color is set by the common icon color.
	Color("#ea7940"): Color("#bd5e2c"), # 3D Position track
	Color("#ff2b88"): Color("#bd165f"), # 3D Rotation track
	Color("#eac840"): Color("#bd9d1f"), # 3D Scale track
	Color("#3cf34e"): Color("#16a827"), # Call Method track
	Color("#2877f6"): Color("#236be6"), # Bezier Curve track
	Color("#eae440"): Color("#9f9722"), # Audio Playback track
	Color("#a448f0"): Color("#9853ce"), # Animation Playback track
	Color("#5ad5c4"): Color("#0a9c88"), # Blend Shape track

	# Control layouts
	Color("#d6d6d6"): Color("#474747"), # Highlighted part
	Color("#474747"): Color("#d6d6d6"), # Background part
	Color("#919191"): Color("#6e6e6e"), # Border part

	# TileSet editor icons
	Color("#fce00e"): Color("#aa8d24"), # New Single Tile
	Color("#0e71fc"): Color("#0350bd"), # New Autotile
	Color("#c6ced4"): Color("#828f9b"), # New Atlas

	# Variant types
	Color("#41ecad"): Color("#25e3a0"), # Variant
	Color("#6f91f0"): Color("#6d8eeb"), # bool
	Color("#5abbef"): Color("#4fb2e9"), # int/uint
	Color("#35d4f4"): Color("#27ccf0"), # float
	Color("#4593ec"): Color("#4690e7"), # String
	Color("#ee5677"): Color("#ee7991"), # AABB
	# same mapping as pure white
	# Color("#e0e0e0"): Color("#5a5a5a"), # Array 
	Color("#e1ec41"): Color("#b2bb19"), # Basis
	Color("#54ed9e"): Color("#57e99f"), # Dictionary
	Color("#417aec"): Color("#6993ec"), # NodePath
	Color("#55f3e3"): Color("#12d5c3"), # Object
	Color("#f74949"): Color("#f77070"), # Plane
	Color("#44bd44"): Color("#46b946"), # Projection
	Color("#ec418e"): Color("#ec69a3"), # Quaternion
	Color("#f1738f"): Color("#ee758e"), # Rect2
	Color("#41ec80"): Color("#2ce573"), # RID
	Color("#b9ec41"): Color("#96ce1a"), # Transform2D
	Color("#f68f45"): Color("#f49047"), # Transform3D
	Color("#ac73f1"): Color("#ad76ee"), # Vector2
	Color("#de66f0"): Color("#dc6aed"), # Vector3
	Color("#f066bd"): Color("#ed6abd"), # Vector4

	# Visual shaders
	Color("#77ce57"): Color("#67c046"), # Vector funcs
	Color("#ea686c"): Color("#d95256"), # Vector transforms
	Color("#eac968"): Color("#d9b64f"), # Textures and cubemaps
	Color("#cf68ea"): Color("#c050dd"), # Functions and expressions
}

# ugh should have done this opposite...
const NAME_MAPPING : Dictionary[String, Color]= {
	"Godot Blue": Color("#478cbf"),
	"Godot Gray": Color("#414042"),

	"Pure White": Color("#ffffff"),
	"Forced Light Color": Color("#fefefe"),
	"Pure Black": Color("#000000"),
	"Forced Dark Color": Color("#010101"),

	# Keep pure RGB colors as is, but list them for explicitness.
	"Pure Red": Color("#ff0000"),
	"Pure Green": Color("#00ff00"),
	"Pure Blue": Color("#0000ff"),

	# GUI Colors
	"Common Icon Color": Color("#e0e0e0"),
	"GUI Disabled Color": Color("#808080"),
	"GUI Disabled Light Color": Color("#b3b3b3"),
	"GUI Highlight Color": Color("#699ce8"),
	"Scrollbar Grabber Highlight Color": Color("#f9f9f9"),

	"Animation": Color("#c38ef1"),
	"2D Node": Color("#8da5f3"),
	"2D Node Abstract": Color("#7582a8"),
	"3D Node": Color("#fc7f7f"),
	"3D Node Abstract": Color("#b56d6d"),
	"2D Non-Node": Color("#99c4ff"),
	"2D Non-Node Abstract": Color("#869ebf"),
	"3D Non-Node": Color("#ffa6bd"),
	"3D Non-Node Abstract": Color("#bf909c"),
	"GUI Control": Color("#8eef97"),
	"GUI Control Abstract": Color("#76ad7b"),

	"Selection - Blue": Color("#5fb2ff"),
	"Selection - Darker Blue": Color("#003e7a"),
	"Gizmo - Yellow": Color("#f7f5cf"),

	# Rainbow
	"Red": Color("#ff4545"),
	"Yellow": Color("#ffe345"),
	"Green": Color("#80ff45"),
	"Aqua": Color("#45ffa2"),
	"Blue": Color("#45d7ff"),
	"Purple": Color("#8045ff"),
	"Pink": Color("#ff4596"),

	# Audio gradients
	"Yellow (Audio)": Color("#e1da5b"),

	"Frozen gradient top": Color("#62aeff"),
	"Frozen gradient middle": Color("#75d1e6"),
	"Frozen gradient bottom": Color("#84ffee"),

	"Color Track Red": Color("#f70000"),
	"Color Track Orange": Color("#eec315"),
	"Color Track Yellow": Color("#dbee15"),
	"Color Track Green": Color("#288027"),

	# Other objects
	"Mesh Resource (Orange)": Color("#ffca5f"),
	"Shape Resource (Blue)": Color("#2998ff"),
	"Shape Resource (Light Blue)": Color("#a2d2ff"),
	"Input Event Highlight (Light Blue)": Color("#69c4d4"),

	# Animation editor tracks
	# The property track icon color is set by the common icon color.
	"3D Position Track": Color("#ea7940"),
	"3D Rotation Track": Color("#ff2b88"),
	"3D Scale Track": Color("#eac840"),
	"Call Method Track": Color("#3cf34e"),
	"Bezier Curve Track": Color("#2877f6"),
	"Audio Playback Track": Color("#eae440"),
	"Animation Playback Track": Color("#a448f0"),
	"Blend Shape Track": Color("#5ad5c4"),

	# Control layouts
	"Highlighted Part": Color("#d6d6d6"),
	"Background Part": Color("#474747"),
	"Border Part": Color("#919191"),

	# TileSet editor icons
	"New Single Tile": Color("#fce00e"),
	"New Autotile": Color("#0e71fc"),
	"New Atlas": Color("#c6ced4"),

	# Variant types
	"Variant": Color("#41ecad"),
	"bool": Color("#6f91f0"),
	"int/uint": Color("#5abbef"),
	"float": Color("#35d4f4"),
	"String": Color("#4593ec"),
	"AABB": Color("#ee5677"),
	"Array": Color("#e0e0e0"),
	"Basis": Color("#e1ec41"),
	"Dictionary": Color("#54ed9e"),
	"NodePath": Color("#417aec"),
	"Object": Color("#55f3e3"),
	"Plane": Color("#f74949"),
	"Projection": Color("#44bd44"),
	"Quaternion": Color("#ec418e"),
	"Rect2": Color("#f1738f"),
	"RID": Color("#41ec80"),
	"Transform2D": Color("#b9ec41"),
	"Transform3D": Color("#f68f45"),
	"Vector2": Color("#ac73f1"),
	"Vector3": Color("#de66f0"),
	"Vector4": Color("#f066bd"),

	# Visual shaders
	"Vector Functions": Color("#77ce57"),
	"Vector Transforms": Color("#ea686c"),
	"Textures and Cubemaps": Color("#eac968"),
	"Functions and Expressions": Color("#cf68ea"),
}

static func get_base_colors() -> Array[Color]:
	return MAPPING.keys()

static func get_mapped_color(color: Color) -> Color:
	if color in MAPPING:
		return MAPPING[color]
	return Color.BLACK

static func get_color_name(color: Color) -> String:
	for key in NAME_MAPPING:
		if NAME_MAPPING[key] == color:
			return key
	return ""
