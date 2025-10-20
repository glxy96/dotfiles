-----------------------------------------------------------
-- Neovim設定ファイル
-- 最終更新: 2025-06-05
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
            ensure_installed = {"lua", "vim", "markdown", "markdown_inline", "regex", "bash"},
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
}, -- ファイルアイコン
{
    "nvim-tree/nvim-web-devicons",
    lazy = true
}, -- ファイルエクスプローラー
{
    "nvim-tree/nvim-tree.lua",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        require("nvim-tree").setup({
            -- ここで細かい設定が可能ですが、まずはデフォルトでOK
            view = {
                width = 30 -- 幅を30文字に設定
            }
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
}, {
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
}, {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {"MunifTanjim/nui.nvim", "rcarriga/nvim-notify"},
    config = function()
        require("noice").setup({
            cmdline = {
                enabled = true,
                view = "cmdline_popup" -- ホバー形式の表示
            },
            messages = {
                enabled = true
            },
            popupmenu = {
                enabled = true
            }
        })
    end
}, -- Obsidian設定
{
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false,
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        require("obsidian").setup({
            -- デバッグ用ログ設定（問題解決後はコメントアウト推奨）
            -- log_level = vim.log.levels.DEBUG,

            completion = {
                nvim_cmp = true,
                min_chars = 2
            },
            workspaces = {{
                name = "garden",
                path = "~/pkm"
            }},
            notes_subdir = "inbox/temporary",
            new_notes_location = "notes_subdir",
            note_id_func = function(title)
                return title or "untitled"
            end,
            open_notes_in = "current",

            -- フロントマターのカスタム処理
            -- Obsidian.nvim フロントマター設定
            -- PKM + Quartz公開ワークフロー対応版
            -- 設計方針：
            --   - 全てのメモに日付フィールド (created, updated, published) を記録
            --   - public/weekly は初回作成時に draft: true を自動設定
            --   - draft は既存値を保持（手動で false に変更して公開）

            note_frontmatter_func = function(note)
                local out = {
                    id = note.id,
                    aliases = note.aliases,
                    tags = note.tags
                }

                -- ファイルパスを取得
                local path = note.path and tostring(note.path) or ""

                -- ディレクトリ判定
                local is_public = path:match("^public/")
                local is_weekly = path:match("^weekly/")

                local current_date = os.date("%Y-%m-%d")

                if note.metadata ~= nil and note.metadata.frontmatter ~= nil then
                    -- 既存ファイルの場合
                    local fm = note.metadata.frontmatter

                    -- 日付フィールド（全メモに適用）
                    out.created = fm.created or current_date
                    out.updated = current_date -- 保存時に常に更新
                    out.published = fm.published or current_date

                    -- draftフィールドは既存値を保持（手動管理）
                    if fm.draft ~= nil then
                        out.draft = fm.draft
                    end

                    -- publishフィールドも保持（Quartz ExplicitPublish用の場合）
                    if fm.publish ~= nil then
                        out.publish = fm.publish
                    end

                    -- その他のカスタムフィールドを保持
                    for key, value in pairs(fm) do
                        if key ~= "id" and key ~= "aliases" and key ~= "tags" and key ~= "created" and key ~= "updated" and
                            key ~= "published" and key ~= "draft" and key ~= "publish" then
                            out[key] = value
                        end
                    end
                else
                    -- 新規ファイルの場合
                    out.created = current_date
                    out.updated = current_date
                    out.published = current_date

                    -- 公開対象ディレクトリは初期値draft: true
                    if is_public or is_weekly then
                        out.draft = true
                    end
                end

                return out
            end
        })

        -- カスタムデイリーノート作成機能（既存のコードそのまま）
        local function create_daily_note()
            local date = os.date("*t")
            local year = date.year
            local month = string.format("%02d", date.month)
            local day = string.format("%02d", date.day)

            local dir_path = string.format("daily/%d/%s", year, month)
            vim.fn.mkdir(dir_path, "p")

            local file_path = string.format("%s/%s.md", dir_path, day)
            vim.cmd('edit ' .. file_path)

            if vim.fn.filereadable(vim.fn.expand('%:p')) == 0 then
                -- バッファが編集可能であることを確認
                vim.opt_local.modifiable = true

                local target_date = string.format("%d-%s-%s", year, month, day)
                local template_path = vim.fn.expand('~/pkm/templates/daily.md')

                if vim.fn.filereadable(template_path) == 1 then
                    local template_lines = vim.fn.readfile(template_path)

                    for i, line in ipairs(template_lines) do
                        template_lines[i] = line:gsub("YYYY%-MM%-DD", target_date)
                    end

                    local final_content = {"---", string.format('id: "%s"', day), "aliases: []", "tags:",
                                           "  - daily-notes", "---", ""}

                    for _, line in ipairs(template_lines) do
                        table.insert(final_content, line)
                    end

                    -- Treesitterの処理を待ってからバッファを設定
                    vim.schedule(function()
                        vim.api.nvim_buf_set_lines(0, 0, -1, false, final_content)

                        for i, line in ipairs(final_content) do
                            if line:match("^## Tasks") then
                                vim.api.nvim_win_set_cursor(0, {i + 2, 4})
                                break
                            end
                        end
                    end)
                else
                    print("Template file not found: " .. template_path)
                end
            end
        end

        -- ウィークリーノート作成機能（修正版）
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
            local week_str = string.format("%02d", week)
            local filename = string.format("weekly/%d/%s.md", year, week_str)
            local dir = string.format("weekly/%d", year)

            vim.fn.mkdir(dir, "p")
            vim.cmd('edit ' .. filename)

            -- 新規ファイルの場合のみテンプレートを適用
            if vim.fn.filereadable(vim.fn.expand('%:p')) == 0 then
                -- バッファが編集可能であることを確認
                vim.opt_local.modifiable = true

                local template_path = vim.fn.expand('~/pkm/templates/weekly.md')

                if vim.fn.filereadable(template_path) == 1 then
                    local template_lines = vim.fn.readfile(template_path)

                    -- 現在の日付を取得
                    local day = string.format("%02d", current_date.day)
                    local current_date_str = string.format("%d-%s-%s", year, month, day)

                    -- フロントマター作成
                    local final_content = {"---", string.format('id: "%s"', week_str), "aliases: []", "tags:",
                                           "  - weekly-notes", string.format('created: "%s"', current_date_str),
                                           string.format('updated: "%s"', current_date_str),
                                           string.format('published: "%s"', current_date_str), "draft: true", "---", ""}

                    -- テンプレートの内容を追加（YYYY, MM, WWを置換）
                    for _, line in ipairs(template_lines) do
                        local processed_line = line
                        processed_line = processed_line:gsub("YYYY", tostring(year))
                        processed_line = processed_line:gsub("MM", month)
                        processed_line = processed_line:gsub("WW", week_str)
                        table.insert(final_content, processed_line)
                    end

                    -- Treesitterの処理を待ってからバッファを設定
                    vim.schedule(function()
                        vim.api.nvim_buf_set_lines(0, 0, -1, false, final_content)

                        -- カーソルを最初のセクションに移動
                        for i, line in ipairs(final_content) do
                            if line:match("^## 前の週のアクション") then
                                vim.api.nvim_win_set_cursor(0, {i + 2, 0})
                                break
                            end
                        end
                    end)
                else
                    print("Template file not found: " .. template_path)
                end
            end
        end

        -- キーマップ設定
        vim.keymap.set('n', '<leader>jd', create_daily_note, {
            desc = 'Create/Open today note'
        })

        vim.keymap.set('n', '<leader>jy', function()
            local yesterday = os.time() - 86400
            local date = os.date("*t", yesterday)
            local year = date.year
            local month = string.format("%02d", date.month)
            local day = string.format("%02d", date.day)
            local file_path = string.format("daily/%d/%s/%s.md", year, month, day)
            vim.cmd('edit ' .. file_path)
        end, {
            desc = 'Open yesterday note'
        })

        vim.keymap.set('n', '<leader>jt', function()
            local tomorrow = os.time() + 86400
            local date = os.date("*t", tomorrow)
            local year = date.year
            local month = string.format("%02d", date.month)
            local day = string.format("%02d", date.day)
            local file_path = string.format("daily/%d/%s/%s.md", year, month, day)
            vim.cmd('edit ' .. file_path)
        end, {
            desc = 'Open tomorrow note'
        })

        vim.keymap.set('n', '<leader>jw', create_weekly_note, {
            desc = 'Create/Open weekly note'
        })

        vim.keymap.set('n', '<leader>nn', ':ObsidianNew ', {
            desc = 'New note in inbox'
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
        vim.opt_local.conceallevel = 1 -- Markdownをライブプレビューに
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

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {
    desc = 'Toggle file explorer'
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

