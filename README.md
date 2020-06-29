# Code Coffee: Using LRZ Resources

This repository is meant to give a very brief overview about using the high performance computing resources provided by the [Leibniz-Rechenzentrum](https://www.lrz.de/) (LRZ) in Garching.

It's not meant to be complete. For more information please follow the links provided.

## Chapter 1: Getting an account and logging in

Staff of all Munich universities can get an LRZ account for free.  
All you have to do is to find your local master user. For the University Observatory these are Keith Butler and Rudolf Gabler. They can create an account for you. After that you'll automatically get an email with further instructions.

You can login to the LRZ systems via `ssh`:

`ssh lxlogin1.lrz.de -l username`

There are different login nodes (e.g., 1, 2, 3, 4, 8, 10) and not all computer systems can be reached from all login nodes.

To have a look which computer systems can be reached from which login node, please follow [this link](https://doku.lrz.de/display/PUBLIC/Access+and+Login+to+the+Linux-Cluster#AccessandLogintotheLinuxCluster-LoginandSecurity).  
To see what computing services are online, you can follow [this link](https://doku.lrz.de/display/PUBLIC/High+Performance+Computing).

In your home directory you have 100 GByte per user available. If you need temporarily more space for large simulations you can run your simulation on the `scratch` file system, which has 1,400 TByte (total) available. Files on `scratch` will be deleted after a few days depending on the demand.

The path to `scratch` is saved in the environmental variable `$SCRATCH`.

Data in your home directory will be backed up and snapshots available up to 7 days back. Data on `scratch` will not be backed up.

## Chapter 2: Submitting a serial job

The LRZ uses the Workload Manager SLURM to manage their computing resources. To submit a job to the LRZ you have to write a batch script in which you describe which resources you request.

For a detailed description of SLURM, please read the [SLURM documentation](https://slurm.schedmd.com/documentation.html) or the [short manual](https://doku.lrz.de/display/PUBLIC/SLURM+Workload+Manager) on the LRZ website with example scripts.

To submit a job you first need to know which computer system is most suited for your problem. Here is an [overview](https://doku.lrz.de/display/PUBLIC/Access+and+Overview+of+HPC+Systems) of all computer system available at the LRZ with their architecture, RAM sizes, number of nodes, etc.

In chapter 2 we provide a small "Hello, World!" program written in Fortran to demonstrate the submission of a job. For this problem we decided to use the serial partition of the CoolMUC-2 system.

The [LRZ documentation](https://doku.lrz.de/display/PUBLIC/Resource+limits+for+serial+jobs+on+Linux+Cluster) tells us that the run time limit for serial jobs is 96 hours with a memory limit of 2.2 GByte. This is (just barely) enough for our program.

Keep in mind: If your program exceeds the runtime limit it will be terminated. So design your program in way that it writes down output data, from which it can be restarted.

We've provided a file `submit.slurm`, that submits or program into the serial queue. For a detailed description what all these field mean, please have a look [here](https://doku.lrz.de/display/PUBLIC/Running+serial+jobs+on+the+Linux-Cluster).

To submit the job simply execute the following command:

`sbatch submit.slurm`

It might be useful to write down the job ID.

The output that is usually printed on the screen will be written to the file specified in your SLURM script.

## Chapter 3: Managing jobs

Our job is now sent to the queue and is probably already finished. But there can be the case that our job is waiting in the queue, if all resources are occupied. Especially when you have submitted many jobs recently, it's more likely to have a longer waiting time.

If this is the case, you can display information about your job via

`scontrol --clusters=<cluster_name> show jobid=<job ID>`

In the case of our serial "Hello, World!" program this would translate to

`scontrol --clusters=serial show jobid=<job ID>`

This prints a list of "Keyword=Value" pairs with information about our job. Look for `StartTime=...`, which provides an estimate of when our job will be started. The estimate is based on other jobs in front of you in the queue and on how much memory/cores you requested.

Some of the parameters can still be changed while your job is waiting in the queue:

`scontrol --clusters=<cluster_name> update jobid=<job ID> TimeLimit=04:00:00`

which will for example change the runtime limit.

You can display all your running jobs with the following command:

`squeue --clusters=all -u $USER | grep '^[ ]*[0-9]+'`

If you noticed, that you fucked up something in program, you can cancel your job with

`scancel --clusters=<cluster_name> <JOB_ID>`

And finally, you can get information about finished jobs with

`sacct --clusters=<cluster_name> -j <job ID> --format="JobID,JobName,CPUTime,elapsed"`

For a full documentation about the functionality of these commands please read the manuals of [sacct](https://slurm.schedmd.com/sacct.html), [scancel](https://slurm.schedmd.com/scancel.html), [scontrol](https://slurm.schedmd.com/scontrol.html), and [squeue](https://slurm.schedmd.com/squeue.html).

The current load of the SLURM queue system can be viewed [here](https://www.lrz.de/services/compute/linux-cluster/status/SLURM/SLURM_Status.html), the current load of the computing systems can be viewed [here](https://www.lrz.de/services/compute/linux-cluster/status/SLURM/SLURM_Active_Jobs_Wrapper.html).

## Chapter 4: Using the module system

The LRZ computer systems have many useful tools already pre-installed, e.g., the Intel compiler suite, Intel's Math Kernel Library (MKL), the fast Fourier transform library FFTW, or several HDF5 libraries for storing large data files.

To see a list of all available modules simply type (Attention: very long list!)

`module avail`

You can load modules with

`module load <module_name>`

and unload them with

`module unload <module_name>`

To display all currently loaded modules use

`module list`

In this chapter we provide a small Fortran program, that calculates a simple matrix-matrix multiplication in two different ways:

1. straightforward by using three `do` loops
2. by using Intel MKL's `?gemm` (**GE**neral **M**atrix-**M**atrix multiplication) subroutine

and comparing the execution time of both approaches.

The documentation of the `?gemm` subroutine can be found [here](https://software.intel.com/en-us/node/468480) with some code examples [here](https://software.intel.com/content/www/us/en/develop/documentation/mkl-tutorial-fortran/top/multiplying-matrices-using-dgemm.html).

To compile our code we need to link it against the MKL library. Since we are on an Intel system, we want to get every single bit of performance by using the Intel Fortran compiler. We also need the MKL library that has been compiled with the same compiler.

We therefore need to load the following modules

`module load intel intel-mkl`

By loading the module `intel-mkl` they environment variables `$MKL_INC` and `$MKL_SHLIB` that are needed in the `Makefile` are automatically set and our program can be compiled.

The SLURM script just looks the same as for our "Hello, World!" program except that we requested more memory due to the large matrices. If you do not request enough memory, you'll get a "BUS error" (been there, done that...).

Check out the output file to see if you're going to use Intel's MKL library more often in the future!

## Chapter 5: Submitting a parallel job

The fun with super-computing starts when you can use more than one CPU and/or GPUs. LRZ's CoolMUC-2, for example, has 812 nodes with 28 cores per node and 2 hyperthreads per core! So you can either use MPI for distributed memory multiprocessing on multiple cores on several nodes or OpenMP for shared memory multiprocessing on multiple cores on a single node. Or both...

To find out what are the resource limits on the different LRZ machines, please follow this [link](https://doku.lrz.de/display/PUBLIC/Resource+limits+for+parallel+jobs+on+Linux+Cluster).

To keep it simple here, we just parallelize our matrix-matrix multiplication from chapter 4 with OpenMP and run it with 8 threads on a single node on CoolMUC-2.

All we have to do now is to add the OpenMP directives to our code and the `Makefile` and modify the SLURM script.

Check out the output file and compare the speed to the serial run!

## Chapter 6: Interactive computing

So far we've only submitted jobs to the queue, but once it's sent we cannot interact with it anymore. There are actually ways of interactively work on the LRZ systems.

The following command requests one task at the `cm2_inter` partition (the interactive partition of CoolMUC-2) with `salloc` and then automatically runs an interactive bash shell with `srun`, once the requested resource is granted:

`salloc -pcm2_inter -n 1 srun --pty bash -i`

Keep in mind: These resources are often reserved for LRZ workshops and are then not available.

You can now run your scripts, programs or even an interactive `iPython` session directly in the shell.

For more information (e.g. interactive parallel processing) please follow this [link](https://doku.lrz.de/display/PUBLIC/Running+serial+jobs+on+the+Linux-Cluster#RunningserialjobsontheLinuxCluster-InteractiveSLURMshell). Also, have a look at the [policies for interactive jobs](https://doku.lrz.de/display/PUBLIC/Resource+limits+for+serial+jobs+on+Linux+Cluster#ResourcelimitsforserialjobsonLinuxCluster-Policiesforinteractivejobs).

## Chapter 7: Cloud computing

## Chapter 8: Computing workshops at the LRZ

The LRZ offers a large variety of Workshops and Courses (currently remotely) about all aspects of high performance computing. Many of them are for free or for a available for a reduced price for students or university staff.

They are super interesting and you can learn a lot about programming and hardware! Please have a look at their [website](https://www.lrz.de/services/compute/courses/)!