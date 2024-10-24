let g:encryptprg = "age -e"
let g:decryptprg = "age -d"
let g:dependency = ["age"]

function! CheckDependencies()
    for dep in g:dependency
        if !executable(dep)
            echohl ErrorMsg | echomsg "Dependency ".dep." not found" | echohl None
            return 1
        endif
    endfor
    return 0
endfunction

function! Encrypt(is_selection, file) range
    if CheckDependencies() | return | endif

    let l:content = a:is_selection 
        \? join(getline(a:firstline, a:lastline), "\n") 
        \: join(getline(1, "$"), "\n")

    let l:cmd = "echo -e ".shellescape(l:content)." | ".g:encryptprg." -p -a -o ".a:file." -"
    let l:result = system(l:cmd)

    if v:shell_error != 0
        echohl ErrorMsg | echomsg l:result | echohl None
        return
    endif

    echo "Encrypted to ".a:file
endfunction

function! Decrypt(file)
    if CheckDependencies() | return | endif

    if !filereadable(a:file)
        echohl ErrorMsg | echomsg "File not found" | echohl None
        return
    endif

    let l:cmd = "cat ".a:file." | ".g:decryptprg." -o - -"
    let l:decrypted = system(l:cmd)

    if v:shell_error != 0
        echohl ErrorMsg | echomsg l:decrypted | echohl None
        return
    endif

    let l:exec = getline('.') =~ '^\s*$' ? "normal! i" : "normal! o"
    execute l:exec.l:decrypted

    echo "Decrypted to buffer"
endfunction

command! -range -nargs=1 -complete=file Encrypt <line1>,<line2>call Encrypt(<range>, <f-args>)
command! -nargs=1 -complete=file Decrypt call Decrypt(<f-args>)
