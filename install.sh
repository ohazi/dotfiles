cp bashrc ~/.bashrc
cp profile ~/.profile
cp install/.xsessionrc ~


cp install/.bash_completion ~
mkdir -p ~/.bash_completion.d


cp install/.tmux.conf ~
# TODO: Copy/paste still sucks in tmux+vim and over ssh
sudo apt install xsel


cp install/.vimrc ~
cp -R install/.vim ~
mkdir -p ~/.vim/pack/dotfiles/start
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/swap
mkdir -p ~/.vim/undo
cd ~/.vim/pack/dotfiles/start/

git clone https://github.com/scrooloose/nerdtree.git
# Newer vim has a version of this. May want newest verison.
git clone https://github.com/rust-lang/rust.vim.git
git clone https://github.com/dense-analysis/ale.git

#git clone https://github.com/vim-syntastic/syntastic.git

# Use ALE instead
#git clone https://github.com/prabirshrestha/asyncomplete.vim
#git clone https://github.com/prabirshrestha/asyncomplete-lsp.vim
#git clone https://github.com/prabirshrestha/async.vim
#git clone https://github.com/prabirshrestha/vim-lsp

# Meh...
#sudo apt install exuberant-ctags

