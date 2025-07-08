![Static Badge](https://img.shields.io/badge/Godot-4.5-blue)
 [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
 ![Static Badge](https://img.shields.io/badge/Tool-Addon-Green)


<div align="center">
	<br/>
	<img src="https://raw.githubusercontent.com/Tattomoosa/godot-plugin-devtools/refs/heads/main/addons/plugin_devtools/assets/icons/PluginDevTools.svg" width="100"/>
	<br/>
	<br/>
		Plugin development made easy, for <a href="https://godotengine.org/">Godot</a>
	<br/>
	<br/>
	<br/>
</div>

## Fork Info
	- Seemed to have cleared most issues related to 4.4.1 compatibility.
	- Make compatible with Modular Browser instancing.
	- Add multiwindow debugger support. If window is child of Editor Base Control, it can be found with F12.


---

> Complete and in a polished state but uses 4.5-only features (oops) and I don't know that I have it in me to backport when I'm using 4.5 exclusively.

# Basic Overview

Host of tools which aid with plugin development. Explore the editor, explore the editor theme, explore property info, load any Control.

# Tools

## <img src="https://raw.githubusercontent.com/godotengine/godot/refs/heads/master/editor/icons/Theme.svg" width="18"/>&nbsp;&nbsp; Theme Explorer

Explore the editor theme - icons, styleboxes, fonts, colors. Features fuzzy search, and drag and drop
to filesystem.

## <img src="https://raw.githubusercontent.com/Tattomoosa/godot-plugin-devtools/refs/heads/main/addons/plugin_devtools/assets/icons/PropertyInfo.svg" width="18"/>&nbsp;&nbsp;  Property Info 

### <img src="https://raw.githubusercontent.com/Tattomoosa/godot-plugin-devtools/refs/heads/main/addons/plugin_devtools/assets/icons/ExploreProperties.svg" width="18"/>&nbsp;&nbsp;  Property Info Explorer

Shows property info for the Inspector's currently selected property. This can be used in
`_validate_property` or `_get_property_list`, or used with Inspector plugins to instantiate
an `EditorProperty` on-demand. Copy and paste functionality both for the Dictionary list and the
code to instantiate an `EditorProperty`.

Also features a tree for selecting and examining properties which aren't shown in the Inspector,
or are shown in a way that isn't directly selectable.

### <img src="https://raw.githubusercontent.com/Tattomoosa/godot-plugin-devtools/refs/heads/main/addons/plugin_devtools/assets/icons/PropertyBuilder.svg" width="18"/>&nbsp;&nbsp;  Property Info Builder

Menu for creating property info - `type`, `hint`, `hint_string`, `usage`. No need to wonder what
valid hints and strings are anymore!

## <img src="https://raw.githubusercontent.com/Tattomoosa/godot-plugin-devtools/refs/heads/main/addons/plugin_devtools/src/tools_dock/load_control_into_dock/assets/icons/LoadControlInDock.svg" width="18"/>&nbsp;&nbsp;  Load Control

Load any Control node into the Editor, on-demand, via drag and drop. Only `@tool` scripts will be
functional! Can be used to prototype inspector plugin controls.

## <img src="https://raw.githubusercontent.com/godotengine/godot/refs/heads/master/editor/icons/TripleBar.svg" width="18"/>&nbsp;&nbsp;  Drag & Drop

Drag anything onto the drag and drop panel and it will print out the data. Useful for adding
your own drag and drop functionality - you can see what data your code will get when the user
drops a file or a resource. Simple tool but very useful!

## <img src="https://github.com/Tattomoosa/godot-plugin-devtools/blob/main/addons/plugin_devtools/assets/icons/EditorDebugger.png?raw=true" width="18"/>&nbsp;&nbsp;  Editor Debugger

Significant expansion of Zylann's [Godot Editor Debugger](https://github.com/Zylann/godot_editor_debugger_plugin).

View the node tree that makes up the Godot editor. Select any control on the interface with F12.
Select any node in the tree to view it in the inspector.

Additions include signal inspecting, indications of internal children, indications of Editor-only
internal classes.

# My Godot Plugins

## <img src="https://raw.githubusercontent.com/Tattomoosa/o2/refs/heads/main/addons/o%E2%82%82/assets/icons/o2.svg" width="18"/>&nbsp;&nbsp; [O₂](https://github.com/Tattomoosa/o2)

The Plugin Suite that does the impossible

## <img src="https://raw.githubusercontent.com/Tattomoosa/godot-plugin-devtools/refs/heads/main/addons/plugin_devtools/assets/icons/PluginDevTools.svg" width="18"/>&nbsp;&nbsp; [Plugin DevTools](https://github.com/Tattomoosa/godot-plugin-devtools)

Plugin development made easy

## <img src="https://github.com/Tattomoosa/VisionCone3D/raw/main/addons/tattomoosa.vision_cone_3d/icons/VisionCone3D.svg" width="18"/>&nbsp;&nbsp; [VisionCone3D](https://github.com/Tattomoosa/VisionCone3D)

Simple but configurable 3D vision cone node

## <img src="https://github.com/Tattomoosa/Spinner/raw/main/addons/tattomoosa.spinner/icons/Spinner.svg" width="18"/>&nbsp;&nbsp; [Spinner](https://github.com/Tattomoosa/Spinner)

Simple but configurable process status indicator node

## <img src="https://github.com/Tattomoosa/NetworkTextureRect/raw/main/addons/tattomoosa.network_texture_rect/icons/NetworkTextureRect.svg" width="18"/>&nbsp;&nbsp; [NetworkTextureRect](https://github.com/Tattomoosa/NetworkTextureRect)

Dead simple network images

## <img src="https://raw.githubusercontent.com/Tattomoosa/gd-submodules/refs/heads/main/addons/gd-submodules/icons/GitPlugin.svg" width="18"/>&nbsp;&nbsp; [gd-submodules](https://github.com/Tattomoosa/gd-submodules) (unreleased, experimental)

Plugin management via git submodule