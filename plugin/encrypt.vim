let g:encryptprg = "aescrypt -e -"
let g:decryptprg = "aescrypt -d -"

function! Encrypt()
    let l:content = join(getline(1, "$"), "\n")
    silent let l:encrypted = system("echo -e \""..l:content.."\" | "..g:encryptprg)    
    normal! ggdG
    call setline(1, l:encrypted)
endfunction

function! Decrypt()
    let l:content = getline(1)
    echo "content: "..l:content
    let l:decrypted = system("echo \""..l:content.."\" | "..g:decryptprg)    
    echo "decrypted: "..l:decrypted
    normal! ggdG
    call setline(1, split(l:decrypted, "\n"))
endfunction
