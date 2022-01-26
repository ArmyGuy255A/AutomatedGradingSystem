function Test-Condition {
    [CmdletBinding()]
    param (
        # This is the object that needs inspected
        [Parameter(ParameterSetName = "Default")]
        [object]
        $ReferenceObject,
        # This is the value that is expected for the object
        [Parameter(ParameterSetName = "Default")]
        [object]
        $ExpectedValue,
        # Use this to see if the expectedValue is within the reference object
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Contains")]
        [Switch]
        $Contains,
        # Use this to see if the expectedValue equals the reference object
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Equals")]
        [Switch]
        $Equals
    )

    [bool]$result = $false
    $compareResult = $null

    if ($Contains) {

        if (($ReferenceObject -is [string]) -and ($ExpectedValue -is [string])) {
            Write-Verbose "Comparing Strings"
            $result = [bool]$ReferenceObject.Contains($ExpectedValue)
        }
        else {
            Write-Verbose "Not a string"
            $compareResult = Compare-object -ReferenceObject $ReferenceObject -DifferenceObject $ExpectedValue | Where SideIndicator -eq "=>"
            if ($null -eq $compareResult) {
                $result = $true
            }
        }
    } 
    
    if ($Equals) {
        Write-Verbose "Performing Equals"

        $compareResult = Compare-Object -ReferenceObject $ReferenceObject -DifferenceObject $ExpectedValue
        if ($null -eq $compareResult) {
            $result = $true
        }
    }
        
    if ($result -eq $true) {
        return $result
        continue
    }
    
    return [bool]$result
}
    
# @("test", "test2") | Test-Condition -Contains -ExpectedValue "test3" -Verbose
# @("test", "test2") | Test-Condition -Contains -ExpectedValue "test2" -Verbose
# Test-Condition -ReferenceObject @("test", "test2", "test3") -Contains -ExpectedValue "test5" -Verbose
# Test-Condition -ReferenceObject @("test", "test2", "test3") -Contains -ExpectedValue "test2" -Verbose
# Test-Condition -ReferenceObject @("test", "test2", "test3") -Contains -ExpectedValue "tes" -Verbose


Test-Condition -ReferenceObject @(1,2,3) -Equals -ExpectedValue @(1,2,3) -Verbose
Test-Condition -ReferenceObject "test" -Equals -ExpectedValue "te" -Verbose
Test-Condition -ReferenceObject "test" -Equals -ExpectedValue "test" -Verbose
Test-Condition -ReferenceObject 1 -Equals -ExpectedValue 1 -Verbose
Test-Condition -ReferenceObject 1 -Equals -ExpectedValue 12 -Verbose