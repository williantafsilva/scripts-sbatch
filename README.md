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

- Output : VCF file (\*.bcftovcf-job\*.vcf.gz).

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

- Output : FASTA file (\*.query-job\*.fa).

- Usage:

```
refseq-query.sh <OUTPUT LOCATION> <FASTA FILE> <SEQUENCE RANGE>
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
	refseq-query.sh <OUTPUT LOCATION> <FASTA FILE> <SEQUENCE RANGE>
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






