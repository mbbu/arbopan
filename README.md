# arbopan

A pangenomics pipeline tailored for arboviruses.

## Usage
The pipeline only supports conda environments at the moment.

```bash
nextflow run mbbu/arbopan -profile conda --input "sample_data/*.fa" --results "sample_results" -r main
```

## References
1. [vgteam/vg](https://github.com/vgteam/vg): Variation graph toolkit.
2. [GSLBiotech/mafft](https://github.com/GSLBiotech/mafft): Multiple sequence alignment tool.
3. [sanger-pathogens/snp-sites](https://github.com/sanger-pathogens/snp-sites): Rapidly extracts SNPs from a multi-FASTA alignment.
4. [samtools/htslib](https://github.com/samtools/htslib): Provides `tabix` for indexing and `bgzip` for zipping.