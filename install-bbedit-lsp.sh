#!/usr/bin/env bash

brew install llvm

npm install -g vscode-css-languageserver-bin \
vscode-html-languageserver-bin \
vscode-json-languageserver \
typescript \
typescript-language-server \
yaml-language-server

pip install -U jedi-language-server

sudo /usr/local/opt/ruby/bin/gem install solargraph
which solargraph
# will print out the path to the Solargraph executable if correctly installed
