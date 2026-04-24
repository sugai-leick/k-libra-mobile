
#!/usr/bin/env bash
set -e

NVIM_DIR="$HOME/.config/nvim"
LUA_DIR="$NVIM_DIR/lua"
PLUGINS_DIR="$LUA_DIR/plugins"
CONFIG_DIR="$LUA_DIR/config"

echo "==> Criando estrutura..."
mkdir -p "$PLUGINS_DIR" "$CONFIG_DIR"

echo "==> Instalando lazy.nvim..."
if [ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
  git clone https://github.com/folke/lazy.nvim.git \
    "$HOME/.local/share/nvim/lazy/lazy.nvim"
fi

echo "==> Escrevendo init.lua..."
cat > "$NVIM_DIR/init.lua" <<'EOF'
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.keymaps")
require("lazy").setup("plugins")
EOF

echo "==> Escrevendo options.lua..."
cat > "$CONFIG_DIR/options.lua" <<'EOF'
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.cursorline = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.updatetime = 250
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
EOF

echo "==> Escrevendo keymaps.lua..."
cat > "$CONFIG_DIR/keymaps.lua" <<'EOF'
local keymap = vim.keymap.set

keymap("n", "<leader>w", "<cmd>w<CR>")
keymap("n", "<leader>q", "<cmd>q<CR>")
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")

keymap("n", "<leader>gg", "<cmd>GitBlameToggle<CR>")
keymap("n", "<leader>fr", "<cmd>FlutterRun<CR>")
keymap("n", "<leader>fq", "<cmd>FlutterQuit<CR>")
keymap("n", "<leader>fd", "<cmd>FlutterDevices<CR>")
keymap("n", "<leader>fo", "<cmd>FlutterOutlineToggle<CR>")
keymap("n", "<leader>fhh", "<cmd>FlutterReload<CR>")
keymap("n", "<leader>frr", "<cmd>FlutterRestart<CR>")
EOF

echo "==> Escrevendo plugins/base.lua..."
cat > "$PLUGINS_DIR/base.lua" <<'EOF'
return {
  { "nvim-lua/plenary.nvim" },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },

  {
    "f-person/git-blame.nvim",
    config = function()
      vim.g.gitblame_enabled = 0
    end,
  },
}
EOF

echo "==> Escrevendo plugins/cmp.lua..."
cat > "$PLUGINS_DIR/cmp.lua" <<'EOF'
return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        completion = {
          autocomplete = false,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end,
  },
}
EOF

echo "==> Escrevendo plugins/flutter.lua..."
cat > "$PLUGINS_DIR/flutter.lua" <<'EOF'
return {
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("flutter-tools").setup({
        lsp = {
          capabilities = capabilities,
        },
      })
    end,
  },
}
EOF

echo "==> Escrevendo plugins/theme.lua..."
cat > "$PLUGINS_DIR/theme.lua" <<'EOF'
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
EOF

echo
echo "==> Pronto."
echo "Agora abre o nvim e deixa os plugins instalarem:"
echo
echo "    nvim"
echo
echo "Atalhos principais:"
echo "  Space ff   -> Telescope find_files"
echo "  Space fg   -> Telescope live_grep"
echo "  Space e    -> NvimTree"
echo "  Space gg   -> Git blame"
echo "  Space fr   -> Flutter run"
echo "  Ctrl-Space -> autocomplete manual"
