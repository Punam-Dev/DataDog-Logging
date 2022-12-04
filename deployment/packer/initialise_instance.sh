#!/bin/bash
# Script to configure and install dependencies on the instance

app_name="app"
instance_username="ec2-user"

# Extract the application we want to host
# sudo su
sudo mkdir /var/$app_name
sudo cp -r /home/$instance_username/$app_name /var

# Ensure instance is up to date
sudo echo "Updating and installing yum dependencies"
sudo yum -y update

#dotnet install

sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
sudo yum install dotnet-sdk-3.1 -y

sudo yum -y install ufw
sudo ufw -f enable
sudo ufw allow 80/tcp

sudo ufw status



sudo chkconfig ufw on

sudo echo "before moving app_init"
sudo cat /home/$instance_username/app_init
#cd
#sed -i "s#{App.CMD}#$app_cmd#g" /home/$instance_username/app_init
sudo mv /home/$instance_username/app_init /etc/init.d/app_init
sudo echo "after moving app_init"
sudo cat /etc/init.d/app_init
sudo chmod 755 /etc/init.d/app_init

sudo sed -i -e 's/\r//g' /etc/init.d/app_init

sudo chkconfig app_init on


#----------------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------DATADOG config start--------------------------------------------------------#
#----------------------------------------------------------------------------------------------------------------------------------------------#

# Install Datadog agent inside the AMI for the POC
export datadog_api_key=$datadog_api_key
export application_name=$application_name

echo "application_name : $application_name"
echo "Datadog api key inside instance initialisation: $datadog_api_key"
echo "Datadog Installation"
echo "--------------------------------"
DD_API_KEY=$datadog_api_key DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
sudo systemctl stop datadog-agent

# #configure agent for apm
echo "rename existing config file"
sudo mv /etc/datadog-agent/datadog.yaml /etc/datadog-agent/datadog.yaml.old
echo "move custom config file with required settings"
sudo mv /home/ec2-user/datadog.yaml /etc/datadog-agent/datadog.yaml
echo "output new config file"
sudo cat /etc/datadog-agent/datadog.yaml

# sudo mkdir /etc/datadog-agent/conf.d/DatadogLoggingPOC.d
# sudo mv /home/ec2-user/conf.yaml /etc/datadog-agent/conf.d/DatadogLoggingPOC.d/conf.yaml
#"--------------------------------"

#Installation of Tracer Agent
echo "Install Tracer agent and configure"

# sudo curl -LO http://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/Packages/libxcrypt-4.4.18-3.el9.x86_64.rpm
# sudo rpm -Uvh libxcrypt-4.4.18-3.el9.x86_64.rpm


sudo curl -LO https://github.com/DataDog/dd-trace-dotnet/releases/download/v2.20.0/datadog-dotnet-apm-2.20.0-1.x86_64.rpm

sudo rpm -Uvh datadog-dotnet-apm-2.20.0-1.x86_64.rpm && sudo /opt/datadog/createLogPath.sh

sudo systemctl start datadog-agent

# removing the file as we are not adding datadog enable tag on the instance and will stop datadog agent running if left 
# sudo rm /root/check_for_datadog_tag.sh

# The required environment variables for Datadog are set in the proxy deployment app:
# ci-cd/deployment-app/src/LexisNexis.Rosetta.Proxy.Aws.Deploy/Apps/Deployment/ProxyDeploymentApp.cs

#----------------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------DATADOG config End----------------------------------------------------------#
#----------------------------------------------------------------------------------------------------------------------------------------------#