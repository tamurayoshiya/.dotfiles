local lspconfig = require('lspconfig')

lspconfig["denols"].setup({
  root_dir = lspconfig.util.root_pattern("deno.json"),
  init_options = {
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.nest.land"] = true,
          ["https://crux.land"] = true,
        },
      },
    },
  },

})
lspconfig["tsserver"].setup({
  root_dir = lspconfig.util.root_pattern("package.json"),
})
