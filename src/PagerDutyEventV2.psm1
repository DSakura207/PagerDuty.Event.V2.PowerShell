function New-PagerDutyAlert {
    [CmdletBinding()]
    param (
        # This is the 32 character Integration Key for an integration on a service or on a global ruleset.
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateLength(32,32)]
        [string]
        $RoutingKey,
        # Deduplication key for correlating triggers and resolves. The maximum permitted length of this property is 255 characters.
        [Parameter()]
        [string]
        $DeduplicationKey,
        # A brief text summary of the event, used to generate the summaries/titles of any associated alerts. The maximum permitted length of this property is 1024 characters.
        [Parameter(Mandatory=$true, Position=1)]
        [ValidateLength(1,1024)]
        [string]
        $Summary,
        # The unique location of the affected system, preferably a hostname or FQDN.
        [Parameter(Mandatory=$true, Position=2)]
        [string]
        $Source,
        # The perceived severity of the status the event is describing with respect to the affected system. This can be Critical, Error, Warning or Info.
        [Parameter(Mandatory=$true, Position=3)]
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
        
    }
    
    end {
        
    }
}

function Confirm-PagerDutyAlert {
    [CmdletBinding()]
    param (
        # This is the 32 character Integration Key for an integration on a service or on a global ruleset.
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateLength(32,32)]
        [string]
        $RoutingKey,
        # Deduplication key for correlating triggers and resolves. The maximum permitted length of this property is 255 characters.
        [Parameter(Mandatory=$true, Position=1)]
        [string]
        $DeduplicationKey
    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        
    }
}

function Resolve-PagerDutyAlert {
    [CmdletBinding()]
    param (
        # This is the 32 character Integration Key for an integration on a service or on a global ruleset.
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateLength(32,32)]
        [string]
        $RoutingKey,
        # Deduplication key for correlating triggers and resolves. The maximum permitted length of this property is 255 characters.
        [Parameter(Mandatory=$true, Position=1)]
        [string]
        $DeduplicationKey
    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        
    }
}

function New-PagerDutyChange {
    [CmdletBinding()]
    param (
        # This is the 32 character Integration Key for an integration on a service or on a global ruleset.
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateLength(32,32)]
        [string]
        $RoutingKey,
        # A brief text summary of the event, used to generate the summaries/titles of any associated alerts. The maximum permitted length of this property is 1024 characters.
        [Parameter(Mandatory=$true, Position=1)]
        [ValidateLength(1,1024)]
        [string]
        $Summary,
        # The unique location of the affected system, preferably a hostname or FQDN.
        [Parameter(Mandatory=$true, Position=2)]
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
        
    }
    
    end {
        
    }
}

function validateImageObject {
    param (
        # The image object to validate.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [hashtable]
        $ImageObject
    )
    
}

function validateLinkObject {
    param (
        # The link object to validate.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [hashtable]
        $LinkObject
    )
    
}

Export-ModuleMember -Function New-PagerDutyAlert, Confirm-PagerDutyAlert, Resolve-PagerDutyAlert, New-PagerDutyChange