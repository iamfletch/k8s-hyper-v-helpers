# Adaptation from original script by James Vincent
# https://jamesvincent.co.uk/2024/01/09/use-powershell-to-create-and-launch-a-new-hyper-v-virtual-machine/

$ISO = Read-Host "Enter the path to your ISO file"
$VMPath = "C:\VMs"
$SwitchName = "k8s"

$NetAdapter = Read-Host "Enter the net adapter to use"
New-VMSwitch -Name $SwitchName -NetAdapterName $NetAdapter -AllowManagementOS $true

# VM names
$VMNames = @(
    "k8s-cp-0",
    "k8s-cp-1",
    "k8s-cp-2",
    "k8s-worker-0",
    "k8s-worker-1",
    "k8s-worker-2"
)

foreach ($VMName in $VMNames) {
    Write-Host "Creating VM: $VMName..." -ForegroundColor Cyan

    New-VM -Name "$VMName" `
           -MemoryStartupBytes 4GB `
           -Path "$VMPath" `
           -Generation 2 `
           -NewVHDPath "$VMPath\$VMName\Virtual Hard Disks\$VMName.vhdx" `
           -NewVHDSizeBytes 60GB `
           -SwitchName $SwitchName

    Set-VM -Name "$VMName" -ProcessorCount 4
    Add-VMDvdDrive -VMName "$VMName" -Path "$ISO"
    Get-VMDvdDrive -VMName "$VMName"

    Set-VMFirmware "$VMName" -EnableSecureBoot Off 
    Set-VMFirmware -VMName "$VMName" -FirstBootDevice (Get-VMDvdDrive -VMName "$VMName")

    $DefaultBootOrder = Get-VMFirmware -VMName $VMName | Select-Object -ExpandProperty BootOrder
    $BootOrder = $DefaultBootOrder | Where-Object { $_.BootType -ne "Network" }
    Set-VMFirmware -VMName $VMName -BootOrder $BootOrder

    # Enable TPM and disable checkpoints
    Set-VMKeyProtector -VMName "$VMName" -NewLocalKeyProtector
    Enable-VMTPM -VMName "$VMName"
    Set-VM -Name "$VMName" -CheckpointType Disabled

    # Start the VM
    Start-VM -Name "$VMName"

    Write-Host "$VMName created and started." -ForegroundColor Green
}
