# SBATCH scripts

Scripts submitted to SLURM (via sbatch) produce the following files (in addition to the results files):

- Script file (job\*.script).

- Slurm file (job\*.slurm).

## bcf-index-stats.sh

- Index BCF file.

- Input 1: Output location.

- Input 2: BCF file (\*.bcf).

- Output : Index file (\*.csi) and stats file (\*.stats-job\*.txt).

- Usage:

```
bcf-index-stats.sh <OUTPUT LOCATION> <BCF FILE>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J bcf-index \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	bcf-index-stats.sh <OUTPUT LOCATION> <BCF FILE>
```

## bcf-vcf.sh

- Convert BCF file into compressed VCF file (.vcf.gz).

- Input 1: Output location.

- Input 2: BCF file (\*.bcf).

- Output 1: VCF file (\*.bcftovcf-job\*.vcf.gz).

- Output 2: Index file (\*.bcftovcf-job\*.vcf.gz.tbi).

- Usage:

```
bcf-vcf.sh <OUTPUT LOCATION> <BCF FILE>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J bcf-vcf \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	bcf-vcf.sh <OUTPUT LOCATION> <BCF FILE>
```

## fasta-multiseqalign-clustalomega.sh

- Align FASTA sequences using ClustalOmega.

- Input 1: Output location.

- Input 2: FASTA file (\*.fa or \*.fasta) with sequences to align.

- Output : Alignment file (\*.clustalo-job\*.fa).

- Usage:

```
fasta-multiseqalign-clustalomega.sh <OUTPUT LOCATION> <FASTA FILE>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J multiseqalign-clustalomega \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	fasta-multiseqalign-clustalomega.sh <OUTPUT LOCATION> <FASTA FILE>
```

## refseq-query.sh

- Retrieve sequence from reference FASTA file.

- Input 1: Output location.

- Input 2: Indexed reference FASTA file (\*.fa).

- Input 3: Sequence range (chr:position-position).

- Input 4: File tag (to be included in the output file name).

- Output : FASTA file (\*.query\*-job\*.fa).

- Usage:

```
refseq-query.sh <OUTPUT LOCATION> <FASTA FILE> <SEQUENCE RANGE> <FILE TAG>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J refseq-query \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	refseq-query.sh <OUTPUT LOCATION> <FASTA FILE> <SEQUENCE RANGE> <FILE TAG>
```

## Rscript.sh

- Run R script.

- Input 1: R script file name (\*.R).

- Input 2: Output location.

- Input 3: R script input arguments.

- Output : R script output.

- Usage:

```
Rscript.sh <R SCRIPT FILE NAME> <OUTPUT LOCATION> <ARGS>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J Rscript \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	Rscript.sh <R SCRIPT FILE NAME> <OUTPUT LOCATION> <ARGS>
```

## SF2input-SF2output.sh

- Generate SweepFinder2 output files.

- Input 1: Output location.

- Input 2: SweepFinder2 input file (\*.SFformat-job\*.SF2input).

- Input 3: Site frequency spectrum file (\*.SF2sfs-job\*.SF2sfs).

- Output: SweepFinder2 output file (\*.SF2-job\*.SF2output).

- Usage:

```
SF2input-SF2output.sh <OUTPUT LOCATION> <.SF2input FILE> <.SF2sfs FILE>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J SF2input-SF2output \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	SF2input-SF2output.sh <OUTPUT LOCATION> <.SF2input FILE> <.SF2sfs FILE>
```

## SF2input-SF2sfs.sh

- Create a site frequency spectrum (SFS) file using SweepFinder2.

- Input 1: Output location.

- Input 2: Directory containing all SweepFinder2 input files (\*.SFformat-job\*.SF2input).

- Output: Concatenated \*.SF2input file (\*.SF2sfs-job\*.concatSF2input) and SFS file (\*.SF2sfs-job\*.SF2sfs).

- Usage:

```
SF2input-SF2sfs.sh <OUTPUT LOCATION> <INPUT DIRECTORY>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J SF2input-SF2sfs \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	SF2input-SF2sfs.sh <OUTPUT LOCATION> <INPUT DIRECTORY>
```

## vcf-addAC.sh

- Add AC field to VCF file.

- Input 1: Output location.

- Input 2: VCF file (\*.vcf or \*.vcf.gz).

- Output: VCF file (\*.addAC-job\*.vcf.gz).

- Usage:

```
vcf-addAC.sh <OUTPUT LOCATION> <VCF FILE> 
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-addAC \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-addAC.sh <OUTPUT LOCATION> <VCF FILE> 
```

## vcf-biallelic.sh

- Filter out non-biallelic sites.

- Input 1: Output location.

- Input 2: VCF file (\*.vcf or \*.vcf.gz).

- Output 1: VCF file (\*.addAC-job\*.vcf.gz).

- Output 2: VCF file (\*.addAC-job\*.vcf.gz.tbi).

- Usage:

```
vcf-biallelic.sh <OUTPUT LOCATION> <VCF FILE> 
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-biallelic \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-biallelic.sh <OUTPUT LOCATION> <VCF FILE> 
```

## vcf-compress.sh

- Compress VCF file.

- Input 1: Output location.

- Input 2: VCF file (\*.vcf).

- Output: Compressed VCF file (\*.gz-job\*.vcf.gz).

- Usage:

```
vcf-compress.sh <OUTPUT LOCATION> <VCF FILE> 
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-compress \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-compress.sh <OUTPUT LOCATION> <VCF FILE> 
```

## vcf-consensusseq.sh

- Create global consensus (IUPAC code) and individual consensus (alternative alleles in heterozygotes) sequences from a VCF file and the corresponding reference FASTA file.

- Input 1: Output location.

- Input 2: VCF file (\*.vcf or \*.vcf.gz).

- Input 3: Indexed reference genome FASTA file (\*.fa).

- Input 4: Target sequence range (chr:position-position).

- Input 5: Comma-separated string of sample names.

- Input 6: File tag (to be included in the output file name).

- Output 1: Global consensus FASTA file (\*.consensus\*-global-job\*.fa).

- Output 2: Individual sample consensus FASTA files (\*.consensus\*-\*-job\*.fa).

- Usage:

```
vcf-consensusseq.sh <OUTPUT LOCATION> <VCF FILE> <REFERENCE FASTA FILE> <SEQUENCE RANGE> <SAMPLES> <FILE TAG>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-consensusseq \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-consensusseq.sh <OUTPUT LOCATION> <VCF FILE> <REFERENCE FASTA FILE> <SEQUENCE RANGE> <SAMPLES> <FILE TAG>
```

## vcf-index-stats.sh

- Index a sorted VCF file.

- Input 1: Output location.

- Input 2: VCF file (\*.vcf or \*.vcf.gz).

- Output 1: Index file (\*.tbi).

- Output 2: Stats file (\*.stats-job\*.txt).

- Usage:

```
vcf-index-stats.sh <OUTPUT LOCATION> <VCF FILE> 
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-index-stats \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-index-stats.sh <OUTPUT LOCATION> <VCF FILE> 
```

## vcf-OmegaPlus.sh

- Generate OmegaPlus output files.

- Input 1: Output location.

- Input 2: VCF file (\*.vcf or \*.vcf.gz) split per chromosome/contig.

- Output 1: OmegaPlus_Report file (OmegaPlus_Report\*.OP-job\*.OmegaPlusoutput).

- Output 2: OmegaPlus_Info file (OmegaPlus_Info\*.OP-job\*.OmegaPlusoutput).

- Usage:

```
vcf-OmegaPlus.sh <OUTPUT LOCATION> <VCF FILE> 
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-OmegaPlus \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-OmegaPlus.sh <OUTPUT LOCATION> <VCF FILE> 
```

## vcf-phase-shapeit5.sh

- Phase VCF file using SHAPEIT5.

- Input 1: Output location.

- Input 2: VCF file (\*.vcf or \*.vcf.gz).

- Input 3: File containing a list of haploid chromosomes.

- Output 1: Phased VCF file (\*.phase-job\*.vcf.gz).

- Output 2: Index file (\*.phase-job\*.vcf.gz.tbi).

- Usage:

```
vcf-phase-shapeit5.sh <OUTPUT LOCATION> <VCF FILE> <HAPLOID CHR LIST FILE> 
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-phase-shapeit5 \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-phase-shapeit5.sh <OUTPUT LOCATION> <VCF FILE> <HAPLOID CHR LIST FILE> 
```

## vcf-renamesamples.sh

- Change sample names in a VCF file.

- Input 1: Output location.

- Input 2: VCF file (\*.vcf or \*.vcf.gz).

- Input 3: Sample name conversion file (OLDNAME NEWNAME\n).

- Output: VCF file (\*.renamesamples-job\*.vcf.gz).

- Usage:

```
vcf-renamesamples.sh <OUTPUT LOCATION> <VCF FILE> <SAMPLE NAME CONVERTION FILE>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-renamesamples \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-renamesamples.sh <OUTPUT LOCATION> <VCF FILE> <SAMPLE NAME CONVERTION FILE>
```

## vcf-selectsamples.sh

- Select samples from a VCF file.

- Input 1: Output location.

- Input 2: VCF file (\*.vcf or \*.vcf.gz).

- Input 3: Comma-separated string with target samples (use | paste -sd,).

- Input 4: Sample group code to be attached to the output file name.

- Output: VCF file (\*.select\*-job\*.vcf.gz).

- Usage:

```
vcf-selectsamples.sh <OUTPUT LOCATION> <VCF FILE> <LIST OF SAMPLES> <SAMPLE GROUP CODE> 
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-selectsamples \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-selectsamples.sh <OUTPUT LOCATION> <VCF FILE> <LIST OF SAMPLES> <SAMPLE GROUP CODE> 
```

## vcf-SF2input.sh

- Generate SweepFinder2 input files.

- Input 1: Output location.

- Input 2: VCF file (\*.vcf or \*.vcf.gz) split per chromosome/contig.

- Output: SweepFinder2 input file (\*.SF2format-job\*.SF2input).

- Usage:

```
vcf-SF2input.sh <OUTPUT LOCATION> <VCF FILE>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-SF2input \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-SF2input.sh <OUTPUT LOCATION> <VCF FILE>
```

## vcf-sort-index.sh

- Sort and index VCF file

- Input 1: Output location.

- Input 2: VCF file (\*.vcf or \*.vcf.gz).

- Output 1: VCF file (\*.sort-job\*.vcf.gz).

- Output 2: Index file (\*.sort-job\*.vcf.gz.tbi).

- Usage:

```
vcf-sort-index.sh <OUTPUT LOCATION> <VCF FILE>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-sort-index \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-sort-index.sh <OUTPUT LOCATION> <VCF FILE>
```

## vcf-split.sh

- Split VCF file by chromosome/contig.

- Input 1: Output location.

- Input 2: Indexed VCF file (\*.vcf or \*.vcf.gz).

- Output: Directory (\*.splitbychr-job\*) with VCF files (\*.splitbychr-job\*.vcf.gz) by chromosome/contig.

- Usage:

```
vcf-split.sh <OUTPUT LOCATION> <VCF FILE>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-split \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-split.sh <OUTPUT LOCATION> <VCF FILE>
```

## vcf-summarytable.sh

- Create a summary table of a VCF file.

- Input 1: Output location.

- Input 2: Indexed VCF file (\*.vcf or \*.vcf.gz).

- Output: Summary table file (\*.summary-job\*.txt).

- Usage:

```
vcf-summarytable.sh <OUTPUT LOCATION> <VCF FILE>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-summarytable \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-summarytable.sh <OUTPUT LOCATION> <VCF FILE>
```

## vcf-SweeD.sh

- Generate SweeD output files.

- Input 1: Output location.

- Input 2: VCF file (\*.vcf or \*.vcf.gz) or SweepFinder2 input file (\*.SF2input), split by chromosome.

- Output 1: SweeD_Report file (SweeD_Report\*.SweeD-job\*.SweeDoutput).

- Output 2: SweeD_Info file (SweeD_Info\*.SweeD-job\*.SweeDoutput).

- Usage:

```
vcf-SweeD.sh <OUTPUT LOCATION> <VCF FILE>
```

```
sbatch \
	-A ${PROJECT_ID} \
	-o ${MYSLURMFILE} \
	-p shared \
	-N 1 \
	-n 5 \ ##--mem=100GB \
	-t 0-12:00:00 \
	-J vcf-SweeD \
	--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
	vcf-SweeD.sh <OUTPUT LOCATION> <VCF FILE>
```
