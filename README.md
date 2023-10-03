
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Tomcat JVM OutOfMemory Incident
---

Tomcat JVM OutOfMemory incident occurs when the Java Virtual Machine (JVM) running the Apache Tomcat server runs out of memory, which causes the server to crash or become unresponsive. This type of incident can happen due to a variety of reasons such as incorrect configuration settings, memory leaks, or insufficient memory allocation. When this incident occurs, it can impact the availability and performance of the web application running on the Tomcat server.

### Parameters
```shell
export PATH_TO_TOMCAT="PLACEHOLDER"

export TOMCAT_PID="PLACEHOLDER"

export HEAP_DUMP_FILE_PATH="PLACEHOLDER"

export THRESHOLD="PLACEHOLDER"
```

## Debug

### Check if there's enough available memory
```shell
free -m
```

### Check the current memory usage by the Tomcat server
```shell
ps -ef | grep tomcat
```

### Check the memory settings in the Tomcat configuration file
```shell
cat ${PATH_TO_TOMCAT}/bin/setenv.sh
```

### Check the JVM memory usage
```shell
jstat -gc ${TOMCAT_PID} 1000 10
```

### Check the heap dump for memory leaks
```shell
jmap -dump:format=b,file=${HEAP_DUMP_FILE_PATH} ${TOMCAT_PID}
```

### Analyze the heap dump for memory leak issues
```shell
jhat ${HEAP_DUMP_FILE_PATH}
```

### Check the garbage collector logs for clues
```shell
tail -f ${PATH_TO_TOMCAT}/logs/gc.log
```

### Check for any errors in the Tomcat logs
```shell
tail -f ${PATH_TO_TOMCAT}/logs/catalina.out
```

### Memory Leak: One of the possible reasons for the Tomcat JVM OutOfMemory incident could be a memory leak in the application causing it to consume all available memory.
```shell


#!/bin/bash



# Step 1: Get the process ID of the Tomcat application

pid=$(ps -ef | grep "tomcat" | grep -v grep | awk '{print $2}')



# Step 2: Get the current memory usage of the Tomcat application

mem=$(cat /proc/$pid/status | grep VmRSS | awk '{print $2}')



# Step 3: Check if the memory usage has increased since the last check

if [ "$mem" -gt "${THRESHOLD}" ]; then

    echo "Memory Leak Detected: Memory usage has exceeded the threshold of ${THRESHOLD} KB"

    echo "Memory usage: $mem KB"

    # Step 4: Generate a heap dump for analysis

    jmap -dump:format=b,file=/tmp/heapdump.hprof $pid

else

    echo "Memory usage is within normal limits"

fi


```

## Repair

### Increase the memory allocation for the Tomcat server by modifying its configuration files.
```shell


#!/bin/bash

# Define variables for memory allocation values

export ${MEMORY_XMS}=${VALUE}

export ${MEMORY_XMX}=${VALUE}

# Define variable for Tomcat configuration file path

export ${TOMCAT_CONF}=${PATH}

# Edit the Tomcat configuration file to increase memory allocation

sed -i "s/-Xmx[0-9]*m/-Xmx${MEMORY_XMX}m/g" $TOMCAT_CONF

sed -i "s/-Xms[0-9]*m/-Xms${MEMORY_XMS}m/g" $TOMCAT_CONF


# Restart the Tomcat server to apply the changes

systemctl restart tomcat.service


```