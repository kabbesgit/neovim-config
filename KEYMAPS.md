# Keymap Swifty Cheat Sheet

Leader is `Space`.

## Navigation, Buffers, Windows
- `<C-u>`, `<C-d>`: Page up/down and recenter; `j/k`: respect wrapped lines.
- `<S-h>`, `<S-l>`: Prev/next buffer; `<leader>bp`: Toggle pin; `<leader>bP`: Close unpinned; `<leader>bo`: Close other buffers; `<leader>bd`: Delete buffer (Snacks).
- `<leader>wsh` / `<leader>wsv`: Split horizontal/vertical; `<leader>wse`: Equalize; `<leader>wx`: Close split.
- `<leader>fw`: Write file; `<leader>qq`: Quit all; `<leader>nh`: Clear search highlight.
- `<leader>e`: Toggle Neo-tree file explorer; `<leader>.` / `<leader>S`: Scratch buffer toggle/select (Snacks).
- `<leader>u`: Toggle undotree panel.

## Search & Pickers
- Telescope: `<leader>sf`: Find files (root); `<leader>sF`: Find files (LSP/package root); `<leader>sh`: Help tags; `<leader>sw`: Word under cursor; `<leader>sg`/`<leader>sG`: Live grep (root/package); `<leader>sd`: Diagnostics.
- Snacks picker: `<leader>ff`: Files; `<leader>fg`: Git files; `<leader>fr`: Recent; `<leader>sb`: Buffer lines; `<leader>sB`: Grep open buffers; `<leader>sg`: Grep (cwd); `<leader>sw`: Grep word/visual.
- Reference hops: `]]` / `[[`: Next/prev reference (works in terminal mode too).

## Harpoon (quick navigation)
- `<leader>a`: Add mark; `<C-e>`: Toggle quick menu.
- `<C-1>`..`<C-4>` and `<leader>1`..`<leader>8`: Jump to slot.
- `<leader>fa` / `<leader>af`: Prev/next mark; `<leader>ch`: Clear all harpoon marks.

## Editing Helpers
- Comments (Comment.nvim): `gc` (toggle in normal/visual), `gcc` (line), `gb`/`gbc` (block).
- Surround (mini.surround): `gsa` add, `gsd` delete, `gsr` replace, `gsh` highlight, `gsf`/`gsF` find, `gsn` update range (`l`/`n` suffixes hop last/next).
- Flash jump: `s` (jump), `S` (treesitter jump), `r` (operator-pending remote), `R` (treesitter search), `<C-s>` (toggle search from command-line).
- Switch case: `<leader>sc` switches the identifier under cursor.
- Copilot: `<S-Tab>` accept suggestion, `<C-n>` dismiss.
- Flashy navigation: `<leader>.` toggle scratch buffer, `<leader>S` select scratch (Snacks).

## Git
- Hunk nav: `[c` / `]c` previous/next hunk (respects diff mode).
- Gitsigns actions: `<leader>hs`/`hr` stage/reset hunk (works in visual); `<leader>hS`: Stage buffer; `<leader>hu`: Undo stage; `<leader>hR`: Reset buffer; `<leader>hp`: Preview hunk; `<leader>hb`: Blame line; `<leader>tb`: Toggle line blame; `<leader>hd`/`hD`: Diff this/against HEAD; `<leader>td`: Toggle deleted; Text object: `ih` in operator/visual selects hunk.
- Snacks git tools: `<leader>gg`: Lazygit; `<leader>gl`: Lazygit log; `<leader>gf`: Lazygit file log; `<leader>gc`: Git log picker; `<leader>gs`: Git status picker; `<leader>gB`: Open in browser; `<leader>gb`: Blame line (Snacks).

## LSP, Diagnostics, Trouble
- Diagnostics: `<leader>cd`: Floating diagnostic; `<leader>q`: Populate loclist; `<leader>dx`: Trouble; `<leader>dw`: Workspace diagnostics; `<leader>dq`: Quickfix view; `gR`: LSP references via Trouble.
- Trouble (built-in mappings): `<leader>xx`: Diagnostics; `<leader>xX`: Buffer diagnostics; `<leader>cs`: Symbols; `<leader>cl`: LSP definitions/refs; `<leader>xL`: Location list; `<leader>xQ`: Quickfix list.
- LSP buffer maps (on attach): `<leader>cr`: Rename; `<leader>ca`: Code action; `gd` / `<leader>gd`: Goto definition; `<leader>cth`: Toggle inlay hints.
- Snacks LSP pickers (global): `gd`: Definitions, `gr`: References, `gI`: Implementations, `gy`: Type definitions, `<leader>ss`: Workspace symbols.
- Linting: `<leader>l`: Run configured linters.

## Formatting & Code Quality
- `<leader>f`: Format buffer via Conform.
- `<leader>tf`: Toggle auto-formatting for current buffer; `:ToggleAutoFormat` (global) / `:ToggleAutoFormat!` (buffer) commands also available.

## Toggles & UI (Snacks)
- `<leader>z`: Zen mode; `<leader>Z`: Zoom window; `<leader>n`: Notification history; `<leader>un`: Dismiss notifications.
- `<leader>bd`: Delete buffer; `<leader>bo`: Delete other buffers.
- `<leader>cR`: Rename file.
- `<leader>gB`: Git browse current line.
- `<c-/>` or `<c-_>`: Toggle terminal.
- Options toggles: `<leader>us` spell, `<leader>uw` wrap, `<leader>uL` relative number, `<leader>ud` diagnostics, `<leader>ul` line numbers, `<leader>uc` conceal, `<leader>uT` treesitter, `<leader>ub` background dark/light, `<leader>uh` inlay hints.

## Treesitter
- Incremental selection: `<C-space>` start/expand; `<bs>` shrink.
- Textobjects select: `a=`/`i=`/`l=`/`r=` assignments; `aa`/`ia` params; `ai`/`ii` conditionals; `al`/`il` loops; `af`/`if` call; `am`/`im` function; `ac`/`ic` class.
- Textobject motion: `]f`/`[f` call start; `]F`/`[F` call end; `]m`/`[m` function start; `]M`/`[M` function end; `]c`/`[c` class start; `]C`/`[C` class end; `]i`/`[i` conditional start; `]I`/`[I` conditional end; `]l`/`[l` loop start; `]L`/`[L` loop end; `]s` next scope; `]z` next fold.

## File Notes (Fusen)
- `me`: Add/edit sticky note; `mc`: Clear mark; `mC`: Clear all in buffer; `mD`: Clear all marks; `mn`/`mp`: Next/prev mark; `ml`: List marks.
- Telescope inside Fusen: `<C-d>` deletes a mark (normal/insert).

## Completion & AI
- Blink.nvim preset uses Enter-based confirm (default preset); Copilot maps listed above.

## Build & Test (Apple/Xcode)
- `<leader>X`: Xcodebuild action picker; `<leader>xf`: Project manager actions.
- Build: `<leader>xb`: Build; `<leader>xB`: Build for testing; `<leader>xr`: Build & run.
- Tests: `<leader>xt` (file/selection), visual `<leader>xt` (selected), `<leader>xT`: Current test class; `<leader>x.`: Repeat last test; `<leader>xs`: Failing snapshots; `<leader>xe`: Toggle test explorer.
- Logs & coverage: `<leader>xl`: Toggle logs; `<leader>xc`: Toggle coverage; `<leader>xC`: Coverage report.
- Previews/devices: `<leader>xp`: Generate preview; `<leader>x<CR>`: Toggle preview; `<leader>xd`: Select device.
- Quickfix: `<leader>xq`: Telescope quickfix; `<leader>xx`: Quickfix current line; `<leader>xa`: Code actions (Xcodebuild).

## Debugging
- Xcodebuild DAP helpers: `<leader>dd`: Build & debug; `<leader>dg`: Debug without build; `<leader>dy`: Debug tests; `<leader>dY`: Debug class tests; `<leader>b`: Toggle breakpoint; `<leader>B`: Message breakpoint; `<leader>df`: Terminate debugger.
- Core DAP (lazy-loaded): `<leader>db`: Toggle breakpoint; `<leader>dB`: Conditional breakpoint; `<leader>dc`: Continue; `<leader>dC`: Run to cursor; `<leader>ds`/`di`/`do`: Step over/into/out; `<leader>dr`: Restart; `<leader>dt`: Terminate; `<leader>du`: Toggle DAP UI; `<leader>de` (normal/visual): Evaluate; `<leader>dv`: Toggle virtual text.
- Function keys: `<F5>` continue/start, `<F9>` toggle breakpoint, `<F10>` step over, `<F11>` step into, `<S-F11>` step out, `<S-F5>` restart, `<C-F5>` stop.
- Go buffers: `<leader>td` debug nearest test, `<leader>tD` debug last test (may shadow gitsigns toggle-deleted in Go files).

## Formatting, Linting, Misc
- `<leader>l`: Run linters (ruff/swiftlint/cspell per filetype).
- `<leader>fw`: Write file; `<leader>f`: Format; `<leader>tf`: Toggle autoformat buffer.
- `<leader>nh`: Clear highlights; `<leader>cd`: Diagnostic float; `<leader>q`: Diagnostics list.
