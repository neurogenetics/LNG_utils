# in an interactive session, run:

module load bcftools
module load singularity


# sorting the VCF same as the BAM
# have BAM, VCF, and script sort_vcf_same_as_bam.sh in the same directory, and run:
./sort_vcf_same_as_bam.sh ./possorted_genome_bam.bam ./my_vcf.vcf > ./my_vcf_reordered.vcf


# add all "info" fields to the VCF (specifically need the "AF" field):
bcftools +fill-tags my_vcf_reordered.vcf > my_vcf_reordered_tagged.vcf
# view the tagged VCF: 
bcftools view my_vcf_reordered_tagged.vcf | tail -5


# rename chromosomes to match BAM w/ chr_map.txt
# chr_map.txt should be a txt file w/ chromosome number and new name separated by a tab, 1 per line, e.g.:
# 1  chr1
# 2  chr2
# etc.
bcftools annotate --rename-chrs chr_map.txt my_vcf_reordered_tagged.vcf -o my_vcf_reordered_tagged_chr.vcf
bgzip -c my_vcf_reordered_tagged_chr.vcf > my_vcf_reordered_tagged_chr.vcf.bgz
tabix -p vcf my_vcf_reordered_tagged_chr.vcf.bgz
