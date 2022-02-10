let g:encryptprg = "aescrypt -e"
let g:decryptprg = "aescrypt -d"

function Input(txt)
    call inputsave()
    let l:val = input(a:txt)
    call inputrestore()
    return l:val
endfunction

function Encrypt()
    let l:password = Input("Enter password: ")
    let l:passwordRep = Input("\nRe-enter password: ")

    if l:password == l:passwordRep
        let l:content = join(getline(1, "$"), "\n")
        let l:encrypted = system("echo -e \""..l:content.."\" | "..g:encryptprg.." -p \""..l:password.."\" -")
        normal ggdG
        call setline(1, split(l:encrypted, "\n"))
    else
        echo "\npassword are different"
    endif
endfunction

function Decrypt()
    let l:password = Input("Enter password: ")

    let l:content = join(getline(1, "$"), "\n")
    echo "content: "..l:content
    let l:decrypted = system("echo \""..l:content.."\" | "..g:decryptprg.." -p \""..l:password.."\" -")    
    echo "decrypted: "..l:decrypted
    normal ggdG
    call setline(1, split(l:decrypted, "\n"))
endfunction

command Encrypt call Encrypt()
command Decrypt call Decrypt()
