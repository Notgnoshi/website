#!/bin/bash
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export RED=$(tput setaf 1)
export BLUE=$(tput setaf 4)
export RESET=$(tput sgr0)

__resolve_redirect() {
    curl -Ls -o /dev/null -w "$1\t%{url_effective}\t%{response_code}" "$1"
}

resolve_redirect() {
    response="$(__resolve_redirect "$1")"
    url="$(echo "$response" | cut -f1)"
    redirect="$(echo "$response" | cut -f2)"
    status="$(echo "$response" | cut -f3)"

    if [[ "$status" =~ 2.. ]]; then
        status="${GREEN}$status${RESET}"
    elif [[ "$status" =~ 3.. ]]; then
        status="${BLUE}$status${RESET}"
    elif [[ "$status" =~ 5.. ]]; then
        status="${YELLOW}$status${RESET}"
    else
        status="${RED}$status${RESET}"
    fi

    echo -e "$url\t$redirect\t$status"
}

urls=(
    ""
    /
    /index.html
    # Can't decide what this should rewrite to
    /index
    /css
    /css/
    /css/index.html
    /vim
    /vim/
    /vim/index.html
    # Can't decide what this should rewrite to
    /vim/index
    /vim.html
    /vim/text-objects
    /vim/text-objects/
    /vim/text-objects.html
    /vim/text-objects/index.html
    /graphviz
    /graphviz/
    /graphviz.html
    # This doesn't exist, but should still get redirected.
    /graphviz/index.html
    /404.html
    /blog/product-spaces
    /blog/product-spaces/
    /blog/product-spaces.html
    /blog/product-spaces/index.html
)

check_all_redirects() {
    for url in "${urls[@]}"; do
       resolve_redirect "http://localhost$url"
    done
}

check_all_redirects | column -t -N "URL,Resolved URL,HTTP Status"
