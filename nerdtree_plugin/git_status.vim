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

" FUNCTION: plugin:NERDTreeCacheGitStatus() {{{2
" cache the git status
function! plugin:NERDTreeCacheGitStatus()
    if !exists('g:NERDTreeCachedGitStatus') || g:NERDTreeCachedGitStatus == '' 
        let g:NERDTreeCachedGitStatus = system("git status -s")
    endif
    let g:NERDTreeGitStatusSplit = split(g:NERDTreeCachedGitStatus, '\n')
    if g:NERDTreeGitStatusSplit != [] && g:NERDTreeGitStatusSplit[0] == "fatal: Not a git repository (or any of the parent directories): .git"
        let g:NERDTreeGitStatusSplit = []
    endif
endfunction

" FUNCTION: plugin:NERDTreeGitStatusRefresh() {{{2
" refresh cached git status
function! plugin:NERDTreeGitStatusRefresh()
    let g:NERDTreeCachedGitStatus = ''
    let g:NERDTreeGitStatusSplit = []
    call plugin:NERDTreeCacheGitStatus()
endfunction

function! s:NERDTreeGetGitStatusIndicator(us, them)
    if a:us == '?' && a:them == '?'
        return '✭'
    elseif a:us == ' ' && a:them == 'M'
        return '✹'
    elseif match(a:us, '[MAC]') != -1
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
    let s:toReturn = a:path
    let s:find = stridx(s:toReturn, '/../')
    while s:find != -1 
        let s:toReturn = substitute(s:toReturn, '/[^/]\+/\.\./', "/", "")
        let s:find = stridx(s:toReturn, '/../')
    endwhile
    return s:toReturn
endfunction

function! s:NERDTreeFiltRenameStatus(path)
    let s:toReturn = a:path
    let s:toReturn = substitute(s:toReturn, '.* -> ', "", "")
    return s:toReturn
endfunction

" FUNCTION: plugin:NERDTreeGetGitStatusPrefix(path) {{{2
" return the indicator of the path
" Args: path 
function! plugin:NERDTreeGetGitStatusPrefix(path)
    for status in g:NERDTreeGitStatusSplit
        let s:reletaivePath = substitute(status, '...', "", "")
        let s:reletaivePath = s:NERDTreeFiltRenameStatus(s:reletaivePath)
        let s:absolutePath = g:NERDTreePath.AbsolutePathFor(s:reletaivePath)
        let s:absolutePath = s:NERDTreeTrimDoubleDot(s:absolutePath)
        let s:position = stridx(s:absolutePath, a:path.str())
        if s:position != -1 
            if a:path.isDirectory 
                return "[✗]"
            endif
            let s:indicator = s:NERDTreeGetGitStatusIndicator(status[0], status[1])
            return "[" . s:indicator . "]"
        endif
    endfor

    return ""
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
