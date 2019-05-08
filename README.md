# simulated-motion
matlab model of simulated motion in rats 

The matlab code is dependent on the Petrinet software from the PIPECore repository:
https://github.com/sarahtattersall/PIPECore.git
Install, using maven.  Instructions:
https://github.com/sarahtattersall/PIPECore/tree/hierarchical-nets

Once PIPECore is installed, run its tests; they should run without errors.  

In order to run Petrinets under Matlab, the entire classpath needs to be added to the Matlab classpath.  
Although similar function is available through the dynamic javaclasspath command,
what seemed to work best for me was to update the classpath file directly.  

On my mac, this was:
/Applications/MATLAB_R2018b.app/toolbox/local/classpath.txt 
Adjust for your Matlab installation, and add entries, specifying a full path: 
[complete path to your maven repository]/.m2/repository/uk/ac/imperial/pipe-markov-chain/1.1.2-SNAPSHOT/pipe-markov-chain-1.1.2-SNAPSHOT.jar
[complete path to your maven repository]/.m2/repository/uk/ac/imperial/pipe-core/2.0.0-beta-2-SNAPSHOT/pipe-core-2.0.0-beta-2-SNAPSHOT.jar
[complete path to your maven repository]/.m2/repository/org/antlr/antlr4/4.5.3/antlr4-4.5.3.jar
[complete path to your maven repository]/.m2/repository/org/antlr/antlr4-runtime/4.5.3/antlr4-runtime-4.5.3.jar
[complete path to your maven repository]/.m2/repository/com/google/guava/guava/17.0/guava-17.0.jar
[complete path to your maven repository]/.m2/repository/commons-logging/commons-logging/1.1.3/commons-logging-1.1.3.jar
[complete path to your maven repository]/.m2/repository/commons-beanutils/commons-beanutils/1.8.3/commons-beanutils-1.8.3.jar
[complete path to your maven repository]/.m2/repository/commons-collections/commons-collections/3.0/commons-collections-3.0.jar
[complete path to your maven repository]/.m2/repository/commons-io/commons-io/1.3.2/commons-io-1.3.2.jar
[complete path to your maven repository]/.m2/repository/com/esotericsoftware/kryo/kryo/2.24.0/kryo-2.24.0.jar
[complete path to your maven repository]/.m2/repository/com/esotericsoftware/minlog/minlog/1.2/minlog-1.2.jar
[complete path to your maven repository]/.m2/repository/org/codehaus/jackson/jackson-mapper-asl/1.9.13/jackson-mapper-asl-1.9.13.jar
[complete path to your maven repository]/.m2/repository/org/codehaus/jackson/jackson-core-asl/1.9.13/jackson-core-asl-1.9.13.jar
[complete path to your maven repository]/.m2/repository/org/apache/logging/log4j/log4j-core/2.3/log4j-core-2.3.jar
[complete path to your maven repository]/.m2/repository/org/apache/logging/log4j/log4j-api/2.3/log4j-api-2.3.jar
[complete path to your maven repository]/.m2/repository/org/objenesis/objenesis/2.1/objenesis-2.1.jar
[complete path to your maven repository]/.m2/repository/de/twentyeleven/skysail/jgraphx-osgi/1.10.3.1/jgraphx-osgi-1.10.3.1.jar
[complete path to your maven repository]/.m2/repository/javax/json/javax.json-api/1.0/javax.json-api-1.0.jar
[complete path to your maven repository]/.m2/repository/org/glassfish/javax.json/1.0.4/javax.json-1.0.4.jar

This code was developed under Matlab R2018b, although some of it might run at lower versions.  
Known toolboxes needed:
antenna
neural net (for nprtool)

To run the tests, in Matlab:
cd('[complete path to git]/simulated-motion/test')

Open allTests.m; as noted in the comments, you may need to run: 
 addpath('[complete path to git]/simulated-motion/src')
 addpath('[complete path to git]/simulated-motion/test')
 savepath '[complete path to git]/simulated-motion/src/pathdef.m'
 savepath '[complete path to git]/simulated-motion/test/pathdef.m'

At the Matlab prompt:
 allTests
The tests take a few minutes and should run without errors. 

Sample scripts to execute the entire system:  
hds1
hds2

Debugging of the PIPE Petri net java code may require updating the following file: 
src/main/resources/log4j2.xml  in the PIPECore jar....
(I haven't figured out a way to override it by putting it in the matlab path, e.g., src/log4j2.xml doesn't work.)

Questions:  stevedoubleday@gmail.com
