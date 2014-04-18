let s:tree_up_dir_line = '.. (up a dir)'
"NERDTreeFlags are syntax items that should be invisible, but give clues as to
"how things should be highlighted
syn match NERDTreeFlag #\~#
syn match NERDTreeFlag #\[RO\]#

"highlighting for the .. (up dir) line at the top of the tree
execute "syn match NERDTreeUp #\\V". s:tree_up_dir_line ."#"

"highlighting for the ~/+ symbols for the directory nodes
syn match NERDTreeClosable #\~\<#
syn match NERDTreeClosable #\~\.#
syn match NERDTreeOpenable #+\<#
syn match NERDTreeOpenable #+\.#he=e-1

"highlighting for the tree structural parts
syn match NERDTreePart #|#
syn match NERDTreePart #`#
syn match NERDTreePartFile #[|`]-#hs=s+1 contains=NERDTreePart

"highlighing for the git status
syn match NERDTreeGitStatusModified #✹#
syn match NERDTreeGitStatusModified /\[\~\]/ms=s+1,me=e-1
syn match NERDTreeGitStatusAdded #✚#
syn match NERDTreeGitStatusAdded /\[+\]/ms=s+1,me=e-1
syn match NERDTreeGitStatusDeleted #✖#
syn match NERDTreeGitStatusDeleted /\[-\]/ms=s+1,me=e-1
syn match NERDTreeGitStatusRenamed #➜#
syn match NERDTreeGitStatusRenamed /\[»\]/ms=s+1,me=e-1
syn match NERDTreeGitStatusUnmerged #═#
syn match NERDTreeGitStatusUnmerged /\[=\]/ms=s+1,me=e-1
syn match NERDTreeGitStatusUntracked #✭#
syn match NERDTreeGitStatusUntracked /\[\*\]/ms=s+1,me=e-1
syn match NERDTreeGitStatusDirDirty #✗#
syn match NERDTreeGitStatusDirDirty /\[×\]/ms=s+1,me=e-1
syn match NERDTreeGitStatusDirClean #✔︎#
syn match NERDTreeGitStatusDirClean /\[ø\]/ms=s+1,me=e-1
syn match NERDTreeGitStatus #\[[^{RO}]\]# contains=NERDTreeGitStatusAdded,NERDTreeGitStatusModified,NERDTreeGitStatusUnmodified,NERDTreeGitStatusRenamed,NERDTreeGitStatusUnmerged,NERDTreeGitStatusUntracked,NERDTreeGitStatusDirDirty,NERDTreeGitStatusDirClean

"quickhelp syntax elements
syn match NERDTreeHelpKey #" \{1,2\}[^ ]*:#hs=s+2,he=e-1
syn match NERDTreeHelpKey #" \{1,2\}[^ ]*,#hs=s+2,he=e-1
syn match NERDTreeHelpTitle #" .*\~#hs=s+2,he=e-1 contains=NERDTreeFlag
syn match NERDTreeToggleOn #".*(on)#hs=e-2,he=e-1 contains=NERDTreeHelpKey
syn match NERDTreeToggleOff #".*(off)#hs=e-3,he=e-1 contains=NERDTreeHelpKey
syn match NERDTreeHelpCommand #" :.\{-}\>#hs=s+3
syn match NERDTreeHelp  #^".*# contains=NERDTreeHelpKey,NERDTreeHelpTitle,NERDTreeFlag,NERDTreeToggleOff,NERDTreeToggleOn,NERDTreeHelpCommand

"highlighting for readonly files
syn match NERDTreeRO #.*\[RO\]#hs=s+2 contains=NERDTreeFlag,NERDTreeBookmark,NERDTreePart,NERDTreePartFile,NERDTreeGitStatus

"highlighting for sym links
syn match NERDTreeLink #[^-| `].* -> # contains=NERDTreeBookmark,NERDTreeOpenable,NERDTreeClosable,NERDTreeDirSlash,NERDTreeGitStatus

"highlighing for directory nodes and file nodes
syn match NERDTreeDirSlash #/#
syn match NERDTreeDir #[^-| `].*/# contains=NERDTreeLink,NERDTreeDirSlash,NERDTreeOpenable,NERDTreeClosable,NERDTreeGitStatus
syn match NERDTreeExecFile  #[|` ].*\*\($\| \)# contains=NERDTreeLink,NERDTreePart,NERDTreeRO,NERDTreePartFile,NERDTreeBookmark,NERDTreeGitStatus
syn match NERDTreeFile  #|-.*# contains=NERDTreeLink,NERDTreePart,NERDTreeRO,NERDTreePartFile,NERDTreeBookmark,NERDTreeExecFile,NERDTreeGitStatus
syn match NERDTreeFile  #`-.*# contains=NERDTreeLink,NERDTreePart,NERDTreeRO,NERDTreePartFile,NERDTreeBookmark,NERDTreeExecFile,NERDTreeGitStatus
syn match NERDTreeCWD #^\(\[.\]\?\)[/|<].*$# contains=NERDTreeGitStatus

"highlighting for bookmarks
syn match NERDTreeBookmark # {.*}#hs=s+1

"highlighting for the bookmarks table
syn match NERDTreeBookmarksLeader #^>#
syn match NERDTreeBookmarksHeader #^>-\+Bookmarks-\+$# contains=NERDTreeBookmarksLeader
syn match NERDTreeBookmarkName #^>.\{-} #he=e-1 contains=NERDTreeBookmarksLeader
syn match NERDTreeBookmark #^>.*$# contains=NERDTreeBookmarksLeader,NERDTreeBookmarkName,NERDTreeBookmarksHeader


if exists("g:NERDChristmasTree") && g:NERDChristmasTree
    hi def link NERDTreePart Special
    hi def link NERDTreePartFile Type
    hi def link NERDTreeFile Normal
    hi def link NERDTreeExecFile Title
    hi def link NERDTreeDirSlash Identifier
    hi def link NERDTreeClosable Type
else
    hi def link NERDTreePart Normal
    hi def link NERDTreePartFile Normal
    hi def link NERDTreeFile Normal
    hi def link NERDTreeClosable Title
endif

hi def link NERDTreeBookmarksHeader statement
hi def link NERDTreeBookmarksLeader ignore
hi def link NERDTreeBookmarkName Identifier
hi def link NERDTreeBookmark normal

hi def link NERDTreeHelp String
hi def link NERDTreeHelpKey Identifier
hi def link NERDTreeHelpCommand Identifier
hi def link NERDTreeHelpTitle Macro
hi def link NERDTreeToggleOn Question
hi def link NERDTreeToggleOff WarningMsg

hi def link NERDTreeDir Directory
hi def link NERDTreeUp Directory
hi def link NERDTreeCWD Statement
hi def link NERDTreeLink Macro
hi def link NERDTreeOpenable Title
hi def link NERDTreeFlag ignore
hi def link NERDTreeRO WarningMsg
hi def link NERDTreeBookmark Statement

hi def link NERDTreeCurrentNode Search

hi def link NERDTreeGitStatusModified Special
hi def link NERDTreeGitStatusAdded Function
hi def link NERDTreeGitStatusDeleted Keyword
hi def link NERDTreeGitStatusRenamed Title
hi def link NERDTreeGitStatusUnmerged Label
hi def link NERDTreeGitStatusUntracked Structure
hi def link NERDTreeGitStatusDirDirty Tag
hi def link NERDTreeGitStatusDirClean Type
hi def link NERDTreeGitStatus Number
