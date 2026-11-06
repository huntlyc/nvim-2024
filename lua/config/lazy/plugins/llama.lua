return {
    {
        'ggml-org/llama.vim',
        commit = 'e1ca1cc6af9da73f4ae21f810f33909d515592e6',
        -- Enabled by default. Use NVIM_LOCAL_AI=0 nvim for an AI-free process.
        cond = vim.env.NVIM_LOCAL_AI ~= '0',
        init = function()
            local keyfile = vim.fn.expand('~/.local/share/llama.cpp/server.key')
            local key = vim.fn.filereadable(keyfile) == 1 and vim.fn.readfile(keyfile)[1] or ''
            vim.g.llama_config = {
                endpoint_fim = 'http://127.0.0.1:8012/infill',
                api_key = key,
                n_prefix = 64,
                n_suffix = 16,
                n_predict = 48,
                n_cmpl = 1,
                t_max_predict_ms = 1000,
                fim_debounce_ms = 200,
                max_cache_keys = 64,
                show_info = 0,
                info_compact = 1,
                auto_fim = true,
                enable_at_startup = true,
                -- Do not collect other buffers or yanked text as extra context.
                ring_n_chunks = 0,
                -- Tab accepts a visible hint; otherwise blink/snippets handle it.
                -- Leave Shift-Tab and Ctrl keys unchanged.
                keymap_fim_trigger = '<leader>llf',
                keymap_fim_accept_full = '<Tab>',
                keymap_fim_accept_line = '<leader>lll',
                keymap_fim_accept_word = '<leader>llw',
                keymap_fim_next = '',
                keymap_fim_prev = '',
                -- This is a base completion model, not an instruction/chat model.
                endpoint_inst = '',
                keymap_inst_trigger = '',
                keymap_inst_rerun = '',
                keymap_inst_continue = '',
                keymap_inst_accept = '',
                keymap_inst_cancel = '',
                keymap_debug_toggle = '',
            }
        end,
        config = function()
            -- Ghost styling lives in Catppuccin's custom_highlights so theme
            -- setup on VimEnter/FocusGained cannot clear a separate override.
            -- These are session UI controls, not a privacy boundary.
            vim.keymap.set('n', '<leader>llt', '<cmd>LlamaToggle<CR>', { desc = 'Toggle local AI completion' })
            vim.keymap.set('n', '<leader>llA', '<cmd>LlamaToggleAutoFim<CR>', { desc = 'Toggle automatic local AI' })
        end,
    },
}
