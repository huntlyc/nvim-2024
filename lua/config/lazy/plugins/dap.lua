return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = { "williamboman/mason.nvim" },
                opts = {
                    ensure_installed = { "codelldb" },
                    handlers = {
                        function(config)
                            require("mason-nvim-dap").default_setup(config)
                        end,
                    },
                },
            },
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
                config = function()
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup()

                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open()
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close()
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close()
                    end
                end,
            },
        },
        config = function()
            local dap = require("dap")

            dap.configurations.rust = {
                {
                    name = "Launch",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                },
            }
        end,
        keys = {
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "[d]ebug toggle [b]reakpoint" },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "[d]ebug conditional [b]reakpoint" },
            { "<leader>dc", function() require("dap").continue() end, desc = "[d]ebug [c]ontinue" },
            { "<leader>di", function() require("dap").step_into() end, desc = "[d]ebug step [i]nto" },
            { "<leader>do", function() require("dap").step_over() end, desc = "[d]ebug step [o]ver" },
            { "<leader>dO", function() require("dap").step_out() end, desc = "[d]ebug step [O]ut" },
            { "<leader>dr", function() require("dap").restart() end, desc = "[d]ebug [r]estart" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "[d]ebug [t]erminate" },
            { "<leader>du", function() require("dapui").toggle() end, desc = "[d]ebug toggle [u]i" },
        },
    },
}
