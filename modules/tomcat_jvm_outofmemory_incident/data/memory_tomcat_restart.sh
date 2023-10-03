

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