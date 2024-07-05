param([Parameter(Mandatory=$True)] $JSONFile)

function CreateADGroup() {
    param([Parameter(Mandatory=$True)] $groupObject)

    $name = $groupObject.name

    # Create the AD group object
    New-ADGroup -name $name -GroupScope Global
}

function CreateADUser() {
    param([Parameter(Mandatory=$True)] $userObject)

    # Pull out the name from the JSON object
    $name = $userObject.name
    $password = $userObject.password

    # Generate a "first initial, last name" structure for username
    $firstName, $lastName = $name.Split(" ")
    $username = ($firstName[0] + $lastName).ToLower()
    $samAccountName = $username
    $principalName = $username
    
    # Create the AD user object
    New-ADUser -Name "$name" -GivenName $firstName -Surname $lastName -SamAccountName $samAccountName -UserPrincipalName $principalName@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

    # Add the user to its appropriate group
    foreach($groupName in $userObject.groups) {
        try {
            Get-ADGroup -Identity "$groupName"
            Add-ADGroupMember -Identity $groupName -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "User $name NOT added in group $groupName because it does not exist"
        }
    }
}

$json = (Get-Content $JSONFile | ConvertFrom-Json)

$Global:Domain = $json.domain

foreach($group in $json.groups) {
    CreateADGroup $group
}

foreach($user in $json.users) {
    CreateADUser $user
}