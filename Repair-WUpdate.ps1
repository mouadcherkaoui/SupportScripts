    function Repair-WUpdate{
        Get-PSProvider -PSProvider Environment
        $env = Get-ChildItem -Path Env:\
        $systemroot= $env:SystemRoot #$env | where Name -eq "SystemRoot" | select Value
        
            $bits = Get-Service -Name "bits"
            if($bits.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) { $bits.Stop(); $bits.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped); }
        
            $wuauserv = Get-Service -Name "wuauserv"
            if($wuauserv.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) { $wuauserv.Stop(); $wuauserv.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped); }        
        
            $cryptSvc = Get-Service -Name "cryptSvc"
            if($cryptSvc.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) { $cryptSvc.Stop(); $cryptSvc.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped); }        
        
            $msiserver = Get-Service -Name "msiserver"
            if($msiserver.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) { $msiserver.Stop(); $msiserver.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped); }        
             
            
            if($(Test-Path -Path "$($env:SystemRoot)\SoftwareDistribution.bak")) { 
                Remove-Item -Path "$($env:SystemRoot)\SoftwareDistribution.bak" -Recurse -Force
            }

            if($(Test-Path -Path "$($env:SystemRoot)\System32\catroot2.bak")) { 
                Remove-Item -Path "$($env:SystemRoot)\System32\catroot2.bak" -Recurse -Force
            }

            Rename-Item -Path "$($env:SystemRoot)\SoftwareDistribution" -NewName SoftwareDistribution.bak -Force
            Rename-Item -Path "$($env:SystemRoot)\System32\catroot2" -NewName catroot2.bak -Force

        
            $bits.Start()
            $wuauserv.Start()
            $cryptSvc.Start()
            $msiserver.Start()        

        DISM.exe /Online /Cleanup-image /Restorehealth 
    }
