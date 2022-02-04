let g:encryptprg = "aescrypt -e -"

function! Encrypt()
    let l:content = join(getline(1, "$"))
    let l:encrypted = system("echo -e \""..l:content.."\" | "..g:encryptprg)    
    echo "encrypted: "..l:encrypted
endfunction
