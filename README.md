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





