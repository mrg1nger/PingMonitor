#--------------Console Color Functions------------------
function Green
{
    process { Write-Host $_ -ForegroundColor Green }
}
function Red
{
    process { Write-Host $_ -ForegroundColor Red }
}
function Yellow
{
    process { Write-Host $_ -ForegroundColor DarkYellow }
}
#---------------------------------------------------------
#---------------------------------------------------------
function Ping-Monitor
{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Device, 
		[int]$timer,
		[int]$interval = 1,
		[ValidateSet("All","TimeOuts","Delays")]
		[string]$Display = "All", 
		[int]$delaythreshhold = 0

		
		
	)

	$ping = New-Object System.Net.Networkinformation.Ping #loads
	$stopwatch = [system.diagnostics.stopwatch]::StartNew()
	Clear-Host
	while ($true)
	{
		$date = Get-Date
		$ping_results = $ping.send($device)
		$show_ping_status = $ping_results.status
		$show_ping_time = $ping_results.RoundtripTime
		
		if ($timer -ne "0")
		{
			if ($stopwatch.Elapsed.TotalSeconds -gt $timer)
			{
				Write-Output "Times up!!!"
				Exit
			}
		}
		#Displays Timeouts Only
		if ($Display -eq "Timeouts")
		{
			
			if ($ping_results.status -eq "TimedOut")
			{
				Write-Output "Remote Device: $device // Delay: x_x // $date // Timed Out" | Red
			}
		}
		#Displays all results
		if ($Display -eq "All")
		{
			if ($ping_results.status -ne "TimedOut")
			{
				if($delaythreshhold -ne "0"){
					if ($show_ping_time -lt $delaythreshhold){
						Write-Output "Remote Device: $device // Delay: $show_ping_time // $date" | Green
					}
					if ($show_ping_time -gt $delaythreshhold){
						Write-Output "Remote Device: $device // Delay: $show_ping_time // $date // Degraded" | Yellow 
					}
					
				}
				if($delaythreshhold -eq "0"){
					Write-Output "Remote Device: $device // Delay: $show_ping_time // $date" | Green
				}
			}
			if ($ping_results.status -eq "TimedOut")
			{
				Write-Output "Remote Device: $device // Delay: x_x // $date // Timed Out" | Red
			}

						
		}
		#$ping_results
		Start-Sleep -Seconds $interval
	}
}

Ping-Monitor -Device google.com -Display All -interval 1 -delaythreshhold 200