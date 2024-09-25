#!/bin/bash

FASTQ=${1}

Rscript /data/ADRD/amp_pd/transcriptomics/fastq_processing/jobscripts/demuxafy_combine_results.R $FASTQ
