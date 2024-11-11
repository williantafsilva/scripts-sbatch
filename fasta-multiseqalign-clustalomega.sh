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
##Align sequences using ClustalOmega.

##Input $1: Output location.
##Input $2: FASTA file (.fa or .fasta).
##Output: Alignment file (.fa).

##Usage (bulk submission): 
##find <PATH TO DIRECTORY>/*.fa -maxdepth 0 | while read F ; do 
##    sbatch \
##			-A ${PROJECT_ID} \
##			-o ${MYSLURMFILE} \
##			-p shared \
##			-N 1 \
##			-n 5 \ ##--mem=100GB \
##  		-t 0-06:00:00 \
##			-J multiseqalign-clustalomega-${F##*/} \
##			--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
##			fasta-multiseqalign-clustalomega.sh <OUTPUT LOCATION> ${F} 
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

SCRIPTNAME=$(echo "fasta-multiseqalign-clustalomega.sh") 

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
	module load bcftools
	module load clustalo/1.2.4
elif [[ $(hostname -f) == *pdc* ]] ; then
	module load systemdefault/1.0.0
	module load bioinfo-tools
	module load bcftools
	module load clustalo/1.2.4
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
INPUTFILE=$(readlink -f $2)
INPUTFILELOCATION=${INPUTFILE%/*}
INPUTFILENAME=${INPUTFILE##*/}
echo "INPUTFILE: ${INPUTFILE}
INPUTFILELOCATION: ${INPUTFILELOCATION}
INPUTFILENAME: ${INPUTFILENAME}
"

echo 
echo "##OUTPUT:"
echo 

##Output file (as an extension of the input file/directory).
OUTPUTFILEPREFIX=$(echo ${INPUTFILENAME} | sed 's/\.fa.*$//' | sed 's/\.fasta.*$//' | sed 's/-job[0-9].*$//')
OUTPUTFILENAME=$(echo "${OUTPUTFILEPREFIX}.clustalo-job${JOBID}.fa") 
OUTPUTFILE=$(echo "${OUTPUTLOCATION}/${OUTPUTFILENAME}") 
echo "OUTPUTLOCATION: ${OUTPUTLOCATION}
OUTPUTFILEPREFIX: ${OUTPUTFILEPREFIX}
OUTPUTFILENAME: ${OUTPUTFILENAME}
OUTPUTFILE: ${OUTPUTFILE}
"

echo 
echo "############################################################################"
echo "##PROCESSING FILE: ${INPUTFILE}"
echo 

clustalo --in ${INPUTFILE} --seqtype=DNA --outfmt=fa --out ${OUTPUTFILE} -v

echo 
echo "############################################################################"
echo "##SAVE CONTROL FILES (README, script, slurm):"
echo 

echo "############################################################################
Date: ${RUNDATE}
Job ID: ${JOBID}
Script: ${SUBMITTEDSCRIPT}
Input file: ${INPUTFILE}
Output file: ${OUTPUTFILE}
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