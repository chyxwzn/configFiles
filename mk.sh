#!/bin/bash

LUNCH_MENU_CHOICES=()
LUNCH_MENU_COMMENTS=()

MAKE_LIST_FILE=$HOME/make_list.txt

function add_automake_combo()
{
    local new_combo=$1
    local c
    for c in "${LUNCH_MENU_CHOICES[@]}"; do
        if [[ "$new_combo" = "$c" ]]; then
            return
        fi
    done
    LUNCH_MENU_CHOICES=("${LUNCH_MENU_CHOICES[@]}" "$new_combo")
}

function add_comment_combo()
{
    local new_combo=$1
    local c
    for c in "${LUNCH_MENU_COMMENTS[@]}"; do
        if [[ "$new_combo" = "$c" ]]; then
            return
        fi
    done
    LUNCH_MENU_COMMENTS=("${LUNCH_MENU_COMMENTS[@]}" "$new_combo")
}

function parse_make_list()
{
    if ! [[ -f $MAKE_LIST_FILE ]]; then
        echo $MAKE_LIST_FILE "doesn't exists"
        exit 1
    fi
    while read line; do
        # lines start with # are comments
        if (echo -n "$line" | grep -q -e '#.*'); then
            add_comment_combo "$((${#LUNCH_MENU_CHOICES[@]}+1))_$line"
        else
            add_automake_combo "$line"
        fi
    done < $MAKE_LIST_FILE
}

function print_automake_menu()
{
    echo "Make list... pick a combo:"

    local i=1
    local choice
    for choice in "${LUNCH_MENU_CHOICES[@]}"; do
        local j=1
        local comment
        for comment in "${LUNCH_MENU_COMMENTS[@]}"; do
            echo "  $comment" | sed -n -e "s/${i}_//p"
            j=$(($j+1))
        done
        echo "  $i. $choice"
        i=$(($i+1))
    done

    echo
}

function automake()
{
    local answer
    local mosesq=0
    local show_list=1
    
    parse_make_list
    if (echo -n $1 | grep -q -e "^[0-9][0-9]*$"); then
        answer=$1
        show_list=0
    else
        if [[ $1 == 'mosesq' ]]; then
            mosesq=1
            if (echo -n $2 | grep -q -e "^[0-9][0-9]*$"); then
                answer=$2
                show_list=0
            fi
        fi
    fi
    if [[ $show_list == 1 ]]; then
        print_automake_menu
        echo -n "Which would you like? "
        read answer
    fi

    local selection=

    if (echo -n $answer | grep -q -e "^[0-9][0-9]*$"); then
        if [[ $answer -le ${#LUNCH_MENU_CHOICES[@]} ]]; then
            selection=${LUNCH_MENU_CHOICES[$(($answer-1))]}
        fi
    fi
    if [[ -z "$selection" ]]; then
        echo
        echo "Invalid combo: $answer"
        exit 1
    fi
    if [[ $mosesq == 1 ]]; then
        mosesq $selection
    else
        $selection
    fi
}

automake $@
