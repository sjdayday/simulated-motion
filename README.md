# simulated-motion
matlab model of simulated motion in rats 

The matlab code is dependent on the Java Petrinet software from the PIPECore repository:

https://github.com/sarahtattersall/PIPECore.git

Install, using maven.  Instructions:

https://github.com/sarahtattersall/PIPECore/tree/hierarchical-nets

Once PIPECore is installed, run its tests; they should run without errors.  

In order to run Petrinets under Matlab, the pipecore jar needs to be added to the Matlab classpath:  
https://github.com/sarahtattersall/PIPECore/releases/download/pipe-core--2.0.0/pipe-core-2.0.0.jar

Although similar function is available through the dynamic javaclasspath command,
what seemed to work best for me was to update the classpath file directly.  

On my mac, this was:

/Applications/MATLAB_R2018b.app/toolbox/local/classpath.txt
 
Adjust for your Matlab installation, and add entries, specifying a full path to the downloaded jar:
``` 
/Users/steve/PIPE/pipe-core-2.0.0.jar
```

This code was developed under Matlab R2018b, although some of it might run at lower versions.  
Known toolboxes needed:
* antenna
* neural net (for nprtool; without it, the system will still run, although some tests may break)

To run the tests, in Matlab:
```
cd('[complete path to git]/simulated-motion/test')
```
Open allTests.m; as noted in the comments, you may need to run:
``` 
 addpath('[complete path to git]/simulated-motion/src')
 addpath('[complete path to git]/simulated-motion/test')
 savepath '[complete path to git]/simulated-motion/src/pathdef.m'
 savepath '[complete path to git]/simulated-motion/test/pathdef.m'
```

Then move to the src directory:
```
cd('[complete path to git]/simulated-motion/src')
```
At the Matlab prompt:
```
allTests
```
The tests take many minutes and should run without errors. 

Sample objects that execute the entire system: S4, S8, S11  
```
s = S4(); 
s.runAll(); 
```

If more detailed debugging of the PIPE Petri net java code is needed, you may need to update the following file:
 
src/main/resources/log4j2.xml  in the PIPECore jar....

(I haven't figured out a way to override it by putting it in the matlab path, e.g., src/log4j2.xml doesn't work.)

This process hasn't been run on anyone else's machine yet, so is unlikely to be complete.  Please contact me with problems or open a github issue.
 
Questions:  stevedoubleday@gmail.com

Steve Doubleday
