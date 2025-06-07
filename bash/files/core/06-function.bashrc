#!/usr/bin/env bash

# description:
#   initialize bashrc by sourcing all *.bashrc files in BASHRC_HOME
# arguments:
#   none
# returns:
#   0 - success
#   1 - BASHRC_HOME not set or directory does not exist
# usage:
#   init_bashrc
init_bashrc() {
    [ -n "$BASHRC_HOME" ] || { echo "\$BASHRC_HOME must be set" >&2; return 1; }
    [ -d "$BASHRC_HOME" ] || { echo "directory does not exist: $BASHRC_HOME" >&2; return 1; }
    
    local found=0
    for file in "$BASHRC_HOME"/*.bashrc; do 
        [ -f "$file" ] || continue
        # shellcheck disable=SC1090
        . "$file"
        found=1
    done
    
    [ "$found" -eq 0 ] && echo "No .bashrc files found in $BASHRC_HOME" >&2
}

# description:
#   set terminal tab name
#   if tabname is not provided, the tab name is reset to default
# arguments:
#   tabname - tab name (optional)
# usage:
#   set_tabname [tabname]
#   e.g.: set_tabname foo
#   e.g.: set_tabname
set_tabname() {
    echo -en "\033]0;$1\a"
}

# description:
#   highlight pattern in the given input
# arguments:
#   pattern - pattern to highlight
# usage:
#   highlight <pattern>
#   cat <file> | highlight foo
#   cat <file> | highlight "foo\|bar"
#   cat <file> | highlight "foo\|bar" | less -r
highlight() {
    [ -n "$1" ] || { log_error "pattern argument required"; return 1; }
    local escape color=31
    escape=$(printf '\033')
    sed "s,${1},${escape}[${color}m&${escape}[0m,g"
}

# description:
#   encode string to base64
# arguments:
#   string - string to encode
# usage:
#   b64enc <string>
#   b64enc foo
b64enc() {
    [ -n "$1" ] || { log_error "string argument required"; return 1; }
    echo -n "$1" | base64
}

# description:
#   decode base64 string
# arguments:
#   string - string to decode
# usage:
#   b64dec <string>
#   b64dec Zm9v
b64dec() {
    [ -n "$1" ] || { log_error "string argument required"; return 1; }
    echo -n "$1" | base64 -d
}

# description:
#   encrypt file
# arguments:
#   file - file to encrypt
# usage:
#   fencrypt <file>
#   fencrypt foobar.txt
fencrypt() {
    [ -n "$1" ] || { log_error "file argument required"; return 1; }
    [ -f "$1" ] || { log_error "file \"$1\" does not exist"; return 1; }
    [ -f "$1.enc" ] && { log_error "encrypted file already exists"; return 1; }
    openssl enc -aes-256-cbc -e -pbkdf2 -iter 10000 -in "$1" -out "$1".enc
}

# description:
#   decrypt file
# arguments:
#   file - file to decrypt
# usage:
#   fdecrypt <file>
#   fdecrypt foobar.txt.enc
fdecrypt() {
    [ -n "$1" ] || { log_error "file argument required"; return 1; }
    [ -f "$1" ] || { log_error "file \"$1\" does not exist"; return 1; }
    
    case "$1" in
        *.enc) ;;
        *) log_error "file should have .enc extension"; return 1 ;;
    esac
    
    openssl enc -aes-256-cbc -d -pbkdf2 -iter 10000 -in "$1" -out "${1%.enc}"
}

# description:
#   create a directory and cd into it
# arguments:
#   directory - directory to create
# usage:
#   mkcd <directory>
#   mkcd foobar
mkcd() { 
    [ -n "$1" ] || { log_error "directory argument required"; return 1; }
    mkdir -p "$1" && cd "$1" || return
}

# description:
#   backup a file or directory
# arguments:
#   file or directory - file or directory to backup
# usage:
#   backup <file|directory>
#   backup foobar
backup() {
	[ -n "$1" ] || { log_error "file or directory argument required"; return 1; }
	[ -e "$1" ] || { log_error "file \"$1\" does not exist"; return 1; }
    cp -r "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

# description:
#   backup a file or directory to BACKUP_DIR
# arguments:
#   file or directory - file or directory to backup
# usage:
#   backup_to_dir <file|directory>
#   backup_to_dir foobar
backup_to_dir() {
	[ -n "$1" ] || { log_error "file or directory argument required"; return 1; }
	[ -n "$BACKUP_DIR" ] || { log_error "BACKUP_DIR environment variable not set"; return 1; }
	[ -d "$BACKUP_DIR" ] || mkdir -p "$BACKUP_DIR"
    
    local basename
	basename=$(basename "$1")
    cp -r "$1" "$BACKUP_DIR/${basename}.bak.$(date +%Y%m%d_%H%M%S)"
}
