# .dotfiles

## requirements

###  vim

#### common

* python3
* GNU global (brew install global)
    * Pygments (pip3 install pygments)
* any-jump
    * https://github.com/pechorin/any-jump.vim
    * ripgrep
        * ```$ cargo install ripgrep --features pcre2```
        * https://github.com/pechorin/any-jump.vim/issues/14#issuecomment-596218890

#### language support

* php
    * php
    * composer
    * composer global require "jetbrains/phpstorm-stubs:dev-master"
        * JetBrains社製のPHPStormの関数情報
* golang
    * :GoInstallBinaries
    * gopls
        * `go install golang.org/x/tools/gopls@latest`
* elm
    * npm install -g elm elm-test elm-oracle elm-format
* js/typescript
    * npm install -g typescript typescript-language-server
* vue
    * https://github.com/posva/vim-vue
        * npm i -g eslint eslint-plugin-vue


##### ReasonML

```
$ npm i -g bs-platform@6.2.1
$ brew install ocaml
$ brew install opam hg darcs
$ opam init
$ opam switch create 4.06.1
$ opam install merlin
$ npm install -g reason-cli@latest-macos
$ npm install -g ocaml-language-server
```
