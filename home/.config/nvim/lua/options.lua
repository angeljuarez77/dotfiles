require "nvchad.options"

-- add yours here!

local o = vim.o
o.rnu = true

if vim.env.DNVIM_CONTAINER then
  o.clipboard = ""
else
  o.clipboard = "unnamedplus"
end
-- o.cursorlineopt ='both' -- to enable cursorline!
