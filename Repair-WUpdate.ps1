    function Repair-WUpdate{
        Get-PSProvider -PSProvider Environment
        $env = Get-ChildItem -Path Env:\
        $systemroot=$env | where Name -eq "SystemRoot" | select Value
        
        $bits = Get-Service -Name "bits"
        if($bits.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) { $bits.Stop(); $bits.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped); }
        
        $wuauserv = Get-Service -Name "wuauserv"
        if($wuauserv.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) { $wuauserv.Stop(); $wuauserv.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped); }        
        
        Rename-Item -Path "$($systemroot.Value)\SoftwareDistribution" -NewName SoftwareDistribution.bak -Force
        Rename-Item -Path "$($systemroot.Value)\System32\catroot2" -NewName catroot2.bak -Force

        
        $bits.Start()
        $wuauserv.Start()

        DISM.exe /Online /Cleanup-image /Restorehealth
    }
