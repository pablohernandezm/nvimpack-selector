local selector = require("nvimpack-selector")

vim.api.nvim_create_user_command("NvimPackSelector", function(data)
  if data.args == "open" then
    selector.open_float()
  end
end, { nargs = 1, desc = "Open nvimpack-selector" }
)
