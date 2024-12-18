#!/bin/bash -l
##One hashtag: SBATCH comments read by the server (UPPMAX, PDC).
##Two hashtags: General comments ignored by the server (UPPMAX, PDC).
##Add -l to the shebang to inherit bash profile variables and configuration.
############################################################################
################################## SCRIPT ##################################
############################################################################
##Author: Willian T.A.F. Silva (willian.silva@evobiolab.com).
############################################################################
##SCRIPT DESCRIPTION:

##Description:
##Pre-process paired-end FastQ files using Fastp.

##Input $1: Output location.
##Input $2: FASTQ file (read 1, R1) (.fastq.gz or .fq.gz).
##Input $3: FASTQ file (read 2, R2) (.fastq.gz or .fq.gz).
##Output: FASTQ files (.fastq.gz).

##Usage (bulk submission): 
##find <PATH TO DIRECTORY>/<DIRECTORY> -maxdepth 0 | while read D ; do 
##	  F_R1=$(find *R1*.fastq.gz -maxdepth 0)
##    F_R2=$(find *R2*.fastq.gz -maxdepth 0)
##    sbatch \
##			-A ${PROJECT_ID} \
##			-o ${MYSLURMFILE} \
##			-p shared \
##			-N 1 \
##			-n 5 \ ##--mem=100GB \
##			-t 0-12:00:00 \
##			-J fastq-fastp-${D##*/} \
##			--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
##			fastqPE-fastp.sh <OUTPUT LOCATION> ${F_R1} ${F_R2}
##done

############################################################################
##SBATCH SETTINGS:
#SBATCH --mail-type=ALL ##Types of e-mail notifications.
#SBATCH --mail-user="willian.silva@evobiolab.com" ##E-mail notifications on job BEGIN, END and FAIL.

echo "############################################################################"
echo "STARTING BASH SCRIPT... $(date)"
echo "############################################################################"
echo 
echo "############################################################################"
echo "##SCRIPT:"
echo 

cat $0

echo 
echo "############################################################################"
echo "##SCRIPT CONTROL:"
echo 

SCRIPTNAME=$(echo "fastqPE-fastp-v1.sh") 

RUNDATE=$(date +"%Y%m%d%H%M%S")
PATHTOSCRIPT=$(echo "${PATHTOMYSBATCHSCRIPTS}/${SCRIPTNAME}") 
if [[ -z "${SLURM_JOB_ID}" ]] ; then JOBID=${RUNDATE} ; else JOBID=${SLURM_JOB_ID} ; fi 
SUBMITTEDSCRIPT=$(echo "${PATHTOMYSUBMITTEDSCRIPTS}/job${JOBID}-date${RUNDATE}-${SCRIPTNAME}") 
SLURMFILE=$(echo "${PATHTOMYSLURM}/slurm-${JOBID}.out") 
SLURM_JOB_TIMELIMIT=$(squeue -j $SLURM_JOB_ID -h --Format TimeLimit)
OUTPUTLOCATION=$(readlink -f $1)

echo "SUBMISSION ($(date +"%Y-%m-%d @ %H:%M:%S")): 
User (\$USER): ${USER}
Host name (hostname -f): $(hostname -f)
Job ID (\$SLURM_JOB_ID): ${SLURM_JOB_ID}
Cluster (\$SLURM_CLUSTER_NAME): ${SLURM_CLUSTER_NAME}
Submission directory (\$SLURM_SUBMIT_DIR): ${SLURM_SUBMIT_DIR}
Start time (\$SLURM_JOB_START_TIME): ${SLURM_JOB_START_TIME}
End time (\$SLURM_JOB_END_TIME): ${SLURM_JOB_END_TIME}
Account (-A; \$SLURM_JOB_ACCOUNT): ${SLURM_JOB_ACCOUNT}
Partition (-p; \$SLURM_JOB_PARTITION): ${SLURM_JOB_PARTITION}
Number of cores (-n; \$SLURM_NTASKS/\$SLURM_CPUS_ON_NODE): ${SLURM_NTASKS}/${SLURM_CPUS_ON_NODE}
Time limit (-t; \$SLURM_JOB_TIMELIMIT): ${SLURM_JOB_TIMELIMIT}
Memory allocation (--mem; \$SLURM_MEM_PER_NODE): ${SLURM_MEM_PER_NODE}
Number of cpus per task (-c; \$SLURM_CPUS_PER_TASK): ${SLURM_CPUS_PER_TASK}
Number of nodes in the job allocation (--nodes; \$SLURM_JOB_NUM_NODES): ${SLURM_JOB_NUM_NODES}
Job name (-J; \$SLURM_JOB_NAME): ${SLURM_JOB_NAME}
Script (\$PATHTOSCRIPT --> \$0): ${PATHTOSCRIPT} --> $0
Script arguments (\"\$@\"): "$@"
"

echo 
echo "############################################################################"
echo "##SYSTEM CONTROL:"
echo 

echo "\$ uname -a:" ##System information.
uname -a 
echo 
echo "\$ squeue -u ${USER}:" ##Job information. 
squeue -u ${USER} 
echo 
echo "\$ module list:" ##List of loaded modules.
module list 
echo 
echo "\$ free:" ##Memory.
free 
echo 
echo "\$PATH:" ##PATH.
echo $PATH 
echo 
echo "\$LD_LIBRARY_PATH:" ##Library PATH.
echo $LD_LIBRARY_PATH 

echo 
echo "############################################################################"
echo "##LOAD TOOLS:" 
echo 

if [[ $(hostname -f) == *uppmax* ]] ; then 
	module load bioinfo-tools
	module load fastp/0.23.4
elif [[ $(hostname -f) == *pdc* ]] ; then
	module load bioinfo-tools
	module load fastp/0.23.4
fi

echo 
echo "############################################################################"
echo "##ACTIONS:"
echo 
echo "##FILE CONTROL:"
echo 
echo "##INPUT:"
echo 

##Input file.
INPUTFILE1=$(readlink -f $2)
INPUTFILE2=$(readlink -f $3)
INPUTFILE1LOCATION=${INPUTFILE1%/*}
INPUTFILE2LOCATION=${INPUTFILE2%/*}
INPUTFILE1NAME=${INPUTFILE1##*/}
INPUTFILE2NAME=${INPUTFILE2##*/}
echo "INPUTFILE1: ${INPUTFILE1}
INPUTFILE2: ${INPUTFILE2}
INPUTFILE1LOCATION: ${INPUTFILE1LOCATION}
INPUTFILE2LOCATION: ${INPUTFILE2LOCATION}
INPUTFILE1NAME: ${INPUTFILE1NAME}
INPUTFILE2NAME: ${INPUTFILE2NAME}
"

echo 
echo "##OUTPUT:"
echo 

##Create consensus file name.
CONSENSUSFILENAME=""
while read C ; do
    C1=$(echo ${C} | cut -f1)
    C2=$(echo ${C} | cut -f2)
    if [[ "${C1}" == "${C2}" ]] ; then
        CONSENSUSFILENAME+="${C1}"
    else
        CONSENSUSFILENAME+="X"
    fi
done <<< "$(paste -d'\t' <(echo ${INPUTFILE1NAME} | grep -o .) <(echo ${INPUTFILE2NAME} | grep -o .))"

##Create output directory for reads that fail quality control.
FAILQCDIR=$(echo "${OUTPUTLOCATION}/${OUTPUTFILEXPREFIX}.fastp_failQC-job${JOBID}") 
mkdir -p ${FAILQCDIR}

##Output file (as an extension of the input file/directory).
OUTPUTFILE1PREFIX=$(echo ${INPUTFILE1NAME} | sed 's/\.fastq\..*$//' | sed 's/\.fq\..*$//' | sed 's/-job[0-9].*$//')
OUTPUTFILE2PREFIX=$(echo ${INPUTFILE2NAME} | sed 's/\.fastq\..*$//' | sed 's/\.fq\..*$//' | sed 's/-job[0-9].*$//')
OUTPUTFILEXPREFIX=$(echo ${CONSENSUSFILENAME} | sed 's/\.fastq\..*$//' | sed 's/\.fq\..*$//' | sed 's/-job[0-9].*$//')
OUTPUTFILE1NAME=$(echo "${OUTPUTFILE1PREFIX}.fastp-job${JOBID}.fastq.gz") 
OUTPUTFILE2NAME=$(echo "${OUTPUTFILE2PREFIX}.fastp-job${JOBID}.fastq.gz") 
OUTPUTFILE3NAME=$(echo "${OUTPUTFILEXPREFIX}.fastp_report-job${JOBID}.json") 
OUTPUTFILE4NAME=$(echo "${OUTPUTFILEXPREFIX}.fastp_report-job${JOBID}.html") 
OUTPUTFILE5NAME=$(echo "${OUTPUTFILE1PREFIX}.fastp_failQC_unpaired1-job${JOBID}.fastq.gz") 
OUTPUTFILE6NAME=$(echo "${OUTPUTFILE2PREFIX}.fastp_failQC_unpaired2-job${JOBID}.fastq.gz") 
OUTPUTFILE7NAME=$(echo "${OUTPUTFILEXPREFIX}.fastp_failQC_filters-job${JOBID}.fastq.gz") 
OUTPUTFILE1=$(echo "${OUTPUTLOCATION}/${OUTPUTFILE1NAME}") 
OUTPUTFILE2=$(echo "${OUTPUTLOCATION}/${OUTPUTFILE2NAME}") 
OUTPUTFILE3=$(echo "${OUTPUTLOCATION}/${OUTPUTFILE3NAME}") 
OUTPUTFILE4=$(echo "${OUTPUTLOCATION}/${OUTPUTFILE4NAME}") 

##Create output directory for reads that fail quality control.
FAILQCDIR=$(echo "${OUTPUTLOCATION}/${OUTPUTFILEXPREFIX}.fastp_failQCreads-job${JOBID}") 
mkdir -p ${FAILQCDIR}

OUTPUTFILE5=$(echo "${FAILQCDIR}/${OUTPUTFILE5NAME}") 
OUTPUTFILE6=$(echo "${FAILQCDIR}/${OUTPUTFILE6NAME}") 
OUTPUTFILE7=$(echo "${FAILQCDIR}/${OUTPUTFILE7NAME}") 

echo "OUTPUTLOCATION: ${OUTPUTLOCATION}
OUTPUTFILE1PREFIX: ${OUTPUTFILE1PREFIX}
OUTPUTFILE2PREFIX: ${OUTPUTFILE2PREFIX}
OUTPUTFILEXPREFIX: ${OUTPUTFILEXPREFIX}
OUTPUTFILE1NAME: ${OUTPUTFILE1NAME}
OUTPUTFILE2NAME: ${OUTPUTFILE2NAME}
OUTPUTFILE3NAME: ${OUTPUTFILE3NAME}
OUTPUTFILE4NAME: ${OUTPUTFILE4NAME}
OUTPUTFILE5NAME: ${OUTPUTFILE5NAME}
OUTPUTFILE6NAME: ${OUTPUTFILE6NAME}
OUTPUTFILE7NAME: ${OUTPUTFILE7NAME}
FAILQCDIR: ${FAILQCDIR}
OUTPUTFILE1: ${OUTPUTFILE1}
OUTPUTFILE2: ${OUTPUTFILE2}
OUTPUTFILE3: ${OUTPUTFILE3}
OUTPUTFILE4: ${OUTPUTFILE4}
OUTPUTFILE5: ${OUTPUTFILE5}
OUTPUTFILE6: ${OUTPUTFILE6}
OUTPUTFILE7: ${OUTPUTFILE7}
"

echo 
echo "############################################################################"
echo "##PROCESSING FILE: ${INPUTFILE}"
echo 

fastp \
	--in1 ${INPUTFILE1} \
	--in2 ${INPUTFILE2} \
	--out1 ${OUTPUTFILE1} \
	--out2 ${OUTPUTFILE2} \
	-j ${OUTPUTFILE3} \
	-h ${OUTPUTFILE4} \
	--unpaired1 ${OUTPUTFILE5} \
	--unpaired2 ${OUTPUTFILE6} \
	--failed_out ${OUTPUTFILE7} \
	--dont_overwrite \
	--trim_poly_x \
	--trim_poly_g \
	--umi \
	--umi_loc read1 \
	--umi_len 12 \
	-P 100 \
	--detect_adapter_for_pe \
	--qualified_quality_phred 20 \
	--thread 10

echo 
echo "############################################################################"
echo "##SAVE CONTROL FILES (README, script, slurm):"
echo 

echo "############################################################################
Date: ${RUNDATE}
Job ID: ${JOBID}
Script: ${SUBMITTEDSCRIPT}
Input file: ${INPUTFILE1}
Input file: ${INPUTFILE2}
Output file: ${OUTPUTFILE1}
Output file: ${OUTPUTFILE2}
Output file: ${OUTPUTFILE3}
Output file: ${OUTPUTFILE4}
Output directory: ${FAILQCDIR}
Output file: ${OUTPUTFILE5}
Output file: ${OUTPUTFILE6}
Output file: ${OUTPUTFILE7}
" >> $(echo "${OUTPUTLOCATION}/README.txt") 

echo 
echo "FILE ${INPUTFILE} PROCESSED."
echo 
echo "############################################################################"
echo "END OF BASH SCRIPT... $(date)"
echo "############################################################################"

##Save script and slurm files.
cat $0 > $(echo "${OUTPUTLOCATION}/job${JOBID}.script")
cat $0 > ${SUBMITTEDSCRIPT}
cat ${SLURMFILE} > $(echo "${OUTPUTLOCATION}/job${JOBID}.slurm") 

exit 0