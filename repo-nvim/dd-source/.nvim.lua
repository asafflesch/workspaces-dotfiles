vim.lsp.config("gopls", {
	cmd = { "dd-gopls", "-remote=auto", "-logfile=auto" },
	cmd_env = {
		GOPACKAGESDRIVER = vim.fn.getcwd() .. "/tools/go/gopackagesdriver.sh",
		BUILD_WORKSPACE_DIRECTORY = vim.fn.getcwd(),
		GOPACKAGESDRIVER_BAZEL = "bzl",
		GOPLS_DISABLE_MODULE_LOADS = "1",
	},
	settings = {
		gopls = {
			workspaceFiles = {
				"**/BUILD",
				"**/WORKSPACE",
				"**/*.{bzl,bazel}",
			},
			directoryFilters = {
				"-**/bazel-bin",
				"-**/bazel-out",
				"-**/bazel-testlogs",
				"-**/bazel-dd-source",
			},
			env = {
				GOPACKAGESDRIVER = vim.fn.getcwd() .. "/tools/go/gopackagesdriver.sh",
				BUILD_WORKSPACE_DIRECTORY = vim.fn.getcwd(),
				GOPACKAGESDRIVER_BAZEL = "bzl",
				GOPLS_DISABLE_MODULE_LOADS = "1",
			},
			["local"] = "github.com/DataDog/dd-source",
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
			codelenses = {
				generate = false,
				test = false,
				tidy = false,
				upgrade_dependency = false,
				vendor = false
			}
		},
	},
})
