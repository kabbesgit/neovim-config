return {pkgs={{source="lazy",name="noice.nvim",spec=function()
return {
  -- nui.nvim can be lazy loaded
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "folke/noice.nvim",
  },
}

end,file="lazy.lua",dir="/Users/kasperblom/.local/share/nvim/lazy/noice.nvim",},{source="lazy",name="plenary.nvim",spec={"nvim-lua/plenary.nvim",lazy=true,},file="community",dir="/Users/kasperblom/.local/share/nvim/lazy/plenary.nvim",},},version=12,}