# in an interactive session, run:

module load bcftools
module load singularity

# NECESSARY FOR DEMUXALOT (and maybe more softwares): 
# sorting the VCF same as the BAM (only have to do this once--process one fastq w/ nf-core then do this, then can do the whole workflow)
# have BAM, VCF, and script sort_vcf_same_as_bam.sh in the same directory, and run:
./sort_vcf_same_as_bam.sh ./possorted_genome_bam.bam ./my_vcf.vcf > ./my_vcf_reordered.vcf


# rename chromosomes to match BAM w/ chr_map.txt
bcftools annotate --rename-chrs chr_map.txt snRNA_SNPs_reordered_tagged.vcf -o snRNA_SNPs_reordered_tagged_chr.vcf
bgzip -c snRNA_SNPs_reordered_tagged_chr.vcf > snRNA_SNPs_reordered_tagged_chr.vcf.bgz
tabix -p vcf snRNA_SNPs_reordered_tagged_chr.vcf.bgz


# add all "info" fields to the VCF (specifically need the "AF" field):
bcftools +fill-tags my_vcf_reordered.vcf > my_vcf_reordered_tagged.vcf
# view the tagged VCF: 
bcftools view my_vcf_reordered_tagged.vcf | tail -5
