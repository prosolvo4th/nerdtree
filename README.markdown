The NERD Tree
=============

New Feature
----------

Add git status support for NERDTree.You can indicate a file's git status, quickly see which files you have staged, unstaged and modified, or deleted in your project without any extra work.


![screenshot](screenshot/nerd-git-status.png)

Indicators
----------

* ✭ : Untracked
* ✹ : Modified in the working tree
* ✚ : Staged in the index (Exclude Renamed status)
* ➜ : Renamed
* ═ : Unmerged
* ✖ : Deleted (This indicator can't be shown, as NERDTree doesn't display deleted files. I have no prefect idea to solve this problem currently.)
* ✗ : Dirty (Only for directory)

Key mapping
-----------

As the same as [GitGutter](https://github.com/airblade/vim-gitgutter) plugin default.

* `]c` : Jump to next indicator
* `[c` : Jump to prev indicator

You can set `g:NERDTreeMapNextHunk` and `g:NERDTreeMapPrevHunk` variables to your prefer keys. e.g.

`let g:NERDTreeMapNextHunk = ",n"`

`let g:NERDTreeMapPrevHunk = ",p"`

NOTE
----

Now it's is still under development, there may be a lot of bug. Welcome your pull request!

Add `let g:NERDTreeShowGitStatus = 0` in your vimrc to turn off this feature.

WARNING
-------

It has **NOT** been tested in Windows.

TODO
----

* ~~add key mapping, default: `]c` to next change, `[c` to prev change.~~

* refresh git status realtime.

**Happy Coding!!!!**

More Info
---------

See details in https://github.com/scrooloose/nerdtree
