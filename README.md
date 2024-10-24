# vim-encrypt

A Vim plugin for encrypting and decrypting text using the age command-line tool.

## Features

- Encrypt text directly within Vim.
- Decrypt text and insert it into the Vim buffer.
- Define custom encryption and decryption commands.

## Installation

1. Ensure you have the 'age' command-line tool installed and accessible in your PATH.
2. Install the plugin using your preferred Vim plugin manager.

## Configuration

The following global variables can be set in your `.vimrc`:

```viml
let g:encryptprg = "age -e"  " Command used for encryption
let g:decryptprg = "age -d"  " Command used for decryption
let g:dependency = ["age"]  " List of required dependencies
```

## Commands

- `:Encrypt <file>` - Encrypts the selected text or entire buffer and saves it to {file}.
- `:[range]Encrypt <file>` - Encrypts the selected text within the specified range and saves it to {file}.
- `:Decrypt <file>` - Decrypts the content of {file} and inserts it into the current buffer.

## Examples

```
:Encrypt secret.txt
:'<,'>Encrypt selected_text.enc
:Decrypt encrypted_file.txt
```
