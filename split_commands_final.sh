#This script expects to find a file called slurm_submit.darwin in the directory where it is run
#which contains the line ' application="command_line" '
#It will then replace the application with each line from its input file and output a file called
#submit_"prefix", where it assumes the last thing on each line of the input is "prefix" followed by a number
#Usage:
#sh split_commands_final <name of file containing prefixes and times>
while read line 
do
prefix=`echo $line | sed "s/\ .*//"`
time=`echo $line | sed "s/.*\ //"`
sed "s/application=\"command_line\"/application=\"command_line_$prefix\"/" slurm_submit.command_line_final >temp_$prefix
sed "s/#SBATCH\ --time=00:01:00/#SBATCH\ --time=$time/" temp_$prefix >slurm_submit_$prefix.darwin
rm temp_$prefix
done < $1
exit
