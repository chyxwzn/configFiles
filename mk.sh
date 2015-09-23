#!/bin/bash

function add_lunch_combo()
{
    local new_combo=$1
    local c
    for c in ${LUNCH_MENU_CHOICES[@]}; do
        if [[ "$new_combo" = "$c" ]]; then
            return
        fi
    done
    LUNCH_MENU_CHOICES=(${LUNCH_MENU_CHOICES[@]} $new_combo)
}

function parse_make_list()
{

}

function print_lunch_menu()
{
    echo "Lunch menu... pick a combo:"

    local i=1
    local choice
    for choice in ${LUNCH_MENU_CHOICES[@]}; do
        echo "  $i. $choice"
        i=$(($i+1))
    done

    echo
}

function lunch()
{
    local answer
    local mosesq=
    
    if (echo -n $1 | grep -q -e "^[0-9][0-9]*$"); then
        answer=$1
    elif [[ $1 = 'mosesq' ]]; then
        mosesq=1
        if (echo -n $1 | grep -q -e "^[0-9][0-9]*$"); then
            answer=$1
        fi
    else
        parse_make_list
        print_lunch_menu
        echo -n "Which would you like? "
        read answer
    fi

    local selection=

    if (echo -n $answer | grep -q -e "^[0-9][0-9]*$"); then
        if [[ $answer -le ${#LUNCH_MENU_CHOICES[@]} ]]; then
            selection=${LUNCH_MENU_CHOICES[$(($answer-1))]}
        fi
    fi
}
