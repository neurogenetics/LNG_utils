# scRNA-seq -- preprocessing, genotype-based demultiplexing, and doublet detection

Contact: Liam Horan-Portelance (liam.horan-portelance@nih.gov or lhoranportelance@gmail.com)

This is a pipeline, to be run on NIH HPC Biowulf, which performs 5 tasks:
1. Quantifies gene expression from fastqs using **CellRanger**
2. Performs ambient RNA detection and count correction using **CellBender**
3. Performs genotype-based demultiplexing for genetically multiplexed samples using **Demuxalot** and **Vireo**
4. Performs general doublet detection using **DoubletDetection**, **scDblFinder**, and **scds**
5. Filters out cells identified as doublets

This pipeline takes advantage of the swarm capabilities of Biowulf, allowing it to be run completely parallelized. CellRanger is run first (all samples in parallel), then every other package can be run in parallel, for all samples--none are dependent on one another. 

CellRanger and CellBender are used as independent packages, but the softwares used for gt-demux and doublet detection are wrapped into a singularity container called [Demuxafy](https://demultiplexing-doublet-detecting-docs.readthedocs.io/en/latest/). These scripts were written using v3.0.0 of the singularity container, which can be copied on the HPC from ``/data/ADRD/amp_pd/fastq_processing/demuxafy/Demuxafy.sif``. Future changes to the image may make these scripts incompatible, so may be better to use the v3.0.0, as I've verified that everything here works correctly. 

If your samples are not genetically multiplexed, this can still be used, only utilizing the general doublet detection tools. The only things that will need to be modified is the script to combine results from Demuxafy (XXX) and the R script to filter doublets and create objects (XXX). You also won't need to run scripts #6 and #7. 

The most annoying thing is probably setting up your file paths. I give an example below of how I set up the file paths with my inputs and for my outputs. There is a script (#3) which will create all your specific output directories, so that isn't included here. I'd recommend following this as closely as possible so you don't have to change a bunch of stuff (upstream file paths will of course have to be changed). In this example, "FASTQ" represents the name of the pool/sample. 

Several key notes for running this pipeline:
1. You'll need a .txt file (what I refer to as fastq_list.txt) which has the names of the pools (or fastqs) separated by a line. These shouldn't be the actual file names, but the names of the pools/samples.
2. If CellRanger (or STAR-solo, etc.) has already been run, you can just start from there. The Demuxafy softwares take the filtered feature matrices, and CellBender uses the raw .h5.
3. CellBender generates a counts matrix which includes counts corrected for the presence of ambient RNA. This should be used for all upstream analysis (up to and including cluster identification, marker genes, etc.). However, for downstream analysis (e.g., differential expression), raw counts should be used. In python, raw and CB-corrected counts can be stored in 2 different layers of an anndata object. In R, depending on the size of your Seurat object, this may also be possible, but due to matrix size limits in R, it may not be. Instead, you can use the CB-corrected counts for cluster idents, visualization, etc. and then load in the raw counts for downstream analysis, transferring your cell-type labels to those raw counts. 
