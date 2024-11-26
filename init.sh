# !/bin/bash

find $(pwd) -name '\.*' -type f |
  while read file; do
    if [ -e "$file" ]; then
      echo "skip create link ${file}" >&2
      continue
    fi
    ln -s "${file}" ~/
  done

mkdir -p ~/bin

find $(pwd)/utils -type f |
  while read file; do
    if [ -e "$file" ]; then
      echo "skip create link ${file}" >&2
      continue
    fi
    ln -s "${file}" ~/bin/
  done
