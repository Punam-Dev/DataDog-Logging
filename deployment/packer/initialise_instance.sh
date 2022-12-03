#!/bin/bash
# Script to configure and install dependencies on the instance

app_name="app"
instance_username="ec2-user"

# Extract the application we want to host
sudo su
mkdir /var/$app_name
cp -r /home/$instance_username/$app_name /var

# Ensure instance is up to date
echo "Updating and installing yum dependencies"
yum -y update

#dotnet install

rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
yum install dotnet-sdk-3.1 -y

echo "before moving app_init"
cat /home/$instance_username/app_init
#cd
#sed -i "s#{App.CMD}#$app_cmd#g" /home/$instance_username/app_init
mv /home/$instance_username/app_init /etc/init.d/app_init
echo "after moving app_init"
cat /etc/init.d/app_init
chmod 755 /etc/init.d/app_init

sed -i -e 's/\r//g' /etc/init.d/app_init

chkconfig app_init on


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
# echo "rename existing config file"
# sudo mv /etc/datadog-agent/datadog.yaml /etc/datadog-agent/datadog.yaml.old
# echo "move custom config file with required settings"
# sudo mv /home/ec2-user/datadog.yaml /etc/datadog-agent/datadog.yaml
# echo "output new config file"
# sudo cat /etc/datadog-agent/datadog.yaml
"--------------------------------"

#Installation of Tracer Agent
echo "Install Tracer agent and configure"


curl -LO https://github.com/DataDog/dd-trace-dotnet/releases/download/v2.20.0/datadog-dotnet-apm_2.20.0_amd64.deb

rpm -Uvh datadog-dotnet-apm<TRACER_VERSION>-1.x86_64.rpm && /opt/datadog/createLogPath.sh

systemctl start datadog-agent

# removing the file as we are not adding datadog enable tag on the instance and will stop datadog agent running if left 
rm /root/check_for_datadog_tag.sh

# The required environment variables for Datadog are set in the proxy deployment app:
# ci-cd/deployment-app/src/LexisNexis.Rosetta.Proxy.Aws.Deploy/Apps/Deployment/ProxyDeploymentApp.cs

#----------------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------DATADOG config End----------------------------------------------------------#
#----------------------------------------------------------------------------------------------------------------------------------------------#