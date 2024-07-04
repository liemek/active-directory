# 01 - Install the Domain Controller

1. Use `sconfig` to:
    - Change the hostname
    - Change the IP address to static
    - Change the DNS server to my own IP address

2. Install the Active Directory Windows Feature

```shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

```shell
Import-Module ADDSDeployment
```

```shell
Install-ADDSForest
```

3. Installation changes the DNS Server address to a loop address. Let's fix it.

```shell
Get-DNSClientServerAddress
Set-DNSClientServerAddress -InterfaceIndex x -ServerAddresses 192.168.x.x
Get-DNSClientServerAddress
```

4. Join the Workstation to the Domain

```shell
Add-Computer -DomainName domain.local -Credential domain\Administrator -Force -Restart
```
### Troubleshooting

1. Change DNS Server address on the Workstation
```shell
Get-DNSClientServerAddress
Set-DNSClientServerAddress -InterfaceIndex x -ServerAddresses 192.168.x.x
Get-DNSClientServerAddress
```

2. Make sure the Domain Controller is running

### Useful cmdlets

```shell
Get-NetIPAddress
```

```shell
Get-NetIPAddress -IPAddress 192.168.x.x
```