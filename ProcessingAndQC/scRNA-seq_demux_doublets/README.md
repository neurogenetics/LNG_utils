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
