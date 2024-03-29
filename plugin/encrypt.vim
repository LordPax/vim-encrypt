let g:encryptprg = "aescrypt -e"
let g:decryptprg = "aescrypt -d"
let g:dependency = ["aescrypt"]

function! Input(txt)
    call inputsave()
    let l:val = inputsecret(a:txt)
    call inputrestore()
    return l:val ==# "" ? Input(a:txt) : l:val
endfunction

function! CheckDependencies()
    for dep in g:dependency
        if !executable(dep)
            echohl ErrorMsg | echo "Dependency ".dep." not found" | echohl None
            return 1
        endif
    endfor
    return 0
endfunction

function! Encrypt(is_selection, file) range
    if CheckDependencies() | return | endif

    let l:password = Input("Enter password: ")
    let l:passwordRep = Input("\nRe-enter password: ")

    if l:password != l:passwordRep
        echohl ErrorMsg | echo "\nPasswords do not match" | echohl None
        return
    endif

    let l:content = a:is_selection 
        \? join(getline(a:firstline, a:lastline), "\n") 
        \: join(getline(1, "$"), "\n")

    let l:cmd = "echo -e ".shellescape(l:content)." | ".g:encryptprg." -p ".shellescape(l:password)." -o ".a:file." -"
    call system(l:cmd)

    if v:shell_error != 0
        echohl ErrorMsg | echo "Encryption failed" | echohl None
        return
    endif
endfunction

function! Decrypt(file)
    if CheckDependencies() | return | endif

    if !filereadable(a:file)
        echohl ErrorMsg | echo "File not found" | echohl None
        return
    endif

    let l:password = Input("Enter password: ")
    let l:cmd = "cat ".a:file." | ".g:decryptprg." -p ".shellescape(l:password)." -"
    let l:decrypted = system(l:cmd)

    if v:shell_error != 0
        echohl ErrorMsg | echo "\nDecryption failed" | echohl None
        return
    endif

    let l:exec = getline('.') =~ '^\s*$' ? "normal! i" : "normal! o"
    execute l:exec.l:decrypted
endfunction

command! -range -nargs=1 -complete=file Encrypt <line1>,<line2>call Encrypt(<range>, <f-args>)
command! -nargs=1 -complete=file Decrypt call Decrypt(<f-args>)
