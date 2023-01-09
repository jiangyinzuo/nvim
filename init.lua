vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.wo.number = true
-- 高亮所在行
vim.wo.cursorline = true
-- 显示左侧图标指示列
vim.wo.signcolumn = "yes"
-- 右侧参考线，超过表示代码太长了，考虑换行
vim.wo.colorcolumn = "80"
-- 命令行高为2，提供足够的显示空间
vim.o.cmdheight = 2
-- 当文件被外部程序修改时，自动加载
vim.o.autoread = true
vim.bo.autoread = true
-- 禁止折行
vim.wo.wrap = false
-- 光标在行首尾时<Left><Right>可以跳到下一行
vim.o.whichwrap = "<,>,[,]"
-- 允许隐藏被修改过的buffer
vim.o.hidden = true
-- 鼠标支持
vim.o.mouse = "a"
-- 禁止创建备份文件
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
-- 自动补全不自动选中
vim.g.completeopt = "menu,menuone,noselect,noinsert"
-- 样式
vim.o.background = "dark"
vim.o.termguicolors = true
vim.opt.termguicolors = true
-- 补全增强
vim.o.wildmenu = true
-- Dont' pass messages to |ins-completin menu|
vim.o.shortmess = vim.o.shortmess .. "c"
-- 补全最多显示10行
vim.o.pumheight = 10
-- 使用增强状态栏插件后不再需要 vim 的模式提示
vim.o.showmode = false

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 新行对齐当前行
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
vim.cmd [[
augroup cpp
    autocmd!
    autocmd FileType cpp setlocal noexpandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup end
augroup python
    autocmd!
    autocmd FileType python setlocal noexpandtab tabstop=4
augroup end
augroup lua
    autocmd!
    autocmd FileType lua setlocal noexpandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup end
]]

require("packer").startup(function()
	use "wbthomason/packer.nvim" -- Package manager
	use { "williamboman/mason.nvim" }

	use "folke/tokyonight.nvim"
	use { "catppuccin/nvim", as = "catppuccin" }
	use 'Mofiqul/vscode.nvim'

	use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
	use { "nvim-tree/nvim-tree.lua", requires = "nvim-tree/nvim-web-devicons" }

	use { "akinsho/bufferline.nvim", tag = "v3.*", requires = { "nvim-tree/nvim-web-devicons", "moll/vim-bbye" } }
	use { "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons" } }

	use {
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = { { "nvim-lua/plenary.nvim" } },
	}

	use "neovim/nvim-lspconfig" -- Configurations for Nvim LSP
	use "p00f/clangd_extensions.nvim"
	-- 补全引擎
	use "hrsh7th/nvim-cmp"
	-- snippet 引擎
	use "hrsh7th/vim-vsnip"
	-- 补全源
	use "hrsh7th/cmp-vsnip"
	use "hrsh7th/cmp-nvim-lsp" -- { name = nvim_lsp }
	use "hrsh7th/cmp-buffer" -- { name = 'buffer' },
	use "hrsh7th/cmp-path" -- { name = 'path' }
	use "hrsh7th/cmp-cmdline" -- { name = 'cmdline' }
	-- 常见编程语言代码段
	use "rafamadriz/friendly-snippets"

	use "lukas-reineke/indent-blankline.nvim"
	use { "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" }

	use { "akinsho/toggleterm.nvim", tag = '*', config = function()
		require("toggleterm").setup()
	end }

	use { "glepnir/dashboard-nvim" }

	git = {
		-- default_url_format = 'https://gitclone.com/github.com/%s'
		-- default_url_format = 'https://hub.fastgit.xyz/%s'
	}
end)

vim.cmd [[
	colorscheme vscode
]]

require("nvim-treesitter.configs").setup {
	-- 安装 language parser
	-- :TSInstallInfo 命令查看支持的语言
	ensure_installed = { "cpp", "lua", "vim" },
	-- 启用代码高亮模块
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()
-- auto close
vim.cmd([[
  autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])
vim.keymap.set("n", "<leader>tree", ":NvimTreeToggle<CR>", { noremap = true })

require("bufferline").setup {
	-- 侧边栏配置
	-- 左侧让出 nvim-tree 的位置，显示文字 File Explorer
	options = {
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				highlight = "Directory",
				text_align = "left",
			},
		},
	},
}
require("lualine").setup {}
local telescope = require("telescope")
telescope.setup {}

-- Telescope
-- 查找文件
vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { noremap = true })
-- 全局搜索
vim.keymap.set("n", "<C-f>", ":Telescope live_grep<CR>", { noremap = true })
vim.keymap.set("n", "<C-h>", ":Telescope oldfiles<CR>", { noremap = true })

require("mason").setup {
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
	github = {
		-- The template URL to use when downloading assets from GitHub.
		-- The placeholders are the following (in order):
		-- 1. The repository (e.g. "rust-lang/rust-analyzer")
		-- 2. The release version (e.g. "v0.3.0")
		-- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
		download_url_template = "https://cors.isteed.cc/github.com/%s/releases/download/%s/%s",
	},
}

require "lsp"
vim.cmd [[autocmd Filetype c,cpp packadd termdebug]]
vim.g.termdebug_wide = 1

vim.keymap.set("n", "<leader>git", "<cmd>lua require('terminal').git_client_toggle()<CR>", { noremap = true })

local db = require('dashboard')
-- https://lachlanarthur.github.io/Braille-ASCII-Art/
db.custom_header = {
	--	'⠉⠈⠁⠉⠈⠁⠉⠁⠉⠈⠁⠉⠈⠁⠉⠈⠁⠉⠈⠁⠉⠈⠁⠉⠈⠁⠉⠈⠁⠉⠈⠁⠉⠈⠉⠈⠁⠉⠈⠁⠉⠁⠉⠈⠁⠉⠁⠉⠈⠁⠉⠈⠁⠉⠈⣥⣭⣥⣭⣬',
	'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿',
	'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⢿⣿⣿⣿',
	'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣸⣿⣿⣿',
	'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢺⢰⣿⣿⣿',
	'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢺⠡⣿⣿⣿',
	'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠅⣿⣿⣿',
	'⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡌⠀⠀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⢹⠂⣿⣿⣿',
	'⠀⠀⠀⠀⠀⠀⠀⡗⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡐⠀⠀⠀⠀⠀⡘⠀⠀⣰⡇⠀⠀⠀⣰⠁⢀⠄⠀⠀⠀⠀⠼⠀⠀⠀⠀⠀⠀⠀⠸⠁⣿⣿⣿',
	'⠀⠀⠀⠀⠀⠀⣰⠃⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⣀⣀⡁⠀⠀⡴⠃⢀⡈⠀⢀⠀⠀⣤⣤⠀⠀⠀⠀⠀⠀⠀⡆⢱⣿⣿⣿',
	'⠀⠀⠀⠀⠀⠀⡌⣸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⠀⣀⡴⠂⠜⢀⡠⠾⢿⣿⠁⠀⣊⠅⢠⠞⠀⡴⠁⣀⣾⡿⡟⠀⠀⠀⠀⠀⠀⠀⡗⢸⣿⣿⣿',
	'⠀⠀⠀⠀⡄⠠⢁⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣯⡴⡤⠶⢭⠿⡽⣯⣖⣶⣿⣯⢐⣋⣴⡿⣱⠾⠷⠒⠚⠁⠀⠀⠀⠀⠀⠀⠀⠃⢺⣿⣿⣿',
	'⠀⠀⠀⠀⠀⠀⣼⠆⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⣯⣤⣴⡄⠀⠀⠀⠀⣤⣨⣽⣿⣿⣿⣿⣿⣓⣯⡄⠀⠀⣠⠿⠀⠀⠀⠀⠀⠀⠀⢠⢻⣿⣿⣿',
	'⠀⠀⠀⠀⠀⢸⢿⠃⠀⠀⠀⠀⠀⠀⠀⢰⡇⠀⠀⠀⠀⠀⠀⠀⠰⢹⣿⣙⡧⢤⡤⣤⢦⢟⣻⣿⣿⣿⣿⣿⣿⡬⣿⣖⣰⣤⢭⡔⠀⠀⠀⠀⠀⠀⠀⢸⢺⣿⣿⣿',
	'⠀⠀⠀⠀⠀⣻⡇⠀⠀⠀⠀⠀⡌⠀⠀⣾⡇⠀⠀⠀⠀⠀⠀⠀⠘⡼⣿⣿⣿⣾⣷⣾⣷⣿⣿⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⢠⢸⣸⣿⣿⣿',
	'⠀⠀⠀⠀⢰⡿⠀⠀⠀⠀⠀⡄⠀⠀⣰⣿⡇⠀⠀⠀⠀⠀⠀⠀⠄⣛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⢸⡂⢼⣿⣿⣿',
	'⠀⠀⠀⢀⣾⠁⠂⠀⠀⠠⠌⠀⠀⢠⣿⣿⡷⠀⠀⠀⠀⠀⠀⠀⠀⡇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡜⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⢸⡅⢸⣿⣿⣿',
	'⠀⠀⢀⡾⠃⠀⠀⠀⠔⠁⠀⠀⢠⡜⣿⣿⣯⢡⠀⠀⠀⠀⠀⠀⠀⡅⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢻⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡃⢼⣿⣿⣿',
	'⢀⣴⣿⠁⠀⠀⠀⠀⢀⠄⢀⢎⣾⣿⣌⢿⣿⠰⠀⠀⠀⠀⠀⠀⠀⠔⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠿⣿⠿⠈⠀⠀⡌⠀⠀⡀⠀⠀⠀⠀⢸⠁⣿⣿⣿⣿',
	'⠈⠯⠀⠀⠀⢀⣠⠆⠁⡸⢃⣾⣿⣿⣿⣦⠻⡇⡃⠀⠀⠀⠀⠀⠀⢊⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣷⠗⠀⠀⢀⡴⠀⠀⡐⠄⠀⠀⠀⠀⣸⠠⣿⣿⣿⣿',
	'⠈⣁⣠⣤⠶⠋⠁⣠⠘⣵⣿⣿⣿⣿⣿⣿⣷⣄⠡⠀⠀⠀⠀⠀⠀⢹⢸⣿⣿⣿⣿⣿⣿⠿⠿⠿⢻⣛⣻⡿⠉⠀⠀⠠⠞⠀⢀⠆⣜⠆⠀⠀⠀⠀⡞⢸⣿⣿⣿⣿',
	'⠈⠉⠁⠀⢀⣀⣮⣴⡎⣿⣿⣿⣿⣿⣿⣿⣿⣿⠰⠀⠀⠀⠀⠀⠀⡸⢸⣿⣿⣿⣿⣯⣤⣄⣤⣠⣴⣿⠋⠀⠀⠀⡠⠀⠀⠴⠃⡸⢪⠄⠀⠀⠀⠠⠇⣿⣿⣿⣿⣿',
	'⢈⣿⣿⣿⣿⣿⣷⣽⣳⣍⠿⣿⣿⣿⣿⣿⣿⣿⡇⠆⠀⠀⠀⠀⠀⢱⢸⣿⣿⣿⣿⣟⣹⣛⣋⣿⠍⣄⠀⣀⣀⣤⠰⠞⠉⣠⠚⣵⣿⠀⠀⠀⠀⠘⢠⣿⣿⣿⣿⣿',
	'⢈⣿⣿⣿⣿⣿⣿⣿⣧⡛⢷⣌⠿⣿⣿⣿⣿⣿⣇⢨⠀⠀⠀⠀⠀⡄⣙⠿⢿⣿⣿⣿⣿⣿⡿⢋⣾⣷⣀⣉⣉⡀⢠⣒⣡⢶⣿⣌⠗⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿',
	'⢈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⡻⣷⣬⠻⣿⣿⣿⣿⢀⠀⠀⠀⠀⠀⡆⢟⣣⣦⣭⣙⣛⣛⡯⣵⣿⢻⣿⢧⣿⣿⣏⡧⣿⣿⡸⣿⣿⠃⠀⠀⠀⢀⢆⣿⣿⣿⣿⣿⣿',
	'⢈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣮⣛⢿⣬⡛⣿⣿⡆⠆⠀⠀⠀⠀⡄⢺⣟⣻⣿⣿⣿⣿⡇⢻⣿⡇⣿⢭⣿⣿⢸⣷⢹⣿⣧⢻⡇⠀⠀⠀⠀⠌⣼⣿⣿⣿⣿⣿⣿',
	'⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡙⠇⢣⠀⠀⠀⢰⠃⣼⡿⣾⣿⣿⣿⣿⡇⣚⢿⣿⣸⢽⣿⡇⢻⣿⣜⣿⣿⡘⠀⠀⠀⠀⢀⡸⢿⣿⣿⣿⣿⣿⣿',
	'⠈⣧⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠈⡀⠀⠀⠸⢀⣟⣿⣿⣿⣿⣿⣿⡷⢸⡞⣿⡞⣼⣿⣸⣏⣿⣿⣿⣿⠁⠀⠀⠀⢀⢿⣿⣎⢻⣿⣿⣿⣿⣿',
	'⠰⡸⣧⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⡁⠀⠀⠒⣸⣿⣿⣿⣿⣿⣿⣿⡷⢸⣹⡼⣷⢸⡇⣿⡎⣿⣿⣿⠃⠀⠀⠀⣠⢿⣧⡻⣿⣷⡙⢿⣿⣿⣿',
	'⠀⣷⢻⣧⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⡄⢃⠀⠀⡇⣬⡛⢿⣿⣿⣿⣿⣿⣟⢸⣧⢷⡹⡿⣼⣾⣭⣿⣿⠃⠀⠀⣠⡘⣿⣟⣿⣷⡞⢿⣿⣮⠻⣿⢙',
	'⠰⡜⣏⢿⣷⡹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢃⣾⣷⠈⡄⢰⢡⢿⣿⢢⡹⣿⣿⣿⣿⣟⢸⣿⡜⣷⡽⣿⣿⣿⡽⢁⠂⡬⣶⣿⣷⢻⣿⣼⣿⣿⡜⣷⠝⣣⣶⣿',
}
db.custom_center = {
	{ icon = '  ',
		desc = 'Recently opened files',
		action = 'Telescope oldfiles',
	},
	{ icon = '  ',
		desc = 'Find File            ',
		action = 'Telescope find_files find_command=rg,--hidden,--files',
	},
}
db.custom_footer = {}
vim.cmd [[
" Commenting blocks of code.
augroup commenting_blocks_of_code
  autocmd!
  autocmd FileType c,cpp,java,scala                      let b:comment_leader = '// '
  autocmd FileType sh,ruby,python,conf,fstab,gitconfig   let b:comment_leader = '# '
  autocmd FileType tex                                   let b:comment_leader = '% '
  autocmd FileType mail                                  let b:comment_leader = '> '
  autocmd FileType vim                                   let b:comment_leader = '" '
  autocmd FileType lua                                   let b:comment_leader = '-- '
augroup END

" a sed (s/what/towhat/where) command changing ^ (start of line) to the correctly set comment character based on the type of file you have opened
" as for the silent thingies they just suppress output from commands.
" :nohlsearch stops it from highlighting the sed search
noremap <silent> <space>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> <space>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
]]

vim.cmd [[
	set foldmethod=expr
	set foldexpr=nvim_treesitter#foldexpr()
	set nofoldenable
]]
