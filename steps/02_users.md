# 02 - Users

1. Creating ad_schema.json (with hard-coded credentials as an intentional bad practice)

```shell
Get-Content .\ad_schema.json | ConvertFrom-Json
```

2. Creating gen_ad.ps1

3. Testing gen_ad.ps1
```shell
cp .\ad_schema.json -ToSession $dc C:\Windows\Tasks
cp .\gen_ad.ps1 -ToSession $dc C:\Windows\Tasks
Enter-PSSession $dc
cd C:\Windows\Tasks
.\gen_ad.ps1
```
4. Verify if script worked
```shell
Get-ADGroup
Get-ADUser
```

### Troubleshooting

#### Can't login on workstation as a created user caused by reverting to a snapshot

>The security database on the server does not have a computer account for this workstation trust relationship.

__Disconnect__ from the domain and then __rejoin__

### Useful cmdlets
```shell
$creds = (Get-Credential)
$dc = New-PSSession 192.168.x.x -Credential ($creds)
echo $dc
```

```shell
Enter-PSSession $dc
Get-PSSession
Get-ADUser
Get-ADGroup
Get-ADGroup -Identity ""
```