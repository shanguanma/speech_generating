#!/usr/bin/env bash

# MA DUO

stage=0
stop_stage=100

.  utils/parse_options.sh 

root_dir=/mnt/4T/md/generated_noisy
if [ $stage -le 0 ] && [ ${stop_stage} -ge 0 ];then
   echo "stage 0 : prepared target noisy data 10 hours"
   mkdir -p $root_dir/exp/data
   src_data=/mnt/4T/md/data/raw_data/noise/xiaohuasheng/combined/2021-07-19_25
   des_train=$root_dir/exp/data/trainB/2021-07-19_25_10h
   des_valid=$root_dir/exp/data/validB/2021-07-19_25_2h
   utils/subset_data_dir.sh     $src_data 8516  $des_train
   utils/subset_data_dir.sh     $src_data 3000  $des_valid
fi

if [ $stage -le 1 ] && [ ${stop_stage} -ge 1 ];then
   echo "stage 1 : prepared clean  data 50 hours"
   src_data=/mnt/4T/md/kaldi-recipe/multi_cn/run_multi_cn_dict_kaldi/data_1a/aishell/train
   des_train=$root_dir/exp/data/trainA/aishell_50h
   des_valid=$root_dir/exp/data/trainA/aishell_5h
   utils/subset_data_dir.sh     $src_data 40032   $des_train
   utils/subset_data_dir.sh     $src_data 4000   $des_valid 
fi


if [ $stage -le 2 ] && [ ${stop_stage} -ge 2 ];then
   echo " stage 2 : training"
    python3 train.py\
	    --dir_trainA "$root_dir/exp/data/trainA/aishell_50h" \
            --dir_trainB "$root_dir/exp/data/trainB/2021-07-19_25_10h"\
	    --dir_validA "$root_dir/exp/data/trainA/aishell_5h" \
	    --dir_validB "$root_dir/exp/data/validB/2021-07-19_25_2h" \
	    --gpu_ids "3"\
	    --checkpoints_dir "$root_dir/exp/unpairedscp"\
            --name "$root_dir/exp/unpairedscp"\
	    --easy_label "$root_dir/exp/unpairedscp"\
	    --pretrained_name "$root_dir/exp/unpairedscp/10_net_G.pth"




fi



if [ $stage -le 5 ] && [ ${stop_stage} -ge 5 ];then
   echo "stage 5 : prepared target noisy data 5 hours"
   mkdir -p $root_dir/exp/data
   src_data=/mnt/4T/md/data/raw_data/noise/xiaohuasheng/combined/2021-07-19_25
   des_train=$root_dir/exp/data/trainB/2021-07-19_25_5h
   des_valid=$root_dir/exp/data/validB/2021-07-19_25_2h
   utils/subset_data_dir.sh     $src_data 4500  $des_train
   utils/subset_data_dir.sh     $src_data 3000  $des_valid
fi

if [ $stage -le 6 ] && [ ${stop_stage} -ge 6 ];then
   echo "stage 6 : prepared clean  data 50 hours"
   src_data=/mnt/4T/md/kaldi-recipe/multi_cn/run_multi_cn_dict_kaldi/data_1a/aishell/train
   des_train=$root_dir/exp/data/trainA/aishell_5h
   des_valid=$root_dir/exp/data/trainA/aishell_2h
   utils/subset_data_dir.sh     $src_data 4000  $des_train
   utils/subset_data_dir.sh     $src_data 2000   $des_valid
fi


if [ $stage -le 7 ] && [ ${stop_stage} -ge 7 ];then
   echo " stage 7 : training"
    python3 train.py\
            --dir_trainA "$root_dir/exp/data/trainA/aishell_5h" \
            --dir_trainB "$root_dir/exp/data/trainB/2021-07-19_25_5h"\
            --dir_validA "$root_dir/exp/data/trainA/aishell_2h" \
            --dir_validB "$root_dir/exp/data/validB/2021-07-19_25_2h" \
            --gpu_ids "1"\
            --checkpoints_dir "$root_dir/exp/unpairedscp_small"\
            --name "$root_dir/exp/unpairedscp_small"\
            --easy_label "$root_dir/exp/unpairedscp_small"

fi

if [ $stage -le 8 ] && [ ${stop_stage} -ge 8 ];then

   echo " stage 8 : testing"
    python3 test.py \
	    --dir_trainA "$root_dir/exp/data/trainA/aishell_5h" \
            --dir_trainB "$root_dir/exp/data/trainB/2021-07-19_25_5h"\
            --dir_validA "$root_dir/exp/data/trainA/aishell_2h" \
            --dir_validB "$root_dir/exp/data/validB/2021-07-19_25_2h" \
	    --dir_testA "/mnt/4T/md/wenet_recipes/aishell/s0/data/test"\
	    --results_dir "$root_dir/exp/unpairedscp_small/aishell_test"\
	    --state "test" \
            --checkpoints_dir  "$root_dir/exp/unpairedscp_small"\
	    --name ""\

fi

if [ $stage -le 9 ] && [ ${stop_stage} -ge 9 ];then
   echo "stage 9: normalization loud23 for model ouput wavform"
   python3 loudnorm.py\
	  --dataroot "/mnt/4T/md/generated_noisy/exp/unpairedscp_small/aishell_test/test_latest/audios/fake_B/" \
          --output "/mnt/4T/md/generated_noisy/exp/unpairedscp_small/aishell_test/test_latest/audios/fake_B_loudnorm23"\
          --fixed_loudness "-23"

fi


if [ $stage -le 10 ] && [ ${stop_stage} -ge 10 ];then
   echo "stage 10: normalization loud18 for model ouput wavform"
   python3 loudnorm.py\
          --dataroot "/mnt/4T/md/generated_noisy/exp/unpairedscp_small/aishell_test/test_latest/audios/fake_B/" \
          --output "/mnt/4T/md/generated_noisy/exp/unpairedscp_small/aishell_test/test_latest/audios/fake_B_loudnorm18"\
          --fixed_loudness "-18"

fi

if [ $stage -le 11 ] && [ ${stop_stage} -ge 11 ];then
   echo "stage 11: normalization loud28 for model ouput wavform"
   python3 loudnorm.py\
          --dataroot "/mnt/4T/md/generated_noisy/exp/unpairedscp_small/aishell_test/test_latest/audios/fake_B/" \
          --output "/mnt/4T/md/generated_noisy/exp/unpairedscp_small/aishell_test/test_latest/audios/fake_B_loudnorm40"\
          --fixed_loudness "-28"

fi

if [ $stage -le 12 ] && [ ${stop_stage} -ge 12 ];then
   echo "stage 12: normalization loud33 for model ouput wavform"
   python3 loudnorm.py\
          --dataroot "/mnt/4T/md/generated_noisy/exp/unpairedscp_small/aishell_test/test_latest/audios/fake_B/" \
          --output "/mnt/4T/md/generated_noisy/exp/unpairedscp_small/aishell_test/test_latest/audios/fake_B_loudnorm33"\
          --fixed_loudness "-33"

fi
if  [ $stage -le 13 ] && [ ${stop_stage} -ge 13 ];then
     echo "stage 13: prepared generated noisy aishell test data"
      /mnt/4T/md/package/source-md/prepare_kaldi_data/make_wav_scp.sh \
	      /mnt/4T/md/generated_noisy/exp/unpairedscp_small/aishell_test/test_latest/audios/fake_B_loudnorm33/ \
	      /mnt/4T/md/generated_noisy/exp/unpairedscp_small/aishell_test_kaldi_format

fi




# 2021-11-29 update,
# using generated_noisy model to generate aishell train set and valid set in robot speech data domain
root_dir=/mnt/4T_b/md/SpeechGenerating
if  [ $stage -le 14 ] && [ ${stop_stage} -ge 14 ];then
   echo "stage 14: generated robot speech data domain aishell test set and valid set"
   for name in dev test;do
      python3 test.py \
            --dir_trainA "$root_dir/exp/data/trainA/aishell_5h" \
            --dir_trainB "$root_dir/exp/data/trainB/2021-07-19_25_5h"\
            --dir_validA "$root_dir/exp/data/validA/aishell_2h" \
            --dir_validB "$root_dir/exp/data/validB/2021-07-19_25_2h" \
            --dir_testA "/mnt/4T_b/md/wenet_recipe/aishell/s0/data/$name"\
            --results_dir "$root_dir/exp/unpairedscp_small/aishell_$name"\
            --state "test" \
            --checkpoints_dir  "$root_dir/exp/unpairedscp_small"\
            --name ""\

   done 

fi

#if  [ $stage -le 15 ] && [ ${stop_stage} -ge 15 ];then
#   echo "stage 15: generated robot speech data domain aishell train set "
#   aishell_train_set_scp=/mnt/4T_b/md/wenet_recipe/aishell/s0/data/train/wav.scp
#   bash bigdata_inference.sh \
#	   $aishell_train_set_scp\
#	   train
#fi


if [ $stage -le 15 ] && [ ${stop_stage} -ge 15 ];then
    echo "stage 15: generated robot speech data domain aishell train set "
    
    nj=200
    for n in $(seq $nj); do
         python3 test.py \
            --dir_trainA "$root_dir/exp/data/trainA/aishell_5h" \
            --dir_trainB "$root_dir/exp/data/trainB/2021-07-19_25_5h"\
            --dir_validA "$root_dir/exp/data/validA/aishell_2h" \
            --dir_validB "$root_dir/exp/data/validB/2021-07-19_25_2h" \
            --dir_testA "exp/data/aishell_train_testA/split200utt/$n/wav.scp"\
            --results_dir "$root_dir/exp/unpairedscp_small/aishell_train$n"\
            --state "test" \
            --checkpoints_dir  "$root_dir/exp/unpairedscp_small"\
            --name ""
    done    
fi


if [ $stage -le 16 ] && [ ${stop_stage} -ge 16 ];then
   echo "stage 16: normalization loud33 for model ouput wavform"
   nj=200
   for n in $(seq $nj); do
   python3 loudnorm.py\
          --dataroot "exp/unpairedscp_small/aishell_train$n/test_latest/audios/fake_B/" \
          --output "exp/unpairedscp_small/aishell_train$n/test_latest/audios/fake_B_loudnorm33"\
          --fixed_loudness "-33"
   done

fi
if  [ $stage -le 17 ] && [ ${stop_stage} -ge 17 ];then
   echo "stage 17: prepared generated noisy aishell train kaldi format data"
   nj=200
   for n in $(seq $nj); do
      source-md/prepare_kaldi_data/make_wav_scp.sh \
          /mnt/4T_b/md/SpeechGenerating/exp/unpairedscp_small/aishell_train$n/test_latest/audios/fake_B_loudnorm33/ \
          exp/unpairedscp_small/aishell_train${n}kaldi_format

  done || exit 1;
  
 utils/copy_data_dir.sh exp/data/aishell_train_testA exp/unpairedscp_small/aishell_trainkaldi_format 
 for n in $(seq $nj); do
   cat exp/unpairedscp_small/aishell_train${n}kaldi_format/wav.scp || exit 1
 done > exp/unpairedscp_small/aishell_trainkaldi_format/wav.scp || exit 1
 
 #for n in $(seq $nj); do
 #   rm -rf exp/unpairedscp_small/aishell_train${n}kaldi_format
 #done 
fi
 

if [ $stage -le 18 ] && [ ${stop_stage} -ge 18 ];then
   nj=200
   for n in $(seq $nj); do
    rm -rf exp/unpairedscp_small/aishell_train${n}kaldi_format
 done
fi


if [ $stage -le 19 ] && [ ${stop_stage} -ge 19 ];then
   echo "stage 19: normalization loud33 for model ouput wavform"
   
   for name in test dev; do
    python3 loudnorm.py\
          --dataroot "exp/unpairedscp_small/aishell_$name/test_latest/audios/fake_B/" \
          --output "exp/unpairedscp_small/aishell_$name/test_latest/audios/fake_B_loudnorm33"\
          --fixed_loudness "-33"
   done

fi

if  [ $stage -le 20 ] && [ ${stop_stage} -ge 20 ];then
   echo "stage 20: prepared generated noisy aishell valid and test kaldi format data"
   
   for name in test dev;do
      mkdir -p exp/unpairedscp_small/aishell_${name}kaldi_format
      cp -r /mnt/4T_b/md/wenet_recipe/aishell/s0/data/$name/{text,wav.scp} exp/unpairedscp_small/aishell_${name}kaldi_format
      source-md/prepare_kaldi_data/make_wav_scp.sh \
          /mnt/4T_b/md/SpeechGenerating/exp/unpairedscp_small/aishell_${name}/test_latest/audios/fake_B_loudnorm33/ \
          exp/unpairedscp_small/aishell_${name}kaldi_format

  done|| exit 1;
fi
