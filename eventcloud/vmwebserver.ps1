Configuration vmwebserver
{
    Import-DscResource -ModuleName xWebAdministration
    Node "localhost"
    {

         WindowsFeature NETFW45HTTPActivation     
        {       
            Ensure = “Present” 
            Name = "NET-WCF-HTTP-Activation45"
        } 
        WindowsFeature NETFW35HTTPActivation    
        {       
            Ensure = “Present” 
            Name = "NET-HTTP-Activation"
        }
      #Install the IIS Role     
        WindowsFeature IIS     
        {       
            Ensure = “Present”       
            Name = “Web-Server”     
        }
        WindowsFeature WebHealth  
        {  
            Ensure = "Present"  
            Name = "Web-Health"
            IncludeAllSubFeature = $true 
        }  
        WindowsFeature WebPerformance  
        {  
            Ensure = "Present"  
            Name = "Web-Performance"
            IncludeAllSubFeature = $true 
        } 
        WindowsFeature WebSecurity  
        {  
            Ensure = "Present"  
            Name = "Web-Security"
            IncludeAllSubFeature = $true 
        }
        WindowsFeature AspNet 
        {  
            Ensure = "Present"  
            Name = "Web-Asp-Net"  
        }            
        WindowsFeature AspNet45  
        {  
            Ensure = "Present"  
            Name = "Web-Asp-Net45"  
        }  
        WindowsFeature ASP      
        {       
            Ensure = “Present”       
            Name = “Web-Asp”     
        }       
        WindowsFeature HTTPRedirect    
        {       
            Ensure = “Present”       
            Name = “Web-Http-Redirect”     
        }
        xWebAppPool EventCloudPool
        {
        Name = EventCloudPool
        Ensure = Present
        State = "Started"
        dependsOn = "[WindowsFeature]IIS"
        queueLength = '10000'
        startMode = 'AlwaysRunning'
        idleTimeout = '01:00:00'
        shutdownTimeLimit = '00:02:30'
        startupTimeLimit = '00:02:30'
        restartPrivateMemoryLimit = '1048576'
        restartTimeLimit = '00:00:00'
        rapidFailProtection = $false
        cpuResetInterval = '00:15:00'

        }
   
        xWebApplication EventCloud
        {
        Name = EventCloud
        PhysicalPath = "C:\EventCloud"
        Website = "Default Web Site"
        WebAppPool = EventCloudPool
        Ensure = "Present"
        DependsOn = "[xWebAppPool]EventCloudPool"

        }

        Log AfterDirectoryCopy
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the file resource with ID CreateFile"
            DependsOn = "[File]CreateFile" # This means run "CreateFile" first.
        }
    }
}

