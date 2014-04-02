if exists('g:loaded_nerdtree_git_status')
    finish
endif
let g:loaded_nerdtree_git_status = 1

if !exists('g:nerdtree_show_git_status')
    let g:nerdtree_show_git_status = 1
endif

function! plugin:NERDTreeCacheGitStatus()
    if !exists('g:nerdtree_cached_git_status') || g:nerdtree_cached_git_status == '' 
        let g:nerdtree_cached_git_status = system("git status -s")
    endif
    let g:nerdtree_git_status_split = split(g:nerdtree_cached_git_status, '\n')
    if g:nerdtree_git_status_split != [] && g:nerdtree_git_status_split[0] == "fatal: Not a git repository (or any of the parent directories): .git"
        let g:nerdtree_git_status_split = []
    endif
endfunction

function! plugin:NERDTreeGitStatusRefresh()
    let g:nerdtree_cached_git_status = ''
    let g:nerdtree_git_status_split = []
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

function! plugin:NERDTreeGetGitStatusPrefix(path)
    for status in g:nerdtree_git_status_split
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
