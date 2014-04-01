if exists('g:loaded_nerdtree_git_status')
    finish
endif
let g:loaded_nerdtree_git_status = 1

function! plugin:NerdGitStatus()
    if !exists('g:nerdtree_cached_git_status') || g:nerdtree_cached_git_status == '' 
        let g:nerdtree_cached_git_status = system("git status -s")
    endif
    let g:nerdtree_git_status_split = split(g:nerdtree_cached_git_status, '\n')
endfunction

function! plugin:NerdGitStatusRefresh()
    let g:nerdtree_cached_git_status = ''
    let g:nerdtree_git_status_split = []
    call plugin:NerdGitStatus()
endfunction

function! plugin:GetStatusIndicator(us, them)
    if a:us == '?'
        return '✭'
    elseif a:us == 'R'
        return '➜'
    elseif a:us == 'D'
        return '✖'
    elseif a:us == 'U' || a:them == 'U'
        return '═'
    elseif a:us == 'M'
        return '✹'
    elseif a:us == 'A'
        return '✚'
    elseif a:us == ' '
        if a:them == 'M'
            return '✹'
        elseif a:them == 'D'
            return '✖'
        endif
    else
        return '*'
    endif
endfunction

function! plugin:trimDoubleDot(path)
    let s:toReturn = a:path
    let s:find = stridx(s:toReturn, '/../')
    while s:find != -1 
        let s:toReturn = substitute(s:toReturn, '/[^/]\+/\.\./', "/", "")
        let s:find = stridx(s:toReturn, '/../')
    endwhile
    return s:toReturn
endfunction

function! plugin:GetGitStatusPrefix(path)
    for status in g:nerdtree_git_status_split
        let s:reletaivePath = substitute(status, '...', "", "")
        let s:absolutePath = g:NERDTreePath.AbsolutePathFor(s:reletaivePath)
        let s:absolutePath = plugin:trimDoubleDot(s:absolutePath)
        let s:position = stridx(s:absolutePath, a:path.str())
        if s:position != -1 
            if a:path.isDirectory 
                return "[✗]"
            endif
            let s:indicator = plugin:GetStatusIndicator(status[0], status[1])
            return "[" . s:indicator . "]"
        endif
    endfor

    return ""
endfunction
