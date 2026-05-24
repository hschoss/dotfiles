local function RMarkdownToHTMLPreview()
    local source_path = vim.fn.expand("%:p")
    local html_path = vim.fn.fnamemodify(source_path, ":r") .. ".html"

    vim.cmd('write')

    local render_job = vim.fn.jobstart({
        "Rscript",
        "-e",
        "rmarkdown::render(commandArgs(trailingOnly=TRUE)[1], output_format='html_document')",
        "--",
        source_path,
    }, {
        detach = false,
        on_exit = function(_, code)
            if code == 0 then
                vim.fn.jobstart({ "firefox", "-new-tab", "file://" .. html_path }, { detach = true })
                vim.schedule(function()
                    vim.notify("R Markdown rendered to HTML and opened in Firefox")
                end)
            else
                vim.schedule(function()
                    vim.notify("R Markdown render failed", vim.log.levels.ERROR)
                end)
            end
        end,
    })

    if render_job <= 0 then
        vim.notify("Failed to start R Markdown render", vim.log.levels.ERROR)
    end
end

local M = {}

M.preview = RMarkdownToHTMLPreview

vim.cmd('command! RmdToHTMLPreview lua require("rmarkdown").preview()')

return M
