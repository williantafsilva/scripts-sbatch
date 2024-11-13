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
##Run R script (.R) from directory scripts-tmp.

##Input $1: R script (.R).
##Input $2: Output location.
##Input $3: R script input arguments.
##Output: R script output.

##Usage (bulk submission): 
##find <PATH TO DIRECTORY>/* -maxdepth 0 | while read F ; do 
##    sbatch \
##			-A ${PROJECT_ID} \
##			-o ${MYSLURMFILE} \
##			-p shared \
##			-N 1 \
##			-n 5 \ ##--mem=100GB \
##  		-t 0-05:00:00 \
##			-J Rscript-${F##*/} \
##			--dependency=afterok:<JOB1 ID>:<JOB2 ID> \
##			Rscript.sh <R SCRIPT FILE NAME> <OUTPUT LOCATION> ${F}
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

SCRIPTNAME=$(echo "Rscript.sh") 

RUNDATE=$(date +"%Y%m%d%H%M%S")
PATHTOSCRIPT=$(echo "${PATHTOMYSBATCHSCRIPTS}/${SCRIPTNAME}") 
if [[ -z "${SLURM_JOB_ID}" ]] ; then JOBID=${RUNDATE} ; else JOBID=${SLURM_JOB_ID} ; fi 
SUBMITTEDSCRIPT=$(echo "${PATHTOMYSUBMITTEDSCRIPTS}/job${JOBID}-date${RUNDATE}-${SCRIPTNAME}") 
SLURMFILE=$(echo "${PATHTOMYSLURM}/slurm-${JOBID}.out") 
SLURM_JOB_TIMELIMIT=$(squeue -j $SLURM_JOB_ID -h --Format TimeLimit)

RSCRIPTNAME=$1
OUTPUTLOCATION=$(readlink -f $2)
ARGS=${@:2}

RSCRIPT=$(echo "${PATHTOMYTMPSCRIPTS}/${RSCRIPTNAME}") 
SUBMITTEDRSCRIPT=$(echo "${PATHTOMYSUBMITTEDSCRIPTS}/job${JOBID}-date${RUNDATE}-${RSCRIPTNAME}") 

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
	module load R_packages/4.3.1
	module load R/4.3.2
elif [[ $(hostname -f) == *pdc* ]] ; then
	module load systemdefault/1.0.0
	module load PDC/23.12
	module load R/4.4.1-cpeGNU-23.12
fi

echo 
echo "############################################################################"
echo "##ACTIONS:"
echo 
echo "##FILE CONTROL:"
echo 
echo "##INPUT:"
echo 

echo "RSCRIPTNAME: ${RSCRIPTNAME}
RSCRIPT: ${RSCRIPT}
ARGS: ${ARGS}
"

echo 
echo "############################################################################"
echo "##PROCESSING SCRIPT: ${RSCRIPT}"
echo 

##Set working directory.
cd $(readlink -f .)

##Run R script
IFS=$' '
Rscript --vanilla ${RSCRIPT} ${JOBID} ${ARGS}
IFS=${ORIGINALIFS}

echo 
echo "R SCRIPT ${RSCRIPT} PROCESSED."
echo 
echo "############################################################################"
echo "END OF BASH SCRIPT... $(date)"
echo "############################################################################"

##Save script and slurm files.
cat $0 > $(echo "${OUTPUTLOCATION}/job${JOBID}.script")
cat $0 > ${SUBMITTEDSCRIPT}
cat ${RSCRIPT} > $(echo "${OUTPUTLOCATION}/job${JOBID}.Rscript")
cat ${RSCRIPT} > ${SUBMITTEDRSCRIPT}
cat ${SLURMFILE} > $(echo "${OUTPUTLOCATION}/job${JOBID}.slurm") 

exit 0