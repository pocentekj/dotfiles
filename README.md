# dotfiles

Different config settings from my home directory. I keep in GIT repository so
it's easy to restore configuration if I break something or create separate branches
for different configs/environments.

The easiest way to use it is just make symlinks in proper places in user HOME
directory pointing to the files placed in `src` directory. Here's an example,
but beware that I assume directory structure on my system, so yours may differ:

```
ln -s $(pwd)/src/tmux.conf "$HOME/.tmux.conf"
ln -s $(pwd)/to/project/src/zshrc "$HOME/.zshrc"
ln -s $(pwd)/to/project/src/hypr "$HOME/.config/"
ln -s $(pwd)/to/project/src/waybar "$HOME/.config/"
ln -s $(pwd)/to/project/src/kitty "$HOME/.config/"
```

Check out `setup.sh` for reference as it usually contains more up-to-date list.

# Scripts

in `src/scripts` directory you'll find a collection of small useful scripts for
various purposes. You can place them anywhere on the PATH as they're already
executable. The usual way I do it is to add `~/.local/bin` to my `PATH` and then
symlink items from `src/scripts`, like this:

```
ln -s $(pwd)/src/scripts/nv.sh "$HOME/.local/bin/nv"
```

