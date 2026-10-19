ln -s $(find $(pwd) -name '\.*' -type f) ~/
mkdir -p ~/bin
ln -s $(find $(pwd)/utils -type f) ~/bin/
mkdir -p ~/.config/mise
ln -s $(pwd)/.config/mise/config.toml ~/.config/mise/config.toml
