-- https://github.com/rcarriga/nvim-notify

local icons = require("utils.icons")
local options = require("core.options")
local mapping = require("core.mapping")

local M = {
    -- Define message warnings to ignore, usually from the LSP or DAP server
    ignore_message = {
        -- LSP
        "exit code",
        "Invalid buffer",
        "textDocument/signatureHelp is not supported",
        "textDocument/documentSymbol is not supported",
        "client has shut down after sending the message",
        "client has shut down during progress update",
        "client has shut down after sending a workspace/configuration request",
        -- DAP
        "No stopped thread. Cannot move",
    },
    -- Use echo instead of Notify to display the following message
    echo_message = {
        "Reason: breakpoint",
        "Reason: step",
    },
}

function M.before()
    M.register_global_key()
end

function M.load()
    local ok, m = pcall(require, "notify")
    if not ok then
        return
    end

    local notify_options = {
        -- animation style
        -- • fade_in_slide_out
        -- • fade
        -- • slide
        -- • static
        -- Under a transparent background, only static will ensure normal display effect
        stages = "static",
        -- default: 5000
        timeout = 3000,
        -- default: 30
        fps = 120,
        icons = {
            ERROR = icons.diagnostics.Error,
            WARN = icons.diagnostics.Warn,
            INFO = icons.diagnostics.Hint,
            DEBUG = " ",
            TRACE = "✎ ",
        },
    }
    -- If it is a transparent background, an exception will be thrown, and you must specify a background color yourself
    if options.transparent_background then
        notify_options.background_colour = "#ffffff"
    end

    m.setup(notify_options)

    -- Define a meta table for ignoring some information sent by the LSP
    -- but keep all the methods of the original m
    vim.notify = setmetatable({}, {
        __call = function(self, msg, ...)
            for _, v in ipairs(M.ignore_message) do
                if msg:match(v) then
                    return
                end
            end

            for _, v in ipairs(M.echo_message) do
                if msg:match(v) then
                    vim.api.nvim_echo({ { msg, "MoreMsg" } }, false, {})
                    return
                end
            end

            return m(msg, ...)
        end,
        __index = m,
    })
end

function M.after() end

function M.register_global_key()
    mapping.register({
        {
            mode = { "n" },
            lhs = "<leader>fn",
            rhs = function()
                require("telescope").extensions.notify.notify()
            end,
            options = { silent = true },
            description = "Find notices history",
        },
    })
end

return M
