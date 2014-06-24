#!/bin/sh
find . -name "*.h" -or -name "*.hpp" -or -name "*.c" -or -name "*.cc" -or -name "*.cpp" -or -name "*.java" > cscope.files

# Generate cscope database & tags
cscope -bkq -i cscope.files
ctags --fields=+ialS --extra=+q -L cscope.files
# ctags --c++-kinds=+p --fields=+iaS --extra=+q -L cscope.files

touch .project.vim
touch .project.viminfo
