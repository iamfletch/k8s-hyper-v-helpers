1..255 | ForEach-Object {
    $udp = New-Object System.Net.Sockets.UdpClient
    $endpoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Parse("192.168.1.15")), 65535
    $udp.Send("", 0, $endpoint) | Out-Null
    $udp.Close()
}

$neighborTable = @{}
Get-NetNeighbor -AddressFamily IPv4 | ForEach-Object {
    $neighborTable[$_.LinkLayerAddress -replace "-", ":"] = $_.IPAddress
}

$results = Get-VM | ForEach-Object {
    $vm = $_
    Get-VMNetworkAdapter -VMName $vm.Name | ForEach-Object {#
        $mac = $_.MacAddress -replace '(.{2})(?!$)', '$1:'
        [PSCustomObject]@{
            VMName      = $vm.Name
            AdapterName = $_.Name
            MAC  = $mac
            IP = $neighborTable[$mac]
        }
    }
}

$results | Format-Table -AutoSize
