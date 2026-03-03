---@meta obsidian-thino.types

--- @class obsidian-thino.PopupWindowOptions
--- @field border? "bold"|"double"|"none"|"rounded"|"shadow"|"single"|"solid" Border style of the popup window. Default: "rounded"
--- @field title? string Title text displayed in the popup window border. Default: "Thino (<C-CR> to post)"
--- @field title_pos? "left"|"center"|"right" Position of the title within the border. Default: "center"
--- @field width_ratio? number Width of the popup as a ratio of the editor width (0.1–1.0). Default: 0.6
--- @field height? number Height of the popup in lines (>= 1). Default: 10

--- @class obsidian-thino.Options
--- @field time_format? "%H:%M"|"%H:%M:%S" Format string for the timestamp prepended to each entry. Default: "%H:%M"
--- @field itemize? "list"|"task" List style: "list" uses "- ", "task" uses "- [ ] ". Default: "list"
--- @field popup_window? obsidian-thino.PopupWindowOptions Options for the floating input window
