Test todos

- display_list (lines): Assert vim.api.nvim_buf_set_lines is called per row with correct start/stop indices and that each line is the concatenation of the formatted column values.
- display_list (extmarks present): For columns with hl_group, schedule creates/gets namespace "nvimpack-selector.list.<col>", and buf_set_extmark is called with row=start, col_start, end_col = trimmed value length, and hl_group set.
- display_list (extmarks absent): For columns without hl_group, ensure no extmarks/namespaces are created for that column.
