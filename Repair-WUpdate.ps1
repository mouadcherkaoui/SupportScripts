    function Repair-WUpdate{
        $bits = Get-Service -Name "bits"
        if($bits.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running -and $bits.CanStop) { $bits.Stop() }
        $wuauserv = Get-Service -Name "bits"
        if($wuauserv.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running -and $wuauserv.CanStop) { $wuauserv.Stop() }        
        
        ren %systemroot%\SoftwareDistribution SoftwareDistribution.bak
        ren %systemroot%\System32\catroot2 catroot2.bak
        $bits.Start()
        $wuauserv.Start()

        DISM.exe /Online /Cleanup-image /Restorehealth
    }
