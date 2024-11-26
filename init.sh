# !/bin/bash
ln -s $(find $(pwd) -name '\.*' -type f) ~/
mkdir -p ~/bin
ln -s $(find $(pwd)/utils -type f) ~/bin/
