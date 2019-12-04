read input

lower_bound=${input//-*/}
upper_bound=${input//*-/}
count=0

for password in $(seq $lower_bound $upper_bound)
do
    has_adjecent=0
    all_ascending=1

    for i in $(seq 2 ${#password})
    do
        a=${password:i - 2:1}
        b=${password:i - 1:1}

        if [[ $a -eq $b ]]; then
            has_adjecent=1
        fi

        if [[ $a -gt $b ]]; then
            all_ascending=0
        fi
    done

    if [[ $has_adjecent -eq 1 && $all_ascending -eq 1 ]]; then
        count=$((count + 1))
    fi
done

echo $count
