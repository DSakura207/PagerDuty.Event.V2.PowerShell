# PagerDuty.Event.V2.PowerShell
PowerShell Module for PagerDuty Event API v2

# Requirements

The module requires PowerShell 7.0+.

# Usages

## Import Module

The module supports using a different endpoint rather than default.

Set `PD_ALERT_URI` to change PagerDuty Event v2 alert event endpoint.

Set `PD_CHANGE_URI` to change PagerDuty Event v2 change event endpoint.

Import module with psd1.

```
Import-Module /path/to/PagerDutyEventV2.psd1
```

## Trigger an Alert


```
New-PagerDutyAlert -RoutingKey ReplaceItWithYourOwn32RoutingKey -Summary testAlert -Severity Critical -Source testSource -CustomDetails @{purpose="test";region="test"} -DeduplicationKey 'testKey' -Component 'testComponent' -Group 'testGroup' -Class 'testClass'
```

You must provide `RoutingKey`, `Summary`, `Severity`, and `Source`.

To trigger an alert with different severity, change `Severity` argument. You could use `Tab` to switch between allowed values.

The cmdlet returns an object like this:

```
StatusCode       : 202
Status           : success
Error            : 
Message          : Event processed
DeduplicationKey : 24082775f8044ad1a477afc8309ef28c
```

`DeduplicationKey` is required to acknowledge or resolve an alert.

## Acknowledge an Alert

```
Confirm-PagerDutyAlert -RoutingKey ReplaceItWithYourOwn32RoutingKey -DeduplicationKey testKey
```

You must provide `RoutingKey` and `DeduplicationKey`.

## Resolve an Alert

```
Resolve-PagerDutyAlert -RoutingKey ReplaceItWithYourOwn32RoutingKey -DeduplicationKey testKey
```

You must provide `RoutingKey` and `DeduplicationKey`.

## Send a Change Event

```
New-PagerDutyChange -RoutingKey ReplaceItWithYourOwn32RoutingKey -Summary 'testChange' -Source 'test' -CustomDetails @{purpose="test";region="test"} -Links @{href="http://example.com"},@{href="http://example2.com"}
```

You must provide `RoutingKey`, `Summary`, and `Source`.