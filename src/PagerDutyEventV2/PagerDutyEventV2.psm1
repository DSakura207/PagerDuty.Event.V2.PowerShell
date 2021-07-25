New-Variable -Name PagerDutyAlertEndpoint -Value ($Env:PD_ALERT_URI ?? "https://events.pagerduty.com/v2/enqueue") -Option ReadOnly
New-Variable -Name PagerDutyChangeEndpoint -Value ($Env:PD_CHANGE_URI ?? "https://events.pagerduty.com/v2/change/enqueue") -Option ReadOnly
New-Variable -Name ContentType -Value "application/json" -Option ReadOnly
New-Variable -Name DummyResult -Value ([PSCustomObject]@{ StatusCode = -1; Status = "RequestNotSend"; Error = "RequestNotSend"; Message = "RequestNotSend"; DeduplicationKey = "RequestNotSend" }) -Option ReadOnly

function New-PagerDutyAlert {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # This is the 32 character Integration Key for an integration on a service or on a global ruleset.
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateLength(32, 32)]
        [string]
        $RoutingKey,
        # Deduplication key for correlating triggers and resolves. The maximum permitted length of this property is 255 characters.
        [Parameter()]
        [string]
        $DeduplicationKey,
        # A brief text summary of the event, used to generate the summaries/titles of any associated alerts. The maximum permitted length of this property is 1024 characters.
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateLength(1, 1024)]
        [string]
        $Summary,
        # The unique location of the affected system, preferably a hostname or FQDN.
        [Parameter(Mandatory = $true, Position = 2)]
        [string]
        $Source,
        # The perceived severity of the status the event is describing with respect to the affected system. This can be Critical, Error, Warning or Info.
        [Parameter(Mandatory = $true, Position = 3)]
        [ValidateSet("Critical", "Error", "Warning", "Info")]
        $Severity,
        # The time at which the emitting tool detected or generated the event.
        [Parameter()]
        [datetime]
        $Timestamp,
        # Component of the source machine that is responsible for the event, for example mysql or eth0.
        [Parameter()]
        [string]
        $Component,
        # Logical grouping of components of a service, for example app-stack.
        [Parameter()]
        [string]
        $Group,
        # The class/type of the event, for example ping failure or cpu load.
        [Parameter()]
        [string]
        $Class,
        # Additional details about the event and affected system.
        [Parameter()]
        [hashtable]
        $CustomDetails,
        # List of images to include.
        [Parameter()]
        [hashtable[]]
        $Images,
        # List of links to include.
        [Parameter()]
        [hashtable[]]
        $Links
    )

    begin {

    }

    process {
        # Validate image and link objects.
        if ($Images) {
            foreach ($image in $Images) {
                validateImageObject $image
            }
        }
        if ($Links) {
            foreach ($link in $Links) {
                validateLinkObject $link
            }
        }

        # Prepare object.
        [pscustomobject]$object = [PSCustomObject]@{
            routing_key  = $RoutingKey
            event_action = "trigger"
            dedup_key    = $DeduplicationKey
            payload      = [PSCustomObject]@{
                summary        = $Summary
                source         = $Source
                severity       = $Severity.ToLower()
                timestamp      = $Timestamp ?? (Get-Date -Format "o")
                component      = $Component
                group          = $Group
                class          = $Class
                custom_details = $CustomDetails
            }
        }

        if ($Images) {
            Add-Member -InputObject $object -NotePropertyName 'images' -NotePropertyValue (prepareImages $Images)
        }

        if ($Links) {
            Add-Member -InputObject $object -NotePropertyName 'links' -NotePropertyValue (prepareLinks $Links)
        }

        if ($PSCmdlet.ShouldProcess($Source, "Trigger Alert")) {
            # Invoke Event API
            $result = invokeEventApi -InputObject $object -Uri $PagerDutyAlertEndpoint;
        }
        else {
            $result = $DummyResult
        }

        

        Write-Output $result
    }

    end {

    }
}

function Confirm-PagerDutyAlert {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # This is the 32 character Integration Key for an integration on a service or on a global ruleset.
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateLength(32, 32)]
        [string]
        $RoutingKey,
        # Deduplication key for correlating triggers and resolves. The maximum permitted length of this property is 255 characters.
        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $DeduplicationKey
    )

    begin {

    }

    process {
        # Prepare object.
        [pscustomobject]$object = [PSCustomObject]@{
            routing_key  = $RoutingKey
            event_action = "acknowledge"
            dedup_key    = $DeduplicationKey
        }

        if ($PSCmdlet.ShouldProcess($DeduplicationKey, "Acknowledge Alert")) {
            # Invoke Event API
            $result = invokeEventApi -InputObject $object -Uri $PagerDutyAlertEndpoint;
        }
        else {
            $result = $DummyResult
        }

        Write-Output $result
    }

    end {

    }
}

function Resolve-PagerDutyAlert {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # This is the 32 character Integration Key for an integration on a service or on a global ruleset.
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateLength(32, 32)]
        [string]
        $RoutingKey,
        # Deduplication key for correlating triggers and resolves. The maximum permitted length of this property is 255 characters.
        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $DeduplicationKey
    )

    begin {

    }

    process {
        # Prepare object.
        [pscustomobject]$object = [PSCustomObject]@{
            routing_key  = $RoutingKey
            event_action = "resolve"
            dedup_key    = $DeduplicationKey
        }

        if ($PSCmdlet.ShouldProcess($DeduplicationKey, "Resolve Alert")) {
            # Invoke Event API
            $result = invokeEventApi -InputObject $object -Uri $PagerDutyAlertEndpoint;
        }
        else {
            $result = $DummyResult
        }

        Write-Output $result
    }

    end {

    }
}

function New-PagerDutyChange {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # This is the 32 character Integration Key for an integration on a service or on a global ruleset.
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateLength(32, 32)]
        [string]
        $RoutingKey,
        # A brief text summary of the event, used to generate the summaries/titles of any associated alerts. The maximum permitted length of this property is 1024 characters.
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateLength(1, 1024)]
        [string]
        $Summary,
        # The unique location of the affected system, preferably a hostname or FQDN.
        [Parameter(Mandatory = $true, Position = 2)]
        [string]
        $Source,
        # The time at which the emitting tool detected or generated the event.
        [Parameter()]
        [datetime]
        $Timestamp,
        [Parameter()]
        [hashtable]
        $CustomDetails,
        # List of links to include.
        [Parameter()]
        [hashtable[]]
        $Links
    )

    begin {

    }

    process {
        # Validate image and link objects.
        if ($Links) {
            foreach ($link in $Links) {
                validateLinkObject $link
            }
        }

        # Prepare object.
        [pscustomobject]$object = [PSCustomObject]@{
            routing_key = $RoutingKey
            payload     = [PSCustomObject]@{
                summary        = $Summary
                source         = $Source
                timestamp      = $Timestamp ?? (Get-Date -Format "o")
                custom_details = $CustomDetails
            }
        }

        if ($Links) {
            Add-Member -InputObject $object -NotePropertyName 'links' -NotePropertyValue (prepareLinks $Links)
        }

        if ($PSCmdlet.ShouldProcess($Source, "New Change")) {
            # Invoke Event API
            $result = invokeEventApi -InputObject $object -Uri $PagerDutyAlertEndpoint;
        }
        else {
            $result = $DummyResult
        }

        Write-Output $result
    }

    end {

    }
}

function validateImageObject {
    param (
        # The image object to validate.
        [Parameter(Mandatory = $true)]
        [hashtable]
        $ImageObject
    )

    if ($ImageObject.Keys -notcontains 'src') {
        Write-Error -Exception ([System.MissingFieldException]::new("Missing key: src")) -ErrorAction Stop
    }

    $srcValue = $ImageObject['src'].ToString();
    if ( $false -eq $srcValue.StartsWith("https://") ) {
        Write-Error -Exception ([System.ArgumentException]::new("Image must be served via https: $srcValue")) -ErrorAction Stop
    }
}

function validateLinkObject {
    param (
        # The link object to validate.
        [Parameter(Mandatory = $true)]
        [hashtable]
        $LinkObject
    )

    if ($LinkObject.Keys -notcontains 'href') {
        Write-Error -Exception ([System.MissingFieldException]::new("Missing key: href")) -ErrorAction Stop
    }
}

function prepareImages {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable[]]
        $ImageObjects
    )
    [System.Collections.ArrayList]$imageList = New-Object -TypeName "System.Collections.ArrayList"
    foreach ($obj in $ImageObjects) {
        $imageObject = [PSCustomObject]@{
            src  = $obj["src"]
            href = $obj["href"]
            alt  = $obj["alt"]
        }
        [Void]$imageList.Add($imageObject)
    }
    Write-Output $imageList
}

function prepareLinks {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable[]]
        $LinkObjects
    )
    [System.Collections.ArrayList]$linkList = New-Object -TypeName "System.Collections.ArrayList"
    foreach ($obj in $LinkObjects) {
        $linkObject = [PSCustomObject]@{
            href = $obj["href"]
            text = $obj["text"]
        }
        [Void]$linkList.Add($linkObject)
    }
    Write-Output $linkList
}

function invokeEventApi {
    param (
        # Destation URI
        [Parameter(Mandatory = $true)]
        [string]
        $Uri,
        # Request object
        [Parameter(Mandatory = $true)]
        [PSCustomObject]
        $InputObject
    )

    [int]$statusCode = -1;
    [string]$json = ""

    $json = ConvertTo-Json $InputObject -Compress;

    Write-Verbose "Post Payload: $json"

    # Send object.
    $rc = Invoke-RestMethod -Uri $Uri -Method Post -ContentType $ContentType `
                            -Body $json `
                            -StatusCodeVariable "statusCode" `
                            -DisableKeepAlive `
                            -SkipHttpErrorCheck;

    Write-Verbose "Raw Response: $rc"

    $result = [PSCustomObject]@{}

    Add-Member -InputObject $result -NotePropertyName "StatusCode" -NotePropertyValue $statusCode;

    if ($result -is [psobject]) {
        Add-Member -InputObject $result -NotePropertyName "Status" -NotePropertyValue $rc.status
        Add-Member -InputObject $result -NotePropertyName "Error" -NotePropertyValue $rc.error
        Add-Member -InputObject $result -NotePropertyName "Message" -NotePropertyValue $rc.message
        Add-Member -InputObject $result -NotePropertyName "DeduplicationKey" -NotePropertyValue $rc.dedup_key
    }
    else {
        Add-Member -InputObject $result -NotePropertyName "Payload" -NotePropertyValue $rc
    }

    Write-Output $result
}

Export-ModuleMember -Function New-PagerDutyAlert, Confirm-PagerDutyAlert, Resolve-PagerDutyAlert, New-PagerDutyChange