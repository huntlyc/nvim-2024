-- lua/config/lsp.lua (for example)

local lsp_format_on_save = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({
                    bufnr = bufnr,
                    filter = function(c)
                        return c.id == client.id
                    end,
                })
            end,
        })
    end
end

local go_to_test = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    local is_test_file = current_file:match("_test%.go$")

    if is_test_file then
        -- We're in a test file, go to the corresponding source file
        local source_file = current_file:gsub("_test%.go$", ".go")

        if vim.fn.filereadable(source_file) == 0 then
            print("Source file not found: " .. source_file)
            return
        end

        -- Get current test function name to find corresponding function
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1
        local col = cursor[2]

        local parser = vim.treesitter.get_parser(0, "go")
        local tree = parser:parse()[1]
        local root = tree:root()
        local current_node = root:descendant_for_range(row, col, row, col)

        local test_func_name = nil
        while current_node do
            if current_node:type() == "function_declaration" then
                local name_node = current_node:child(1)
                if name_node then
                    local func_name = vim.treesitter.get_node_text(name_node, 0)
                    if func_name:match("^Test") then
                        test_func_name = func_name
                        break
                    end
                end
            end
            current_node = current_node:parent()
        end

        -- Open source file in vertical split
        vim.cmd("vsplit " .. source_file)

        if test_func_name then
            -- Extract function name from test name
            local target_func = test_func_name:gsub("^Test_?", ""):gsub("^Unit_?", "")

            -- Search for the function in the source file
            vim.cmd("/" .. target_func)
            print("Opened source file in split, searching for: " .. target_func)
        else
            print("Opened source file in split: " .. source_file)
        end
    else
        -- We're in a source file, go to corresponding test
        local base_name = current_file:gsub("%.go$", "")
        local test_file = base_name .. "_test.go"

        -- Check if test file exists
        if vim.fn.filereadable(test_file) == 0 then
            print("Test file not found: " .. test_file)
            return
        end

        -- Get current function name
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1
        local col = cursor[2]

        local parser = vim.treesitter.get_parser(0, "go")
        local tree = parser:parse()[1]
        local root = tree:root()
        local current_node = root:descendant_for_range(row, col, row, col)

        local current_func_name = nil
        while current_node do
            if current_node:type() == "function_declaration" then
                local name_node = current_node:child(1)
                if name_node then
                    current_func_name = vim.treesitter.get_node_text(name_node, 0)
                    break
                end
            end
            current_node = current_node:parent()
        end

        -- Open test file in vertical split
        vim.cmd("vsplit " .. test_file)

        if current_func_name then
            -- Convert function name and search for test
            local capitalized_name = current_func_name:gsub("^%l", string.upper)
            local possible_test_names = {
                "Test" .. capitalized_name,
                "Test_" .. capitalized_name,
                "TestUnit_" .. capitalized_name,
            }

            -- Try to find and jump to the test function
            for _, test_name in ipairs(possible_test_names) do
                local search_result = vim.fn.search("func\\s\\+" .. test_name .. "\\s*(", "w")
                if search_result > 0 then
                    print("Found test in split: " .. test_name)
                    return
                end
            end

            print("Opened test file in split, but no test found for: " .. current_func_name)
        else
            print("Opened test file in split: " .. test_file)
        end
    end
end

local run_current_or_corresponding_test = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    local is_test_file = current_file:match("_test%.go$")

    if is_test_file then
        -- We're in a test file, run current test function
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1
        local col = cursor[2]

        local parser = vim.treesitter.get_parser(0, "go")
        if parser == nil then
            print("Could not create parser! run_current_or_corresponding_test in lsp-config.lua")
            return
        end
        local tree = parser:parse()[1]
        local root = tree:root()
        local current_node = root:descendant_for_range(row, col, row, col)

        while current_node do
            if current_node:type() == "function_declaration" then
                local name_node = current_node:child(1)
                if name_node then
                    local func_name = vim.treesitter.get_node_text(name_node, 0)
                    if func_name:match("^Test") then
                        vim.cmd("!go test -run " .. func_name .. " -v")
                        return
                    end
                end
            end
            current_node = current_node:parent()
        end
        print("Not in a test function")
    else
        -- We're in a regular .go file, find corresponding test
        local base_name = current_file:gsub("%.go$", "")
        local test_file = base_name .. "_test.go"

        -- Check if test file exists
        if vim.fn.filereadable(test_file) == 0 then
            print("No test file found: " .. test_file)
            return
        end

        -- Get current function name
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1
        local col = cursor[2]

        local parser = vim.treesitter.get_parser(0, "go")
        local tree = parser:parse()[1]
        local root = tree:root()
        local current_node = root:descendant_for_range(row, col, row, col)

        local current_func_name = nil
        while current_node do
            if current_node:type() == "function_declaration" then
                local name_node = current_node:child(1)
                if name_node then
                    current_func_name = vim.treesitter.get_node_text(name_node, 0)
                    break
                end
            end
            current_node = current_node:parent()
        end

        if not current_func_name then
            print("Not in a function")
            return
        end

        -- Convert function name to proper test case
        -- myFunc -> MyFunc, calculateSum -> CalculateSum
        local capitalized_name = current_func_name:gsub("^%l", string.upper)

        -- Look for Test + capitalized function name in test file
        local possible_test_names = {
            "Test" .. capitalized_name,
            "Test_" .. capitalized_name,
            "TestUnit_" .. capitalized_name,
        }

        print("Looking for tests for function: " .. current_func_name .. " (as " .. capitalized_name .. ")")

        -- Read test file and look for matching test
        local test_content = vim.fn.readfile(test_file)
        local found_test = nil

        for _, line in ipairs(test_content) do
            for _, test_name in ipairs(possible_test_names) do
                if line:match("func%s+" .. test_name .. "%s*%(") then
                    found_test = test_name
                    break
                end
            end
            if found_test then
                break
            end
        end

        if found_test then
            print("Running test: " .. found_test)
            vim.cmd("!go test -run " .. found_test .. " -v")
        else
            print("No test found for function: " .. current_func_name)
            print("Looked for: " .. table.concat(possible_test_names, ", "))
        end
    end
end

-- Then in your lsp_keymaps function:
local lsp_keymaps = function(bufnr)
    local keymap = vim.keymap.set
    local opts = { buffer = bufnr, silent = true, noremap = true }

    keymap("n", "K", vim.lsp.buf.hover, opts)
    keymap("n", "<leader>tr", run_current_or_corresponding_test, opts)
    keymap("n", "<leader>gtt", go_to_test, opts)
    keymap("n", "<leader>gg", vim.diagnostic.open_float, opts)
    keymap("n", "<leader>gd", vim.lsp.buf.definition, opts)
    keymap("n", "<leader>gt", vim.lsp.buf.type_definition, opts)
    keymap("n", "<leader>gi", vim.lsp.buf.implementation, opts)
    keymap("n", "<leader>gr", vim.lsp.buf.rename, opts)
    keymap("n", "<leader>gb", function()
        vim.diagnostic.jump({ count = 1, float = true })
    end, opts)
    keymap("n", "<leader>gp", function()
        vim.diagnostic.jump({ count = -1, float = true })
    end, opts)
    keymap("n", "<leader>gtr", "<cmd>Telescope lsp_references<CR>", opts)
    keymap("n", "<leader>gl", "<cmd>Telescope diagnostics<CR>", opts)
    keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        lsp_keymaps(bufnr)
        lsp_format_on_save(client, bufnr)
    end,
})

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "saghen/blink.cmp",
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
        config = function()
            vim.diagnostic.config({
                virtual_text = true, -- Shows error text inline
                signs = true, -- Keep your gutter signs
                underline = true, -- Underline problematic code
                update_in_insert = false,
                severity_sort = true, -- Sort by severity
                float = {
                    border = "rounded",
                    source = "always", -- Show source in floating windows
                },
            })
        end,
    },
}
