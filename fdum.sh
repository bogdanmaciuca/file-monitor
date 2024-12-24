#!/bin/sh

fdum_init() {
  if [ ! -d ".fdum" ]; then
    mkdir .fdum
    echo "Directory .fdum created."
  fi
}

fdum_snap() {
    last_added=$(ls -l -tr .fdum | awk 'NR>1{print $9}' | tail -n 1)
    if [ last_added = "" ]; then
        filename=".fdum/1"
    else
        filename=".fdum/$(($last_added+1))"
    fi
    size=$(du -bs --exclude=./.fdum | awk '{print $1}')
    contents=$(ls -l -tr | awk 'NR>1{print $9}')
    echo -e "${size}\n${contents}" > $filename
}

fdum_list() {
    ls -l -tr .fdum | awk 'NR>1{printf "%s-%s-%s     %s\n",$6,$7,$8,$9}'
}

# Arguments: the two snapshots to be compared (no .fdum/ prefix)
_fdum_diff_util () {
    first=$1
    second=$2
    # Swap the snapshots so that they are in the right order
    if [ "$1" -gt "$2" ]; then
        second=$1
        first=$2
    fi

    echo "$(($(cat .fdum/$first | head -n 1) / 1000))KB -> $(($(cat .fdum/$second | head -n 1) / 1000))KB"

    sort .fdum/$first | tail -n+2 > .fdum/sorted1
    sort .fdum/$second | tail -n+2 > .fdum/sorted2
    echo "$(comm -23 .fdum/sorted1 .fdum/sorted2)" > .fdum/fdum_temp_1
    echo "$(comm -13 .fdum/sorted1 .fdum/sorted2)" > .fdum/fdum_temp_2
    echo -e "Deleted|Added\n$(paste -d '|' .fdum/fdum_temp_1 .fdum/fdum_temp_2)" | column -t -s '|'
    rm .fdum/fdum_temp_1 .fdum/fdum_temp_2 .fdum/sorted1 .fdum/sorted2
}

fdum_diff_no_args() {
    last_added=$(ls -l -tr .fdum | awk 'NR>1{print $9}' | tail -n 1)
    if [ -z $last_added ]; then
        echo "No previous snapshot exists!"
        return 1
    fi
    fdum_snap
    _fdum_diff_util "$last_added" "$((last_added+1))"
    rm ".fdum/$((last_added+1))"
}

# Argument: the snapshot to compare the current state to
fdum_diff_one_arg() {
    fdum_snap
    if [ ! -f ".fdum/$1" ]; then
        echo "Snapshot $1 does not exist!"
        return 1
    fi
    last_added=$(ls -l -tr .fdum | awk 'NR>1{print $9}' | tail -n 1)

    _fdum_diff_util "$1" "$last_added"
}

# Arguments: the 2 snapshots to be compared
fdum_diff_2_args() {
    # Checking if the files exist
    if [ ! -f ".fdum/$1" ]; then
        echo "Snapshot $1 does not exist!"
        return 1
    fi
    if [ ! -f ".fdum/$2" ]; then
        echo "Snapshot $2 does not exist!"
        return 1
    fi

    _fdum_diff_util "$1" "$2"
}

if [ $# = 1 ]; then
    if [ "$1" = "diff" ]; then
        fdum_diff_no_args
    elif [ "$1" = "snap" ]; then
        fdum_init # Check if the .fdum directory exists (if not, create it)
        fdum_snap
    elif [ "$1" = "list" ]; then
        fdum_list
    else
        echo "Unknown argument: $1"
    fi
elif [ $# = 2 ]; then
    if [ "$1" = "diff" ]; then
        fdum_diff_one_arg "$2"
    else
        echo "Unknown command: $1"
    fi
elif [ $# = 3 ]; then
    if [ $1 = "diff" ]; then
        fdum_diff_2_args "$2" "$3"
    else
        echo "Unknown cmmand: $1"
    fi
else
    echo "Wrong number of arguments!"
fi
