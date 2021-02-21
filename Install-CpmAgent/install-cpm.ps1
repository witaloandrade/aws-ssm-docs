$service = Get-Service -Name CPMAgentService -ErrorAction SilentlyContinue
if ( $service.Length -ne "1"){
    $download_dir = "c:\cpm_agent"
    $cpm_url="https://${cpm_server_address}/static/media/CPMAgentService.msi"

    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    
    mkdir "$download_dir" -ErrorAction SilentlyContinue
    Set-Location "$download_dir"

    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile("$cpm_url", "${download_dir}/CPMAgentService.msi")

    $command_arguments = "/quiet /i CPMAgentService.msi SERVER_ADDRESS=${cpm_server_address}"

    Start-Process "msiexec.exe" $command_arguments -NoNewWindow -Wait

        If ($?) {
            "CPM Windows agent installed successfully"
            Set-Location "c:\"
            #Remove-Item "${download_dir}/CPMAgentService.msi"
            exit 0
                }
        else {
            "There was a problem while installing CPM Windows agent. Check ${download_dir} location for installation file"
            exit 1
             }
} 
else {
    "CPM Windows agent already installed"
    get-service -Name "CPMAgentService"
    exit 0
}
