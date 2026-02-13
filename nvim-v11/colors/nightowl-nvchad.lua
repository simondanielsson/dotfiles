-- NvChad "nightowl" theme — standalone colorscheme
-- Extracted from NvChad/base46 v2.0 so it works without the NvChad framework.
-- Original credits: https://github.com/haishanh/night-owl.vim

vim.o.background = "dark"
vim.g.colors_name = "nightowl-nvchad"

-- ── Color palette ────────────────────────────────────────────

-- UI colors (base_30)
local c = {
  white         = "#d6deeb",
  darker_black  = "#010f20",
  black         = "#011627",
  black2        = "#091e2f",
  one_bg        = "#112637",
  one_bg2       = "#1b3041",
  one_bg3       = "#253a4b",
  grey          = "#2c4152",
  grey_fg       = "#34495a",
  grey_fg2      = "#3c5162",
  light_grey    = "#495e6f",
  red           = "#f78c6c",
  baby_pink     = "#ff6cca",
  pink          = "#fa58b6",
  line          = "#182d3e",
  green         = "#29E68E",
  vibrant_green = "#22da6e",
  blue          = "#82aaff",
  nord_blue     = "#78a0f5",
  yellow        = "#ffcb8b",
  sun           = "#ffe9a9",
  purple        = "#c792ea",
  dark_purple   = "#a974cc",
  teal          = "#96CEB4",
  orange        = "#FFAD60",
  cyan          = "#aad2ff",
  statusline_bg = "#051a2b",
  lightbg       = "#1a2f40",
  pmenu_bg      = "#82aaff",
  folder_bg     = "#82aaff",
}

-- Base16 syntax colors
local b = {
  base00 = "#011627",  -- background
  base01 = "#0c2132",  -- lighter bg
  base02 = "#172c3d",  -- selection
  base03 = "#223748",  -- comments (alt)
  base04 = "#2c4152",  -- dark foreground
  base05 = "#ced6e3",  -- default foreground
  base06 = "#d6deeb",  -- light foreground
  base07 = "#feffff",  -- lightest foreground
  base08 = "#ecc48d",  -- variables, identifiers
  base09 = "#f78c6c",  -- constants, numbers
  base0A = "#c792ea",  -- types, labels
  base0B = "#29E68E",  -- strings
  base0C = "#aad2ff",  -- regex, escape chars
  base0D = "#82aaff",  -- functions
  base0E = "#c792ea",  -- keywords
  base0F = "#f78c6c",  -- delimiters, brackets
}

-- ── Helper ───────────────────────────────────────────────────

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor defaults ──────────────────────────────────────────

hi("Normal",        { fg = b.base05, bg = "NONE" }) -- transparent background
hi("NormalFloat",   { bg = c.darker_black })
hi("Bold",          { bold = true })
hi("Italic",        { italic = true })
hi("Cursor",        { fg = b.base00, bg = b.base05 })
hi("CursorLine",    { bg = "NONE" })
hi("CursorLineNr",  { fg = c.white })
hi("LineNr",        { fg = "gray" })   -- user preference: stronger gray
hi("SignColumn",    { fg = b.base03, bg = "NONE" })
hi("ColorColumn",   { bg = b.base01 })
hi("CursorColumn",  { bg = b.base01 })
hi("Conceal",       { bg = "NONE" })
hi("NonText",       { fg = b.base03 })
hi("SpecialKey",    { fg = b.base03 })
hi("Visual",        { bg = b.base02 })
hi("VisualNOS",     { fg = b.base08 })
hi("Directory",     { fg = b.base0D })
hi("Title",         { fg = b.base0D })
hi("ErrorMsg",      { fg = b.base08, bg = b.base00 })
hi("WarningMsg",    { fg = b.base08 })
hi("ModeMsg",       { fg = b.base0B })
hi("MoreMsg",       { fg = b.base0B })
hi("Question",      { fg = b.base0D })
hi("WildMenu",      { fg = b.base08, bg = b.base0A })

-- Search
hi("Search",        { fg = b.base01, bg = b.base0A })
hi("IncSearch",     { fg = b.base01, bg = b.base09 })
hi("Substitute",    { fg = b.base01, bg = b.base0A })

-- Matching
hi("MatchWord",     { fg = c.white, bg = c.grey })
hi("MatchParen",    { link = "MatchWord" })

-- Popup menu
hi("Pmenu",         { bg = c.one_bg })
hi("PmenuSbar",     { bg = c.one_bg })
hi("PmenuSel",      { fg = c.black, bg = c.blue })
hi("PmenuThumb",    { bg = c.grey })

-- Folds
hi("Folded",        { fg = c.light_grey, bg = c.black2 })
hi("FoldColumn",    { fg = b.base0C, bg = b.base01 })

-- Splits & windows
hi("WinSeparator",  { fg = c.line })
hi("FloatBorder",   { fg = c.blue })

-- Diff
hi("DiffAdd",       { fg = c.green })
hi("DiffChange",    { fg = c.light_grey })
hi("DiffDelete",    { fg = c.red })
hi("DiffText",      { fg = c.white, bg = c.black2 })

-- Spell
hi("SpellBad",      { undercurl = true, sp = b.base08 })
hi("SpellLocal",    { undercurl = true, sp = b.base0C })
hi("SpellCap",      { undercurl = true, sp = b.base0D })
hi("SpellRare",     { undercurl = true, sp = b.base0E })

-- QuickFix
hi("QuickFixLine",  { bg = b.base01 })

-- Misc
hi("NvimInternalError", { fg = c.red })
hi("healthSuccess", { fg = c.black, bg = c.green })

-- ── Traditional syntax ───────────────────────────────────────

hi("Comment",       { fg = c.grey_fg })
hi("Boolean",       { fg = b.base09 })
hi("Character",     { fg = b.base08 })
hi("Conditional",   { fg = b.base0E })
hi("Constant",      { fg = b.base09 })
hi("Define",        { fg = b.base0E })
hi("Delimiter",     { fg = b.base0F })
hi("Float",         { fg = b.base09 })
hi("Variable",      { fg = b.base05 })
hi("Function",      { fg = b.base0D })
hi("Identifier",    { fg = b.base08 })
hi("Include",       { fg = b.base0D })
hi("Keyword",       { fg = b.base0E })
hi("Label",         { fg = b.base0A })
hi("Number",        { fg = b.base09 })
hi("Operator",      { fg = b.base05 })
hi("PreProc",       { fg = b.base0A })
hi("Repeat",        { fg = b.base0A })
hi("Special",       { fg = b.base0C })
hi("SpecialChar",   { fg = b.base0F })
hi("Statement",     { fg = b.base08 })
hi("StorageClass",  { fg = b.base0A })
hi("String",        { fg = b.base0B })
hi("Structure",     { fg = b.base0E })
hi("Tag",           { fg = b.base0A })
hi("Todo",          { fg = b.base0A, bg = b.base01 })
hi("Type",          { fg = b.base0A })
hi("Typedef",       { fg = b.base0A })
hi("Debug",         { fg = b.base08 })
hi("Exception",     { fg = b.base08 })
hi("Macro",         { fg = b.base08 })
hi("Error",         { fg = b.base00, bg = b.base08 })

-- ── Treesitter ───────────────────────────────────────────────

hi("@annotation",              { fg = b.base0F })
hi("@attribute",               { fg = b.base0A })
hi("@character",               { fg = b.base08 })
hi("@constructor",             { fg = b.base0C })
hi("@constant",                { fg = b.base09 })
hi("@constant.builtin",        { fg = b.base09 })
hi("@constant.macro",          { fg = b.base08 })
hi("@error",                   { fg = b.base08 })
hi("@keyword.exception",       { fg = b.base08 })
hi("@number.float",            { fg = b.base09 })
hi("@keyword",                 { fg = b.base0E })
hi("@keyword.function",        { fg = b.base0E })
hi("@keyword.return",          { fg = c.cyan })     -- nightowl override
hi("@keyword.conditional",     { fg = c.cyan })     -- nightowl override
hi("@keyword.operator",        { fg = b.base0E })
hi("@keyword.import",          { link = "Include" })
hi("@function",                { fg = b.base0D })
hi("@function.builtin",        { fg = b.base0D })
hi("@function.macro",          { fg = b.base08 })
hi("@function.call",           { fg = b.base0D })
hi("@function.method.call",    { fg = b.base0D })
hi("@operator",                { fg = b.base05 })
hi("@method",                  { fg = b.base0D })
hi("@module",                  { fg = b.base08 })
hi("@none",                    { fg = b.base05 })
hi("@variable.parameter",      { fg = c.orange })   -- nightowl override
hi("@reference",               { fg = b.base05 })
hi("@punctuation.bracket",     { fg = b.base0F })
hi("@punctuation.delimiter",   { fg = b.base0F })
hi("@string",                  { fg = b.base0B })
hi("@string.regex",            { fg = b.base0C })
hi("@string.escape",           { fg = b.base0C })
hi("@string.special.url",      { fg = b.base0C })
hi("@string.special.symbol",   { fg = b.base0B })
hi("@tag",                     { link = "Tag" })
hi("@tag.attribute",           { link = "@property" })
hi("@tag.delimiter",           { fg = b.base0F })
hi("@text",                    { fg = b.base05 })
hi("@text.strong",             { bold = true })
hi("@text.emphasis",           { fg = b.base09 })
hi("@text.strike",             { fg = b.base0F, strikethrough = true })
hi("@text.literal",            { fg = b.base09 })
hi("@text.uri",                { fg = b.base09, underline = true })
hi("@type.builtin",            { fg = b.base0A })
hi("@variable",                { fg = b.base05 })
hi("@variable.builtin",        { fg = b.base09 })
hi("@variable.member",         { fg = b.base08 })
hi("@variable.member.key",     { fg = b.base08 })
hi("@property",                { fg = b.base08 })
hi("@definition",              { sp = b.base04, underline = true })
hi("@scope",                   { bold = true })
hi("@comment",                 { fg = c.grey_fg })
hi("@comment.todo",            { fg = c.grey, bg = c.white })
hi("@comment.warning",         { fg = c.black2, bg = b.base09 })
hi("@comment.note",            { fg = c.black2, bg = c.white })
hi("@comment.danger",          { fg = c.black2, bg = c.red })
hi("@diff.plus",               { fg = c.green })
hi("@diff.minus",              { fg = c.red })
hi("@diff.delta",              { fg = c.light_grey })

-- Markup (markdown)
hi("@markup.heading",          { fg = b.base0D })
hi("@markup.raw",              { fg = b.base09 })
hi("@markup.link",             { fg = b.base08 })
hi("@markup.link.url",         { fg = b.base09, underline = true })
hi("@markup.link.label",       { fg = b.base0C })
hi("@markup.list",             { fg = b.base08 })
hi("@markup.strong",           { bold = true })
hi("@markup.italic",           { italic = true })
hi("@markup.strikethrough",    { strikethrough = true })
hi("@markup.quote",            { bg = c.black2 })

-- ── LSP semantic tokens ──────────────────────────────────────
-- These @lsp.type.* groups are applied by LSP servers (e.g. pyrefly) and
-- take priority over treesitter groups. We link them to the matching
-- treesitter groups so they inherit the same colors.

hi("@lsp.type.class",          { link = "Structure" })
hi("@lsp.type.decorator",      { link = "@function" })
hi("@lsp.type.enum",           { link = "Type" })
hi("@lsp.type.enumMember",     { link = "Constant" })
hi("@lsp.type.function",       { link = "@function" })
hi("@lsp.type.interface",      { link = "Structure" })
hi("@lsp.type.macro",          { link = "Macro" })
hi("@lsp.type.method",         { link = "@function" })
hi("@lsp.type.namespace",      { link = "@module" })
hi("@lsp.type.parameter",      { link = "@variable.parameter" })
hi("@lsp.type.property",       { link = "@property" })
hi("@lsp.type.struct",         { link = "Structure" })
hi("@lsp.type.type",           { link = "Type" })
hi("@lsp.type.typeParameter",  { link = "Typedef" })
hi("@lsp.type.variable",       { link = "@variable" })
hi("@lsp.type.keyword",        { link = "@keyword" })
hi("@lsp.type.string",         { link = "@string" })
hi("@lsp.type.number",         { link = "Number" })
hi("@lsp.type.operator",       { link = "@operator" })
hi("@lsp.type.comment",        { link = "@comment" })

-- ── LSP diagnostics ──────────────────────────────────────────

hi("DiagnosticHint",           { fg = c.purple })
hi("DiagnosticError",          { fg = c.red })
hi("DiagnosticWarn",           { fg = c.yellow })
hi("DiagnosticInfo",           { fg = c.green })
hi("LspReferenceText",         { fg = c.darker_black, bg = c.white })
hi("LspReferenceRead",         { fg = c.darker_black, bg = c.white })
hi("LspReferenceWrite",        { fg = c.darker_black, bg = c.white })
hi("LspSignatureActiveParameter", { fg = c.black, bg = c.green })

-- ── Lazy.nvim ────────────────────────────────────────────────

hi("LazyH1",                   { fg = c.black, bg = c.green })
hi("LazyButton",               { fg = c.light_grey, bg = c.one_bg })
hi("LazyH2",                   { fg = c.red, bold = true, underline = true })
hi("LazyReasonPlugin",         { fg = c.red })
hi("LazyValue",                { fg = c.teal })
hi("LazyDir",                  { fg = b.base05 })
hi("LazyUrl",                  { fg = b.base05 })
hi("LazyCommit",               { fg = c.green })
hi("LazyNoCond",               { fg = c.red })
hi("LazySpecial",              { fg = c.blue })
hi("LazyReasonFt",             { fg = c.purple })
hi("LazyOperator",             { fg = c.white })
hi("LazyReasonKeys",           { fg = c.teal })
hi("LazyTaskOutput",           { fg = c.white })
hi("LazyCommitIssue",          { fg = c.pink })
hi("LazyReasonEvent",          { fg = c.yellow })
hi("LazyReasonStart",          { fg = c.white })
hi("LazyReasonRuntime",        { fg = c.nord_blue })
hi("LazyReasonCmd",            { fg = c.sun })
hi("LazyReasonSource",         { fg = c.cyan })
hi("LazyReasonImport",         { fg = c.white })
hi("LazyProgressDone",         { fg = c.green })

-- ── Git signs ────────────────────────────────────────────────

hi("GitSignsAdd",              { fg = c.green })
hi("GitSignsChange",           { fg = c.yellow })
hi("GitSignsDelete",           { fg = c.red })

-- ── nvim-cmp ─────────────────────────────────────────────────

hi("CmpPmenu",                 { bg = c.darker_black })
hi("CmpSel",                   { fg = c.black, bg = c.blue, bold = true })
hi("CmpBorder",                { fg = c.grey })
hi("CmpDoc",                   { bg = c.darker_black })
hi("CmpDocBorder",             { fg = c.grey })

-- ── Telescope ────────────────────────────────────────────────

hi("TelescopeNormal",          { bg = c.darker_black })
hi("TelescopeBorder",          { fg = c.grey })
hi("TelescopePromptBorder",    { fg = c.blue })
hi("TelescopePromptNormal",    { bg = c.darker_black })
hi("TelescopeResultsTitle",    { fg = c.black, bg = c.green })
hi("TelescopePromptTitle",     { fg = c.black, bg = c.blue })
hi("TelescopePreviewTitle",    { fg = c.black, bg = c.green })
hi("TelescopeSelection",       { fg = c.white, bg = c.one_bg })

-- ── NvimTree ─────────────────────────────────────────────────

hi("NvimTreeNormal",           { bg = c.darker_black })
hi("NvimTreeNormalNC",         { bg = c.darker_black })
hi("NvimTreeWinSeparator",     { fg = c.darker_black, bg = c.darker_black })
hi("NvimTreeCursorLine",       { bg = c.black2 })
hi("NvimTreeIndentMarker",     { fg = c.grey })
hi("NvimTreeGitNew",           { fg = c.green })
hi("NvimTreeGitDirty",         { fg = c.yellow })
hi("NvimTreeGitDeleted",       { fg = c.red })
hi("NvimTreeSpecialFile",      { fg = c.yellow })
hi("NvimTreeRootFolder",       { fg = c.red, bold = true })
hi("NvimTreeFolderIcon",       { fg = c.folder_bg })

-- ── Which-key ────────────────────────────────────────────────

hi("WhichKey",                 { fg = c.blue })
hi("WhichKeySeparator",        { fg = c.light_grey })
hi("WhichKeyDesc",             { fg = c.white })
hi("WhichKeyGroup",            { fg = c.green })
hi("WhichKeyValue",            { fg = c.green })
