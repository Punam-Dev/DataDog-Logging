locals {

    instance-userdata = <<EOF
       #!/bin/bash
       sudo su
       echo "ASPNETCORE_ENVIRONMENT=${var.aspnetcore_environment}" >> /etc/environment
       echo "CORECLR_ENABLE_PROFILING=1" >> /etc/environment
       echo "CORECLR_PROFILER={846F5F1C-F9AE-4B07-969E-05C26BC060D8}" >> /etc/environment
       echo "CORECLR_PROFILER_PATH=/opt/datadog/Datadog.Trace.ClrProfiler.Native.so" >> /etc/environment
       echo "DD_DOTNET_TRACER_HOME=/opt/datadog" >> /etc/environment
       echo "DD_SERVICE=DDLOGGING" >> /etc/environment
       echo "DD_API_KEY=62b5b12e17cb73801cb1d36dfeac0ea6" >> /etc/environment
       echo "DD_SITE=datadoghq.com" >> /etc/environment
       echo "DD_LOGS_INJECTION=true" >> /etc/environment
       echo "DD_LOGS_DIRECT_SUBMISSION_INTEGRATIONS=Serilog" >> /etc/environment

       sudo systemctl start datadog-agent
    EOF
}