#!/bin/bash

declare -a board
declare -a letters=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
rows=4

initialize() {
	count=1
	maxcount=$1
	while [ $count -le $maxcount ] ; do
        addon=$((13 * ($count - 1)))
        for slot in {1..13}; do
            index=$(($addon + $slot))
            letter=$(($index % 26))
            board[$index]="-${letters[$letter]}"
        done
        count=$(($count + 1))
    done
}

shuffle() {
    totalvalues=$(($1 * 13))
    index=$totalvalues
    while [ $index -gt 1 ] ; do
        randval=$((($RANDOM % $index) + 1))

        # swapping value pair
        temp=${board[$index]}
        board[$index]=${board[$randval]}
        board[$randval]=$temp

        index=$(($index - 1))
    done
}

showgrid() {
    count=1
    echo "    1   2   3   4   5   6   7   8   9   10  11  12  13"
    while [ $count -le $rows ] ; do
        /bin/echo -n "$count: "
        addon=$((13 * ($count - 1)))

        for slot in {1..13}; do
            index=$(($slot + $addon))
            value=${board[$index]}
            if [ ${value:0:1} != '-' ] ; then
                /bin/echo -n "<${board[$index]}> "
            else
                /bin/echo -n "<-> "
            fi
        done
        echo ""
        count=$(($count + 1))
    done
}

if [ $# -gt 0 ] ; then
    rows=$1
fi

if [ $(($rows % 4)) -ne 0 ] ; then
    echo "Ooops! Please specify a mulitple of 4 as the number of rows (4, 8, 12, etc)"
    exit 1
fi

slot1=slot2="X"
unsolved=$(($rows * 13))
maxvalues=$unsolved

echo "Welcom to PAIRS. Your mission is to identify matching letters in the grid."
echo "Good lock. If you give up at any point. just use q to quit."
echo ""

initialize $rows
shuffle $rows
showgrid

while [ $unsolved -gt 0 ] ; do
    echo ""
    /bin/echo -n "Enter a pair of values in row, col format : "
    read slot1 slot2

    if [ "$slot1" = "q" ] ; then
        echo "bye"
        break
    fi

    if [ "$slot1" = "" -o "$slot2" = "" ] ; then 
        echo "only one slot is reade"
        continue
    fi

    row1=$(echo $slot1 | cut -c1)
    col1=$(echo $slot1 | cut -d, -f2)
    row2=$(echo $slot2 | cut -c1)
    col2=$(echo $slot2 | cut -d, -f2)

    index1=$((($row1 - 1) * 13 + $col1))
    index2=$((($row2 - 1) * 13 + $col2))

    if [ $index1 -lt 0 -o $index1 -gt $maxvalues -o $index2 -lt 0 -o $index2 -gt $maxvalues ] ; then
        echo "bad input, not a valid value"
        continue
    fi

    val1=${board[$index1]}
    val2=${board[$index2]}

    if [ $val1 = $val2 ] ; then
        echo "You've got a match. Nicely done!"
        board[$index1]=${val1:1:1}
        board[$index2]=${val2:1:1}
        unsolved=$(($unsolved - 2))
    else
        echo "No match, but $row1,$col1 = ${val1:1:1} and $row2,$col2 = ${val2:1:1}."
    fi

    echo ""
    showgrid

done

exit 0




