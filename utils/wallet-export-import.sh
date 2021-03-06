#!/bin/bash

from_path="$HOME/.UChain/mainnet"
to_path="$HOME/.UChain/mainnet"
tarball_account=uc-linux-export-account.tar.gz
tarball_block=uc-linux-export-blockdata.tar.gz

########################### database files ################################

block_data_arr="address_token_row address_token_table block_index history_rows metadata spend_table transaction_table token_table block_table history_table stealth_rows"
account_arr="account_table account_token_table account_token_row account_address_table account_address_rows"

########################### functions ################################

function usage()
{
    echo "$0 : from_path and to_path defaults to ~/UChain, if not specified."
    echo "   --export-account <from_path>."
    echo "   --export-blockdata <from_path>."
    echo "   --import-account <to_path>."
    echo "   --import-blockdata <to_path>."
}

function tar_files()
{
    #path name
    cd $1 $2
    tar -czvf $2 $3
    for i in "${argAry[@]}"
    do
        echo "copying... $i"
        /bin/cp "$1/$i" "$2/$i";
    done
}

########################### main entry ################################
# -----------------------------------
if [ $# -gt 2 ] || [ $# -eq 0 ];then
    usage
    exit 0
fi

# -----------------------------------
lines=`ps -ef | grep ucd | wc -l`
if [ $lines -gt 1 ];then
    echo "It seems ucd still runing, need to stop firstly."
    exit 0
fi

# -----------------------------------
while [ $# -gt 0 ];do
    case $1 in
        --export-account)
            shift
	        if [ x"" != x"$1" ];then
                from_path=$1
            fi
            mypath=`pwd`
            cd $from_path
            if ! tar -czvf $tarball_account $account_arr;then
                echo "export failure."
                exit 1
            fi
            mv $from_path/$tarball_account $mypath
            echo "$tarball_account was generated."
            ;;
        --export-blockdata)
            shift
	        if [ x"" != x"$1" ];then
                from_path=$1
            fi
            mypath=`pwd`
            cd $from_path
            if ! tar -czvf $tarball_block $block_data_arr;then
                echo "export failure."
                exit 1
            fi
            mv $from_path/$tarball_block $mypath
            echo "$tarball_block was generated."
            ;;
        --import-account)
            shift
	        if [ x"" != x"$1" ];then
                to_path=$1
            fi
            if [ ! -f $tarball_account ];then
                echo "$tarball_account not found in current folder."
                exit 1
            fi
            tar -xzvf $tarball_account -C $to_path
            echo "$tarball_account has been imported into $to_path."
            ;;
        --import-blockdata)
            shift
	        if [ x"" != x"$1" ];then
                to_path=$1
            fi
            if [ ! -f $tarball_block ];then
                echo "$tarball_block not found in current folder."
                exit 1
            fi
            tar -xzvf $tarball_block -C $to_path
            echo "$tarball_block has been imported into $to_path."
            ;;
        -h)
            usage
            exit 0
            ;;
        --help)
            usage
            exit 0
            ;;
        \?)
            usage
            exit 0
            ;;
	esac
done

