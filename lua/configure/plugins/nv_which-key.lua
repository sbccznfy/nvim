-- https://github.com/folke/which-key.nvim

local M = {
    safe_requires = {
        { "which-key", "wk" },
    },
}

function M.before() end

function M.load()
    -- FIX: https://github.com/folke/which-key.nvim/issues/273
    local show = M.wk.show

    M.wk.show = function(keys, opts)
        if vim.bo.filetype == "TelescopePrompt" then
            local map = "<c-r>"
            local key = vim.api.nvim_replace_termcodes(map, true, false, true)
            vim.api.nvim_feedkeys(key, "i", true)
        end
        show(keys, opts)
    end

    M.wk.setup({
        plugins = {
            spelling = {
                enabled = true,
                suggestions = 20,
            },
        },
        icons = {
            breadcrumb = " ",
            separator = " ",
            group = " ",
        },
    })
end

function M.after()
    -- global leader
    M.wk.register({
        b = { name = "Buffers" },
        c = { name = "Code" },
        d = { name = "Debug" },
        f = { name = "Find" },
        g = { name = "Git" },
        r = { name = "Replace", w = "Replace Word To ..." },
        s = { name = "Session" },
        u = { name = "Upload" },
        t = {
            name = "Terminal | Translate",
            c = "Translate English to Chinese",
            e = "Translate Chinese to English",
        },
    }, { prefix = "<leader>", mode = "n" })

    -- comment
    M.wk.register({
        c = {
            name = "Comment",
            c = "Toggle line comment",
            b = "Toggle block comment",
            a = "Insert line comment to line end",
            j = "Insert line comment to next line",
            k = "Insert line comment to previous line",
        },
    }, { prefix = "g", mode = "n" })

    M.wk.register({
        c = "Switch the specified line to a line comment",
        b = "Switch the specified line to a block comment",
    }, { prefix = "g", mode = "v" })

    -- surround
    M.wk.register({
        q = "Switch Surround",
        s = "Change Surround",
    }, { prefix = "c", mode = "n" })

    M.wk.register({
        s = "Delete Surround",
    }, { prefix = "d", mode = "n" })

    M.wk.register({
        s = "Add Surround",
    }, { prefix = "y", mode = "n" })
end

return M
