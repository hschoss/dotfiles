-- Defi-- 1. Definition der Funktion im lokalen Kontext
local function RMarkdownToHTMLPreview()
    -- Holt den aktuellen Dateinamen ohne Endung (z.B. 'dokument')
    local filename = vim.fn.expand("%:r")
    local dir_path = vim.fn.expand("%:p:h")
    local html_path = dir_path .. "/" .. filename .. ".html"
    
    vim.cmd('write')
    
    local render_cmd = "Rscript -e \"rmarkdown::render(commandArgs(trailingOnly=TRUE)[1], output_format='html_document')\" -- " .. vim.fn.shellescape(vim.fn.expand('%')) .. " &"
    vim.fn.system(render_cmd)
    
    vim.cmd('sleep 500m')
    
    local open_cmd = "firefox -new-tab file://" .. html_path .. " &> /dev/null &"
    vim.fn.system(open_cmd)
    
    vim.cmd('echo "R Markdown rendered to HTML and opened in Firefox!"')
end

-- 2. Erstellung des Modules (enthält alle Funktionen)
local M = {}

-- 3. Zuweisung der Funktion als Methode des Moduls
M.preview = RMarkdownToHTMLPreview

-- 4. Erstellung des Neovim User Commands, der die Modulfunktion aufruft:
-- Wichtig: Da wir M zurückgeben, ist es im globalen Kontext nun als rmarkdown (durch require) bekannt.
vim.cmd('command! RmdToHTMLPreview lua require("rmarkdown").preview()')

-- 5. Rückgabe des Modules, damit es von init.lua verwendet werden kann.
return M
