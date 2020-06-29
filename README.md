# Code Coffee: Using LRZ Resources
Example scripts for using the LRZ resources


## Chapter 1: Getting an account and logging in

Staff of all Munich universities can get an LRZ account for free.  
All you have to do is to find your local master user. For the University Observatory these are Keith Butler and Rudolf Gabler. They can create an account for you. After that you'll automatically get an email with further instructions.

You can login to the LRZ systems via `ssh`:

`ssh lxlogin1.lrz.de -l username`

There are different login nodes (1, 2, 3, 4, 8, 10) and not all computer systems can be reached from all login nodes.

To have a look which computer systems can be reached from which login node, please follow [this link](https://doku.lrz.de/display/PUBLIC/Access+and+Login+to+the+Linux-Cluster#AccessandLogintotheLinuxCluster-LoginandSecurity).  
To see what computing services are online, you can follow [this link](https://doku.lrz.de/display/PUBLIC/High+Performance+Computing).

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



## Chapter 3: Managing jobs

## Chapter 4: Using the module system

## Chapter 5: Submitting a parallel job

## Chapter 6: Interactive computing

## Chapter 7: Cloud computing

## Chapter 8: Computing workshops at the LRZ