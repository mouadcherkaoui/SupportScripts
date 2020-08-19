function Clear-EventLogs {
  $events = Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" -MaxEvents 1
  $events | ForEach-Object -Process { [System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog($_.LogName) }
}
