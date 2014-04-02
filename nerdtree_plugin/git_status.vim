if exists('g:loaded_nerdtree_git_status')
    finish
endif
let g:loaded_nerdtree_git_status = 1

if !exists('g:nerdtree_show_git_status')
    let g:nerdtree_show_git_status = 1
endif

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

function! plugin:GetGitStatusPrefix(path)
    let git_statuses = system('git status -s ' . a:path.str())
    let git_statuses_split = split(git_statuses, "\n")
    if git_statuses_split != []
        if a:path.isDirectory
            return "[✗]"
        endif
        let status = git_statuses_split[0]
        let indicator = plugin:GetStatusIndicator(status[0], status[1])
        return "[" . indicator . "]"
    endif
    return ""
endfunction
