-----------------------------------------------------------
-- Neovim設定ファイル
-- 最終更新: 2025-02-03
-----------------------------------------------------------
--[[
基本設定の概要:
* リーダーキーの設定
* 表示関連の設定
* インデント設定
* 検索関連の設定
* プラグイン管理（lazy.nvim）
* ファイルタイプ固有の設定
--]] -----------------------------------------------------------
-- グローバル設定
-----------------------------------------------------------
-- リーダーキーの設定
-- Note: プラグインの設定前に定義する必要がある
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-----------------------------------------------------------
-- 基本的なエディタ設定
-----------------------------------------------------------

-- 表示設定
vim.opt.number = true -- 行番号を表示
vim.opt.relativenumber = true -- 相対行番号を表示
vim.opt.mouse = 'a' -- マウス操作を有効化
vim.opt.termguicolors = true -- 24bitカラーを使用

-- システム連携
vim.opt.clipboard = 'unnamedplus' -- システムクリップボードを使用
vim.opt.fileencoding = "utf-8" -- エンコーディングをUTF-8に設定

-- インデント設定
vim.opt.expandtab = true -- タブをスペースに変換
vim.opt.tabstop = 2 -- タブ幅を2に設定
vim.opt.shiftwidth = 2 -- インデント幅を2に設定
vim.opt.autoindent = true -- 自動インデントを有効化
vim.opt.smartindent = true -- スマートインデントを有効化

-- 検索設定
vim.opt.ignorecase = true -- 大文字小文字を区別しない
vim.opt.smartcase = true -- 検索文字に大文字がある場合は区別する
vim.opt.hlsearch = true -- 検索結果をハイライト
vim.opt.incsearch = true -- インクリメンタルサーチを有効化

-----------------------------------------------------------
-- プラグイン管理（lazy.nvim）
-----------------------------------------------------------

-- lazy.nvimのブートストラップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- プラグイン設定
-----------------------------------------------------------

require("lazy").setup({ -- カラースキーム: Tokyo Night
{
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            style = "storm",
            transparent = false
        })
        vim.cmd([[colorscheme tokyonight]])
    end
}, -- 構文解析: Treesitter
{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {"lua", "vim", "markdown", "markdown_inline"},
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false
            },
            indent = {
                enable = true
            }
        })
    end
}, -- ファイル検索: Telescope
{
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {'nvim-lua/plenary.nvim', {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
    }},
    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ['<esc>'] = actions.close,
                        ['<C-u>'] = false
                    }
                }
            }
        })

        -- Telescopeのキーマップ
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {
            desc = 'Find files'
        })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {
            desc = 'Live grep'
        })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {
            desc = 'Find buffers'
        })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {
            desc = 'Help tags'
        })
    end
}, -- Markdownプレビュー
{
    "previm/previm",
    ft = {"markdown"},
    config = function()
        -- Macの場合のブラウザ設定
        vim.g.previm_open_cmd = 'open -a "Google Chrome"'
    end
}, -- Markdown箇条書き支援
{
    "dkarter/bullets.vim",
    ft = {"markdown", "text", "gitcommit"},
    config = function()
        -- 基本設定
        vim.g.bullets_enabled_file_types = {'markdown', 'text', 'gitcommit'}
        vim.g.bullets_outline_levels = {'num', 'abc', 'std-'}
        vim.g.bullets_checkbox_markers = ' ○◐●✓'
        vim.g.bullets_nested_checkboxes = 1
        vim.g.bullets_checkbox_partials_toggle = 1
        vim.g.bullets_set_mappings = 0
    end,
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                -- インデント操作
                vim.keymap.set('i', '<Tab>', '<C-t>', {
                    buffer = true
                })
                vim.keymap.set('i', '<S-Tab>', '<C-d>', {
                    buffer = true
                })
                -- チェックボックス操作
                vim.keymap.set('n', '<leader>t', ':ToggleCheckbox<CR>', {
                    buffer = true
                })
            end
        })
    end
}, -- Obsidian連携
{
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false,
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        require("obsidian").setup({
            completion = {
                nvim_cmp = true,
                min_chars = 2
            },
            workspaces = {{
                name = "garden",
                path = "~/asobiba/garden-glxy96"
            }},
            notes_subdir = "daily",
            daily_notes = {
                folder = "daily",
                date_format = "%Y/%m/%d",
                template = "templates/daily.md"
            },
            templates = {
                subdir = "templates",
                date_format = "%Y-%m-%d",
                time_format = "%H:%M",
                -- テンプレート内の置換パターンを定義
                substitutions = {
                  ["YYYY-MM-DD"] = function()
                      -- 現在のバッファのファイル名から日付を取得
                      local filepath = vim.fn.expand('%:p')
                      local pattern = '.*/(%d%d%d%d)/(%d%d)/(%d%d).md$'
                      local year, month, day = filepath:match(pattern)
                      
                      if year and month and day then
                          -- ファイル名から日付を組み立て
                          return string.format('%s-%s-%s', year, month, day)
                      end
                      
                      -- ファイル名からの取得に失敗した場合は現在日時を返す
                      return os.date('%Y-%m-%d')
                  end,
              },
            },
            -- テンプレートの日付置換を有効化
            note_id_func = function(title)
                -- デイリーノートの場合は日付形式に変換
                if title:match("^%d%d%d%d/%d%d/%d%d$") then
                    return title:gsub("/", "-")
                end
                return title
            end,
            -- テンプレート処理用のフック
            open_notes_in = "current",
            hooks = {
              after_note_creation = function(note)
                  -- ファイルパスから日付を抽出
                  local date_pattern = ".*/(%d%d%d%d)/(%d%d)/(%d%d).md$"
                  local year, month, day = note.path:match(date_pattern)
                  
                  if year and month and day then
                      -- バッファの内容を取得
                      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                      -- ファイルパスから取得した日付で置換
                      local target_date = string.format("%s-%s-%s", year, month, day)
                      
                      -- 各行を処理
                      for i, line in ipairs(lines) do
                          lines[i] = line:gsub("YYYY%-MM%-DD", target_date)
                      end
                      
                      -- 更新した内容をバッファに書き戻す
                      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
                  end
              end,
          }
        })

        -- Obsidianのキーマップ
        vim.keymap.set('n', '<leader>jd', '<cmd>ObsidianToday<CR>', {
            desc = 'Open today note'
        })
        vim.keymap.set('n', '<leader>jy', '<cmd>ObsidianYesterday<CR>', {
            desc = 'Open yesterday note'
        })
        vim.keymap.set('n', '<leader>jt', '<cmd>ObsidianTomorrow<CR>', {
            desc = 'Open tomorrow note'
        })

        -- ウィークリーノート作成機能
        local function create_weekly_note()
            local current_date = os.date("*t")
            local year = current_date.year
            local month = string.format("%02d", current_date.month)

            -- ISO週番号の計算
            local function get_iso_week()
                local day_of_year = os.date("%j")
                local day_of_week = os.date("%w")
                if day_of_week == "0" then
                    day_of_week = "7"
                end

                local first_day = os.date("%w", os.time({
                    year = year,
                    month = 1,
                    day = 1
                }))
                if first_day == "0" then
                    first_day = "7"
                end

                return math.ceil((tonumber(day_of_year) + tonumber(first_day) - 1) / 7)
            end

            local week = get_iso_week()
            local filename = string.format("weekly/%d/%02d.md", year, week)
            local dir = string.format("weekly/%d", year)

            vim.fn.mkdir(dir, "p")
            vim.cmd('edit ' .. filename)

            if vim.fn.filereadable(vim.fn.expand('%:p')) == 0 then
                local template_path = vim.fn.expand('~/asobiba/garden-glxy96/templates/weekly.md')
                local template_content = vim.fn.readfile(template_path)
                local title = string.format("# %d年%s月 第%02d週", year, month, week)
                template_content[1] = title
                vim.api.nvim_buf_set_lines(0, 0, -1, false, template_content)
            end
        end

        vim.keymap.set('n', '<leader>jw', create_weekly_note, {
            desc = 'Create/Open weekly note'
        })
    end
}, 
{
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    config = function()
        require("which-key").setup({
            -- 設定をカスタマイズする場合はここに記述
        })
    end
},
{
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({
            cmdline = {
                enabled = true,
                view = "cmdline_popup", -- ホバー形式の表示
            },
            messages = {
                enabled = true,
            },
            popupmenu = {
                enabled = true,
            },
        })
    end
}, -- 補完エンジン: nvim-cmp
{
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline",
                    "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip"},
    config = function()
        local cmp = require('cmp')

        -- 基本設定
        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({
                    select = true
                })
            }),
            sources = cmp.config.sources({{
                name = 'nvim_lsp'
            }, {
                name = 'vsnip'
            }, {
                name = 'obsidian'
            }}, {{
                name = 'buffer'
            }})
        })

        -- コマンドライン用設定
        cmp.setup.cmdline({'/', '?'}, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{
                name = 'buffer'
            }}
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({{
                name = 'path'
            }}, {{
                name = 'cmdline'
            }}),
            matching = {
                disallow_symbol_nonprefix_matching = false
            }
        })
    end
}})

-----------------------------------------------------------
-- ファイルタイプ固有の設定
-----------------------------------------------------------

-- Markdown設定
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        -- 表示設定
        vim.opt_local.wrap = true -- 長い行を折り返し
        vim.opt_local.conceallevel = 0 -- Markdown記号を表示
        vim.opt_local.foldenable = false -- 折りたたみを無効化

        -- インデント設定
        vim.opt_local.expandtab = true -- タブをスペースに
        vim.opt_local.tabstop = 2 -- タブ幅
        vim.opt_local.softtabstop = 2 -- タブの挿入/削除幅
        vim.opt_local.shiftwidth = 2 -- 自動インデント幅
    end
})

-----------------------------------------------------------
-- キーマップ設定
-----------------------------------------------------------

-- 行折り返しのトグル
vim.keymap.set('n', '<leader>w', function()
    vim.opt.wrap = not vim.opt.wrap:get()
end, {
    desc = 'Toggle wrap'
})

-----------------------------------------------------------
-- その他の自動コマンド
-----------------------------------------------------------

-- ファイルを開いた時にそのディレクトリに自動で移動
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 1 then
            local arg = vim.fn.argv()[1]
            if vim.fn.isdirectory(arg) ~= 0 then
                vim.cmd.cd(arg)
            else
                vim.cmd.cd(vim.fn.fnamemodify(arg, ":h"))
            end
        end
    end
})

-- -- デイリーノートのテンプレート処理
-- vim.api.nvim_create_autocmd("BufNewFile", {
--     pattern = "*/daily/*/[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9].md",
--     callback = function()
--         -- 現在の日付を取得
--         local current_date = os.date("%Y-%m-%d")

--         -- バッファの内容を取得
--         local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

--         -- テンプレートの内容を読み込み
--         local template_path = vim.fn.expand('~/asobiba/garden-glxy96/templates/daily.md')
--         local template_content = vim.fn.readfile(template_path)

--         -- テンプレートの日付を置換
--         for i, line in ipairs(template_content) do
--             template_content[i] = line:gsub("YYYY%-MM%-DD", current_date)
--         end

--         -- バッファに書き込み
--         vim.api.nvim_buf_set_lines(0, 0, -1, false, template_content)

--         -- カーソルを Tasks の下に移動
--         for i, line in ipairs(template_content) do
--             if line:match("^## Tasks") then
--                 vim.api.nvim_win_set_cursor(0, {i + 2, 4})
--                 break
--             end
--         end
--     end
-- })
