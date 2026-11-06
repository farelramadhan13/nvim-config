require("hlchunk").setup {
  chunk = {
    enable = true,
    chars = {
      horizontal_line = "─",
      vertical_line = "│",
      left_top = "╭",
      left_bottom = "╰",
      right_arrow = ">",
    },
    style = { "#a485dd", "#ee6d85" },
  },
  line_num = {
    style = "#9071c9",
  },
  indent = {
    enable = true,
    style = "#4e4f5a",
  },
}

local ts_node_type = require "hlchunk.utils.ts_node_type"
ts_node_type.go = {
  function_declaration = true,
  method_declaration = true,
  block = true,
  struct_type = true,
  field_declaration_list = true,
  interface_type = true,
  type_declaration = true,
  import_declaration = true,
}

local chunkHelper = require "hlchunk.utils.chunkHelper"
local Scope = require "hlchunk.utils.scope"
local RET = chunkHelper.CHUNK_RANGE_RET
local original_get_chunk_range = chunkHelper.get_chunk_range

local required_pairs = {
  go = {
    { "short_var_declaration", "composite_literal" },
  },
}

chunkHelper.get_chunk_range = function(opts)
  local pos = opts.pos
  local bufnr = pos and pos.bufnr or 0
  local active_pairs = required_pairs[vim.bo[bufnr].ft]

  -- JIKA ada konfigurasi pasangan khusus untuk bahasa ini, cek kondisinya terlebih dahulu
  if opts.use_treesitter and active_pairs and #active_pairs > 0 then
    local ok, node = pcall(vim.treesitter.get_node, {
      pos = { pos.row, pos.col },
      bufnr = bufnr,
      ignore_injections = false,
    })

    if node and node:type() == "source" then
      ok, node = pcall(vim.treesitter.get_node, { pos = { pos.row, pos.col }, bufnr = bufnr })
    end

    if ok and node then
      local chain = {}
      ---@type TSNode|nil
      local parent = node
      while parent do
        chain[#chain + 1] = parent
        parent = parent:parent()
      end

      for _, pair in ipairs(active_pairs) do
        local matched = true
        for _, node_type in ipairs(pair) do
          local found = false
          for _, chain_node in ipairs(chain) do
            if chain_node:type() == node_type then
              found = true
              break
            end
          end
          if not found then
            matched = false
            break
          end
        end

        -- JIKA COCOK dengan pasangan khusus (misal: composite_literal di dalam short_var_declaration)
        if matched then
          local pair_types = {}
          for _, node_type in ipairs(pair) do
            pair_types[node_type] = true
          end
          for _, chain_node in ipairs(chain) do
            local start_row, _, end_row = chain_node:range()
            if pair_types[chain_node:type()] and start_row ~= end_row then
              return RET.OK, Scope(bufnr, start_row, end_row)
            end
          end
        end
      end
    end
  end

  -- PENTING: Jika tidak cocok dengan pasangan khusus, kembalikan ke fungsi asli (fallback)
  -- Ini yang membuat fungsi biasa (seperti ts_node_type.go) tetap bisa mendeteksi block & struct!
  return original_get_chunk_range(opts)
end

require("ibl").setup {
  indent = {
    char = "│",
    tab_char = "│",
  },
  scope = { enabled = false },
}
