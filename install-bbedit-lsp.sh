#!/usr/bin/env bash

brew install llvm

npm install -g vscode-css-languageserver-bin \
vscode-html-languageserver-bin \
vscode-json-languageserver \
typescript \
typescript-language-server \
yaml-language-server

pip3 install -U jedi-language-server

sudo gem install solargraph
which solargraph
# will print out the path to the Solargraph executable if correctly installed
