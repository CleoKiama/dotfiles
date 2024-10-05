-- load vs code snippets for Es6 plus redux
require("luasnip.loaders.from_vscode").lazy_load {
  paths = {
    "~/.vscode/extensions/dsznajder.es7-react-js-snippets-4.4.3/lib/snippets/generated.json",
    "~/.vscode/extensions/burkeholland.simple-react-snippets-1.2.8/snippets/snippets.json",
    "~/.vscode/extensions/burkeholland.simple-react-snippets-1.2.8/snippets/snippets-ts.json",
    "~/.vscode/extensions/xabikos.javascriptsnippets-1.8.0/snippets/snippets.json",
    "~/.vscode/extensions/chris-noring.node-snippets-1.3.3/snippets/snippets.json",
  },
}
