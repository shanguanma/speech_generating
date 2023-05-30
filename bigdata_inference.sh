#!/usr/bin/env bash

# split wav.scp and compute generate target noisy data via Speechgenerate
nj=400
#. path.sh
.  utils/parse_options.sh
inscp=$1
set_name=$2 

data=$(dirname ${inscp})

logdir=$data/log
mkdir -p $logdir

rm -f $logdir/wav_*.scp
rm -f $logdir/wav_*.shape
split --additional-suffix .scp -d -n l/$nj $inscp $logdir/wav_
mkdir -p exp/unpairedscp_small/aishell_$set_name/log
for scp in `ls $logdir/wav_*.scp`; do
{
    name=`basename -s .scp $scp`
      python3 test.py \
            --dir_trainA "exp/data/trainA/aishell_5h" \
            --dir_trainB "exp/data/trainB/2021-07-19_25_5h"\
            --dir_validA "exp/data/validA/aishell_2h" \
            --dir_validB "exp/data/validB/2021-07-19_25_2h" \
            --dir_testA "$scp"\
            --results_dir "exp/unpairedscp_small/aishell_$set_name/log/$name"\
            --state "test" \
            --checkpoints_dir  "exp/unpairedscp_small"\
            --name "" 1>exp/unpairedscp_small/aishell_$set_name/log/$name.log

} &
done
wait
