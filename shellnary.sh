#!/bin/bash
LC_ALL="C"

ord() { printf '%d' "'$1"; }

read_lei64() {
    local byte;
    local i;
    declare -ai num;
    for i in {0..7}; do
        byte='';
        IFS='' read -r -d '' -u $1 -n1 byte;
        if [ -z "$byte" ]; then
            num[$i]=0;
        else
            num[$i]=$(ord "$byte");
        fi
    done
    echo $(( (num[7] << 56) +(num[6] << 48) + (num[5] << 40) + (num[4] << 32) + (num[3] << 24) + (num[2] << 16) + (num[1] << 8) + num[0] ));
}

read_bei64() {
    local byte;
    local i;
    declare -ai num;
    for i in {0..7}; do
        byte='';
        IFS='' read -r -d '' -u $1 -n1 byte;
        if [ -z "$byte" ]; then
            num[$i]=0;
        else
            num[$i]=$(ord "$byte");
        fi
    done
    echo $(( (num[0] << 56) + (num[1] << 48) + (num[2] << 40) + (num[3] << 32) + (num[4] << 24) + (num[5] << 16) + (num[6] << 8) + num[7] ));
}

read_leu32() {
    local byte;
    local i;
    declare -ai num;
    for i in {0..3}; do
        byte='';
        IFS='' read -r -d '' -u $1 -n1 byte;
        if [ -z "$byte" ]; then
            num[$i]=0;
        else
            num[$i]=$(ord "$byte");
        fi
    done
    echo $(( (num[3] << 24) + (num[2] << 16) + (num[1] << 8) + num[0] ));
}

read_lei32() {
    declare -i num=$(read_leu32 "$@");
    echo $(( num | ~((((num & 0x80000000) >> 31) - 1) | 0xffffffff) ))
}

read_beu32() {
    local byte;
    local i;
    declare -ai num;
    for i in {0..3}; do
        byte='';
        IFS='' read -r -d '' -u $1 -n1 byte;
        if [ -z "$byte" ]; then
            num[$i]=0;
        else
            num[$i]=$(ord "$byte");
        fi
    done
    echo $(( (num[0] << 24) + (num[1] << 16) + (num[2] << 8) + num[3] ));
}

read_bei32() {
    declare -i num=$(read_beu32 "$@");
    echo $(( num | ~((((num & 0x80000000) >> 31) - 1) | 0xffffffff) ))
}

read_leu16() {
    local byte;
    local i;
    declare -ai num;
    for i in {0..1}; do
        byte='';
        IFS='' read -r -d '' -u $1 -n1 byte;
        if [ -z "$byte" ]; then
            num[$i]=0;
        else
            num[$i]=$(ord "$byte");
        fi
    done
    echo $(( (num[1] << 8) + num[0] ));
}

read_lei16() {
    declare -i num=$(read_leu16 "$@");
    echo $(( num | ~((((num & 0x8000) >> 15) - 1) | 0xffff) ))
}

read_beu16() {
    local byte;
    local i;
    declare -ai num;
    for i in {0..1}; do
        byte='';
        IFS='' read -r -d '' -u $1 -n1 byte;
        if [ -z "$byte" ]; then
            num[$i]=0;
        else
            num[$i]=$(ord "$byte");
        fi
    done
    echo $(( (num[0] << 8) + num[1] ));
}

read_bei16() {
    declare -i num=$(read_beu16 "$@");
    echo $(( num | ~((((num & 0x8000) >> 15) - 1) | 0xffff) ))
}

read_u8() {
    local byte;
    declare -ai num;
    IFS='' read -r -d '' -u $1 -n1 byte;
    if [ -z "$byte" ]; then
        num=0;
    else
        num=$(ord "$byte");
    fi
    echo $num;
}

read_i8() {
    declare -i num=$(read_u8 "$@");
    echo $(( num | ~((((num & 0x80) >> 7) - 1) | 0xff) ))
}

forward_seek() { # read $1 bytes and throw them away
    declare -i n=$1;
    while read -r -d '' -u $2 -n $n; do
        local len=$(( ${#REPLY} + 1 ));
        if [ $len -lt $n ]; then
            (( n -= $len ));
        else
            break;
        fi
    done
}

print_as_u64() {
    local str;
    declare -i num=$1;

    if [ $num -lt 0 ]; then
        (( num ^= 1 << 63));
        local lastdigit=${num:$((${#num}-1)):1}

        str=$(( ($lastdigit + 8) % 10 ));
        (( num /= 10 ));

        (( num += 922337203685477580));
        if [ $lastdigit -ge 2 ]; then
            (( ++num ));
        fi
        while [ $num -ne 0 ]; do
            str=$(( num % 10 ))$str;
            (( num /= 10 ));
        done
        echo $str;
    else
        echo $1;
    fi

}
