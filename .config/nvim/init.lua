local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('mileszs/ack.vim')
Plug('neovim/nvim-lspconfig')
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-treesitter/nvim-treesitter')
Plug('cuducos/yaml.nvim')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-tree/nvim-web-devicons') -- Optional
Plug('nvim-lualine/lualine.nvim')
Plug('arkav/lualine-lsp-progress')
Plug('MeanderingProgrammer/render-markdown.nvim')
Plug('iamcco/markdown-preview.nvim')
Plug('tpope/vim-fugitive')
Plug("ray-x/go.nvim")
Plug("ray-x/guihua.lua") -- recommended if need floating window support
Plug("ray-x/aurora")
Plug("mfussenegger/nvim-dap")
Plug("nvim-neotest/nvim-nio")
Plug("rcarriga/nvim-dap-ui")
Plug("leoluz/nvim-dap-go")
Plug("theHamsta/nvim-dap-virtual-text")
Plug("nvim-lua/plenary.nvim")
Plug("antosha417/nvim-lsp-file-operations")
Plug("folke/snacks.nvim")
Plug("coder/claudecode.nvim")
Plug("Exafunction/windsurf.nvim")
Plug("onsails/lspkind.nvim")
Plug("rktjmp/lush.nvim")
Plug("zenbones-theme/zenbones.nvim")
Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = 'make' })
vim.call('plug#end')
vim.api.nvim_set_option("clipboard", "unnamed")
vim.g.ackprg = 'ag --vimgrep'
vim.opt.number = true
vim.o.exrc = true
vim.o.tabstop = 4

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
vim.cmd.colorscheme "aurora"

require("nvim-treesitter.configs").setup({
	ensure_installed = { "markdown", "markdown_inline", "go", "lua", "proto", "rust", "python", "yaml", "bash", "json", "hcl", "jsonnet" },
	incremental_selection = {
		enable = true,
		keymaps = {
			-- mappings for incremental selection (visual mappings)
			init_selection = "gnn", -- maps in normal mode to init the node/scope selection
			node_incremental = "grn", -- increment to the upper named parent
			scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
			node_decremental = "grm" -- decrement to the previous node
		},
	},
	textobjects = {
		enable = true,
		lsp_interop = {
			enable = true,
			peek_definition_code = {
				["Df"] = "@function.outer",
				["DF"] = "@class.outer"
			}

		},
		keymaps = {
			["iL"] = {
				-- you can define your own textobjects directly here
				go = "(function_definition) @function",
			},
			-- or you use the queries from supported languages with textobjects.scm
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["aC"] = "@class.outer",
			["iC"] = "@class.inner",
			["ac"] = "@conditional.outer",
			["ic"] = "@conditional.inner",
			["ae"] = "@block.outer",
			["ie"] = "@block.inner",
			["al"] = "@loop.outer",
			["il"] = "@loop.inner",
			["is"] = "@statement.inner",
			["as"] = "@statement.outer",
			["ad"] = "@comment.outer",
			["am"] = "@call.outer",
			["im"] = "@call.inner"
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer"
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer"
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer"
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer"
			}
		},
		select = {
			enable = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				-- Or you can define your own textobjects like this
				["iF"] = {
					python = "(function_definition) @function",
					cpp = "(function_definition) @function",
					c = "(function_definition) @function",
					java = "(method_declaration) @function",
					go = "(method_declaration) @function"
				}
			}
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner"
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner"
			}
		}
	},
})
-- empty setup using defaults
require("nvim-tree").setup({
	modified = {
		enable = true
	},
	renderer = {
		icons = {
			show = {
				modified = true,
			}
		}
	},
	update_focused_file = {
		enable = true,
	},
	filters = {
		custom = {
			"^.git$",
			"^bazel-bin",
			"^bazel-out",
			"^bazel-testlogs",
			"^bazel-dd-source",
		}
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
	},
})

local cmp = require 'cmp'
cmp.setup({
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
	}, {
		{ name = 'buffer' },
	}, {
		{ name = 'codeium' },
	}),
	formatting = {
		format = require('lspkind').cmp_format({
			mode = "symbol_text",
			maxwidth = 50,
			ellipsis_char = '...',
			symbol_map = { Codeium = "", }
		})
	}
})
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_file_operations = require("lsp-file-operations")
lsp_file_operations.setup()

-- Set global defaults for all servers
vim.lsp.config('*', {
	capabilities = vim.tbl_deep_extend(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		-- returns configured operations if setup() was already called
		-- or default operations if not
		lsp_file_operations.default_capabilities()
	)
}
)

vim.lsp.enable("gopls", true)

-- Setup Marksman LSP
vim.lsp.enable("marksman", true)

require 'lualine'.setup {
	extensions = { 'nvim-tree' },
	sections = {
		lualine_c = {
			{
				'filename',
				path = 1
			},
			'lsp_progress'
		}
	}
}

require 'nvim-dap-virtual-text'.setup()
require 'go'.setup({
	run_in_floaterm = true, -- set to false if you want to run in terminal
})
require 'dapui'.setup()
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		require('go.format').goimports()
	end,
	group = format_sync_grp,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.lua",
	callback = function()
		vim.lsp.buf.format()
	end,
})

require 'dap-go'.setup {
	dap_configurations = {
		{
			type = "go",
			name = "Attach remote",
			mode = "remote",
			request = "attach",
			port = 65293,
		},
	},
}

vim.lsp.config("protols", {
	root_markers = { ".clang-format", ".git" },
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.proto",
	callback = function()
		vim.lsp.buf.format()
	end,
})

local jsonls_capabilities = vim.lsp.protocol.make_client_capabilities()
jsonls_capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config("jsonls", {
	capabilities = jsonls_capabilities,
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.json",
	callback = function()
		vim.lsp.buf.format()
	end,
})

vim.keymap.set('n', '<space>r', ':lua vim.diagnostic.open_float(0, {scope="line"})<CR>')
vim.keymap.set('n', 'grr', ':lua vim.lsp.buf.references()<CR>')
vim.lsp.enable("lua_ls", true)
vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT'
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				}
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
				-- library = vim.api.nvim_get_runtime_file("", true)
			}
		})
	end,
	settings = {
		Lua = {}
	}
})

vim.lsp.enable('rust_analyzer', true)

require 'guihua'.setup({
	external = true, -- use external floating window
})

require 'claudecode'.setup({
	opts = {
		auto_start = true, -- automatically start the server
		terminal = {
			provider = "native",
		},
	},
	keys = {
		{ "<leader>a",  nil,                              desc = "AI/Claude Code" },
		{ "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                 desc = "Send to Claude" },
		{
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil" },
		},
		-- Diff management
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
	}
})

require 'codeium'.setup({
	enable_chat = true,
	virtual_text = {
		enabled = true
	}
})

vim.lsp.enable('terraformls', true)

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.tf", "*.tfvars" },
	callback = function()
		vim.lsp.buf.format()
	end,
})

require 'telescope'.setup()
require 'telescope'.load_extension('fzf')
