" ============================================================================
" File:        git_status.vim
" Description: plugin for NERD Tree that provides git status support
" Maintainer:  Xuyuan Pang <xuyuanp at gmail dot com>
" Last Change: 4 Apr 2014
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================
if exists('g:loaded_nerdtree_git_status')
    finish
endif
let g:loaded_nerdtree_git_status = 1

if !exists('g:NERDTreeShowGitStatus')
    let g:NERDTreeShowGitStatus = 1
endif

if !exists('g:NERDTreeMapNextHunk')
    let g:NERDTreeMapNextHunk = "]c"
endif

if !exists('g:NERDTreeMapPrevHunk')
    let g:NERDTreeMapPrevHunk = "[c"
endif

" FUNCTION: plugin:NERDTreeGitStatusRefresh() {{{2
" refresh cached git status
function! plugin:NERDTreeGitStatusRefresh()
    let g:NERDTreeCachedGitFileStatus = {}
    let g:NERDTreeCachedGitDirtyDir   = {}

    if !executable('git')
        call nerdtree#echo("Please install git command first.")
        return
    endif

    let statusStr = system("git status -s")
    let statusSplit = split(statusStr, '\n')
    if statusSplit != [] && statusSplit[0] ==# "fatal: Not a git repository (or any of the parent directories): .git"
        let statusSplit = []
    endif
    for status in statusSplit
        " cache git status of files
        let reletaivePath = substitute(status, '...', "", "")
        let reletaivePath = s:NERDTreeFiltRenameStatus(reletaivePath)
        let absolutePath  = g:NERDTreePath.AbsolutePathFor(reletaivePath)
        let absolutePath  = s:NERDTreeTrimDoubleDot(absolutePath)
        let indicator     = s:NERDTreeGetGitStatusIndicator(status[0], status[1])
        let g:NERDTreeCachedGitFileStatus[absolutePath] = '[' . indicator . ']'

        " cache dirty dir
        let dirtyPath = substitute(absolutePath, '/[^/]*$', "/", "")
        let cwd = getcwd() . '/'
        while dirtyPath =~# cwd
            let g:NERDTreeCachedGitDirtyDir[dirtyPath] = "[✗]"
            let dirtyPath = substitute(dirtyPath, '/[^/]*/$', "/", "")
        endwhile
    endfor
endfunction

function! s:NERDTreeGetGitStatusIndicator(us, them)
    if a:us == '?' && a:them == '?'
        return '✭'
    elseif a:us == ' ' && a:them == 'M'
        return '✹'
    elseif a:us =~# '[MAC]'
        return '✚'
    elseif a:us == 'R'
        return '➜'
    elseif a:us == 'U' || a:them == 'U' || a:us == 'A' && a:them == 'A' || a:us == 'D' && a:them == 'D'
        return '═'
    elseif a:them == 'D'
        return '✖'
    else
        return '*'
    endif
endfunction

function! s:NERDTreeTrimDoubleDot(path)
    let toReturn = a:path
    let find = stridx(toReturn, '/../')
    while find != -1
        let toReturn = substitute(toReturn, '/[^/]\+/\.\./', "/", "")
        let find = stridx(toReturn, '/../')
    endwhile
    return toReturn
endfunction

function! s:NERDTreeFiltRenameStatus(path)
    let toReturn = a:path
    let toReturn = substitute(toReturn, '.* -> ', "", "")
    return toReturn
endfunction

" FUNCTION: plugin:NERDTreeGetGitStatusPrefix(path) {{{2
" return the indicator of the path
" Args: path
function! plugin:NERDTreeGetGitStatusPrefix(path)
    if a:path.isDirectory
        return get(g:NERDTreeCachedGitDirtyDir, a:path.str() . '/', "")
    endif
    return get(g:NERDTreeCachedGitFileStatus, a:path.str(), "")
endfunction

" FUNCTION: s:jumpToNextHunk(node) {{{2
function! s:jumpToNextHunk(node)
    let position = search('\[[^{RO}]\+\]', "")
    if position
        call nerdtree#echo("Jump to next hunk ")
    endif
endfunction

" FUNCTION: s:jumpToPrevHunk(node) {{{2
function! s:jumpToPrevHunk(node)
    let position = search('\[[^{RO}]\+\]', "b")
    if position
        call nerdtree#echo("Jump to prev hunk ")
    endif
endfunction

" Function: s:SID()   {{{2
function s:SID()
    if !exists("s:sid")
        let s:sid = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
    endif
    return s:sid
endfun

" FUNCTION: s:NERDTreeGitStatusKeyMapping {{{2
function! s:NERDTreeGitStatusKeyMapping()
    let s = '<SNR>' . s:SID() . '_'
    call NERDTreeAddKeyMap({'key': g:NERDTreeMapNextHunk, 'scope': "Node", 'callback': s."jumpToNextHunk"})
    call NERDTreeAddKeyMap({'key': g:NERDTreeMapPrevHunk, 'scope': "Node", 'callback': s."jumpToPrevHunk"})
endfunction

call s:NERDTreeGitStatusKeyMapping()
