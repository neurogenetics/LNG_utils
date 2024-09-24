# scRNA-seq -- preprocessing, genotype-based demultiplexing, and doublet detection

Contact: Liam Horan-Portelance (liam.horan-portelance@nih.gov or lhoranportelance@gmail.com)

This is a pipeline, to be run on NIH HPC Biowulf, which performs 5 tasks:
1. Quantifies gene expression from fastqs using **CellRanger**
2. Performs ambient RNA detection and count correction using **CellBender**
3. Performs genotype-based demultiplexing for genetically multiplexed samples using **Demuxalot** and **Vireo**
4. Performs general doublet detection using **DoubletDetection**, **scDblFinder**, and **scds**
5. Filters out cells identified as doublets

