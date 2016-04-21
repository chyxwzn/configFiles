# git config --global http.proxy 127.0.0.1:8087
git config --global user.name "chyxwzn"
git config --global user.email chyxwzn@gmail.com
git config --global push.default simple
git config --global merge.tool vimdiff
git config --global credential.helper cache --timeout=36000
git config --global diff.tool vimdiff
git config --global difftool.prompt false
git config --global difftool.prompt false
git config --global color.diff always
git config --global color.grep always
git config --global grep.linenumber true
git config --global http.sslVerify false
git config --global alias.d difftool
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.br branch
git config --global alias.unstage 'reset HEAD'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit"
