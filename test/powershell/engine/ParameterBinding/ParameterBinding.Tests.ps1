Describe "Parameter Binding Tests" -Tags "CI" {
    It "Should throw a parameter binding exception when two parameters have the same position" {
        function test-PositionalBinding1 {
            [CmdletBinding()]
            param (
            [Parameter(Position = 0)] [int]$Parameter1 = 0,
            [Parameter(Position = 0)] [int]$Parameter2 = 0
            )

            Process {
                return $true
            }
        }

        try
        {
            test-PositionalBinding1 1
            throw "No Exception!"
        }
        catch
        {
            $_.FullyQualifiedErrorId | should be "AmbiguousPositionalParameterNoName,test-PositionalBinding1"
        }
    }

    It "a mandatory parameter can't be passed a null if it doesn't have AllowNullAttribute" {
        function test-allownullattributes {
            [CmdletBinding()]
            param (
            [string]$Parameter1 = "default1",
            [Parameter(Mandatory = $true)] [string]$Parameter2 = "default2",
            [Parameter(Mandatory = $true)] [string]$Parameter3 = "default3",
            [AllowNull()] [int]$Parameter4 = 0,
            [AllowEmptyString()][int]$Parameter5 = 0,
            [Parameter(Mandatory = $true)] [int]$ShowMe = 0
            )

            Process {
                switch ( $ShowMe )
                {
                    1 {
                        return $Parameter1
                        break
                        }
                    2 {
                        return $Parameter2
                        break
                        }
                    3 {
                        return $Parameter3
                        break
                        }
                    4 {
                        return $Parameter4
                        break
                        }
                    5 {
                        return $Parameter5
                        break
                        }
                }
            }
        }

        try
        {
            test-allownullattributes -Parameter2 1 -Parameter3 $null -ShowMe 1
            throw "No Exception!"
        }
        catch
        {
            $_.FullyQualifiedErrorId | should be "ParameterArgumentValidationErrorEmptyStringNotAllowed,test-allownullattributes"
            $_.CategoryInfo | Should match "ParameterBindingValidationException"
            $_.Exception.Message | should match "Parameter3"
        }
    }

    It "can't pass an argument that looks like a boolean parameter to a named string parameter" {
        function test-namedwithboolishargument {
            [CmdletBinding()]
            param (
            [bool] $Parameter1 = $false,
            [Parameter(Position = 0)] [string]$Parameter2 = ""
            )

            Process {
                return $Parameter2
            }
        }

        try
        {
            test-namedwithboolishargument -Parameter2 -Parameter1
            throw "No Exception!"
        }
        catch
        {
            $_.FullyQualifiedErrorId | should be "MissingArgument,test-namedwithboolishargument"
            $_.CategoryInfo | Should match "ParameterBindingException"
            $_.Exception.Message | should match "Parameter2"
        }
    }

    It "Verify that a SwitchParameter's IsPresent member is false if the parameter is not specified" {
        function test-singleswitchparameter {
            [CmdletBinding()]
            param (
            [switch]$Parameter1
            )

            Process {
                return $Parameter1.IsPresent
            }
        }

        $result = test-singleswitchparameter
        $result | Should Be $false
    }

    It "Verify that a bool parameter returns proper value" {
        function test-singleboolparameter {
            [CmdletBinding()]
            param (
            [bool]$Parameter1 = $false
            )

            Process {
                return $Parameter1
            }
        }

        $result1 = test-singleboolparameter
        $result1 | Should Be $false

        $result2 = test-singleboolparameter -Parameter1:1
        $result2 | Should Be $true
    }

    It "Should throw a exception when passing a string that can't be parsed by Int" {
        function test-singleintparameter {
            [CmdletBinding()]
            param (
            [int]$Parameter1 = 0
            )

            Process {
                return $Parameter1
            }
        }

        try
        {
            test-singleintparameter -Parameter1 'dookie'
            throw "No Exception!"
        }
        catch
        {
            $_.FullyQualifiedErrorId | should be "ParameterArgumentTransformationError,test-singleintparameter"
            $_.CategoryInfo | Should match "ParameterBindingArgumentTransformationException"
            $_.Exception.Message | should match "Input string was not in a correct format"
            $_.Exception.Message | should match "Parameter1"
        }
    }

    It "Verify that WhatIf is available when SupportShouldProcess is true" {
        function test-supportsshouldprocess2 {
            [CmdletBinding(SupportsShouldProcess = $true)]
            Param ()

            Process {
                return 1
            }
        }

        $result = test-supportsshouldprocess2 -Whatif
        $result | Should Be 1
    }

    It "Verify that ValueFromPipeline takes precedence over ValueFromPipelineByPropertyName without type coercion" {
        function test-bindingorder2 {
            [CmdletBinding()]
            param (
            [Parameter(ValueFromPipeline = $true, ParameterSetName = "one")] [string]$Parameter1 = "",
            [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = "two")] [int]$Length = 0
            )

            Process {
                return "$Parameter1 - $Length"
            }
        }

        $result = '0123' | test-bindingorder2
        $result | Should Be "0123 - 0"
    }

    It "Verify that a ScriptBlock object can be delay-bound to a parameter of type FileInfo with pipeline input" {
        function test-scriptblockbindingfrompipeline {
            [CmdletBinding()]
            param (
            [Parameter(ValueFromPipeline = $true)] [System.IO.FileInfo]$Parameter1
            )

            Process {
                return $Parameter1.Name
            }
        }
        $testFile = Join-Path $TestDrive -ChildPath "testfile.txt"
        New-Item -Path $testFile -ItemType file -Force
        $result = Get-Item $testFile | test-scriptblockbindingfrompipeline -Parameter1 {$_}
        $result | Should Be "testfile.txt"
    }

    It "Verify that a dynamic parameter named WhatIf doesn't conflict if SupportsShouldProcess is false" {
        function test-dynamicparameters3 {
            [CmdletBinding(SupportsShouldProcess = $false)]
            param (
            [Parameter(ParameterSetName = "one")] [int]$Parameter1 = 0,
            [Parameter(ParameterSetName = "two")] [int]$Parameter2 = 0,
            [int]$WhatIf = 0
            )
        }

        { test-dynamicparameters3 -Parameter1 1 } | Should Not Throw
    }

    It "Verify that an int can be bound to a parameter of type Array" {
        function test-collectionbinding1 {
            [CmdletBinding()]
            param (
            [array]$Parameter1,
            [int[]]$Parameter2
            )

            Process {
                $result = ""
                if($null -ne $Parameter1)
                {
                    $result += " P1"
                    foreach ($object in $Parameter1)
                    {
                        $result = $result + ":" + $object.GetType().Name + "," + $object
                    }
                }
                if($null -ne $Parameter2)
                {
                    $result += " P2"
                    foreach ($object in $Parameter2)
                    {
                        $result = $result + ":" + $object.GetType().Name + "," + $object
                    }
                }
                return $result.Trim()
            }
        }

        $result = test-collectionbinding1 -Parameter1 1 -Parameter2 2
        $result | Should Be "P1:Int32,1 P2:Int32,2"
    }

    It "Verify that a dynamic parameter and an alias can't have the same name" {
        function test-nameconflicts6 {
            [CmdletBinding()]
            param (
            [Alias("Parameter2")]
            [int]$Parameter1 = 0,
            [int]$Parameter2 = 0
            )
        }

        try
        {
            test-nameconflicts6 -Parameter2 1
            throw "No Exception!"
        }
        catch
        {
            $_.FullyQualifiedErrorId | should be "ParameterNameConflictsWithAlias"
            $_.CategoryInfo | Should match "MetadataException"
            $_.Exception.Message | should match "Parameter1"
            $_.Exception.Message | should match "Parameter2"
        }
    }

    Context "Use automatic variables as default value for parameters" {
        BeforeAll {
            ## Explicit use of 'CmdletBinding' make it a script cmdlet
            $test1 = @'
                [CmdletBinding()]
                param ($Root = $PSScriptRoot)
                "[$Root]"
'@
            ## Use of 'Parameter' implicitly make it a script cmdlet
            $test2 = @'
                param (
                    [Parameter()]
                    $Root = $PSScriptRoot
                )
                "[$Root]"
'@
            $tempDir = Join-Path -Path $TestDrive -ChildPath "DefaultValueTest"
            $test1File = Join-Path -Path $tempDir -ChildPath "test1.ps1"
            $test2File = Join-Path -Path $tempDir -ChildPath "test2.ps1"

            $expected = "[$tempDir]"
            $psPath = "$PSHOME\powershell"

            $null = New-Item -Path $tempDir -ItemType Directory -Force
            Set-Content -Path $test1File -Value $test1 -Force
            Set-Content -Path $test2File -Value $test2 -Force
        }

        AfterAll {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }

        It "Test dot-source should evaluate '`$PSScriptRoot' for parameter default value" {
            $result = . $test1File
            $result | Should Be $expected

            $result = . $test2File
            $result | Should Be $expected
        }

        It "Test 'powershell -File' should evaluate '`$PSScriptRoot' for parameter default value" {
            $result = & $psPath -NoProfile -File $test1File
            $result | Should Be $expected

            $result = & $psPath -NoProfile -File $test2File
            $result | Should Be $expected
        }
    }

    Context "ValueFromRemainingArguments" {
        BeforeAll {
            function Test-BindingFunction {
                param (
                    [Parameter(ValueFromRemainingArguments)]
                    [object[]] $Parameter
                )

                return [pscustomobject] @{
                    ArgumentCount = $Parameter.Count
                    Value = $Parameter
                }
            }

            # Deliberately not using TestDrive:\ here because Pester will fail to clean it up due to the
            # assembly being loaded in our process.

            if ($IsWindows)
            {
                $tempDir = $env:temp
            }
            else
            {
                $tempDir = '/tmp'
            }

            $dllPath = Join-Path $tempDir TestBindingCmdlet.dll

            Add-Type -OutputAssembly $dllPath -TypeDefinition '
                using System;
                using System.Management.Automation;

                [Cmdlet("Test", "BindingCmdlet")]
                public class TestBindingCommand : PSCmdlet
                {
                    [Parameter(Position = 0, ValueFromRemainingArguments = true)]
                    public string[] Parameter { get; set; }

                    protected override void ProcessRecord()
                    {
                        PSObject obj = new PSObject();

                        obj.Properties.Add(new PSNoteProperty("ArgumentCount", Parameter.Length));
                        obj.Properties.Add(new PSNoteProperty("Value", Parameter));

                        WriteObject(obj);
                    }
                }
            '

            Import-Module $dllPath
        }

        AfterAll {
            Get-Module TestBindingCmdlet | Remove-Module -Force
        }

        It "Binds properly when passing an explicit array to an advanced function" {
            $result = Test-BindingFunction 1,2,3

            $result.ArgumentCount | Should Be 3
            $result.Value[0] | Should Be 1
            $result.Value[1] | Should Be 2
            $result.Value[2] | Should Be 3
        }

        It "Binds properly when passing multiple arguments to an advanced function" {
            $result = Test-BindingFunction 1 2 3

            $result.ArgumentCount | Should Be 3
            $result.Value[0] | Should Be 1
            $result.Value[1] | Should Be 2
            $result.Value[2] | Should Be 3
        }

        It "Binds properly when passing an explicit array to a cmdlet" {
            $result = Test-BindingCmdlet 1,2,3

            $result.ArgumentCount | Should Be 3
            $result.Value[0] | Should Be 1
            $result.Value[1] | Should Be 2
            $result.Value[2] | Should Be 3
        }

        It "Binds properly when passing multiple arguments to a cmdlet" {
            $result = Test-BindingCmdlet 1 2 3

            $result.ArgumentCount | Should Be 3
            $result.Value[0] | Should Be 1
            $result.Value[1] | Should Be 2
            $result.Value[2] | Should Be 3
        }
    }
}


Describe "Custom type conversion in parameter binding" {
    BeforeAll {
        ## Prepare the script module
        $content = @'
    function Test-ScriptCmdlet {
        [CmdletBinding(DefaultParameterSetName = "File")]
        param(
            [Parameter(Mandatory, ParameterSetName = "File")]
            [System.IO.FileInfo] $File,

            [Parameter(Mandatory, ParameterSetName = "StartInfo")]
            [System.Diagnostics.ProcessStartInfo] $StartInfo
        )

        if ($PSCmdlet.ParameterSetName -eq "File") {
            $File.Name
        } else {
            $StartInfo.FileName
        }
    }

    function Test-ScriptFunction {
        param(
            [System.IO.FileInfo] $File,
            [System.Diagnostics.ProcessStartInfo] $StartInfo
        )

        if ($null -ne $File) {
            $File.Name
        }
        if ($null -ne $StartInfo) {
            $StartInfo.FileName
        }
    }
'@
        Set-Content -Path $TestDrive\module.psm1 -Value $content -Force

        ## Prepare the C# module
        $code = @'
    using System.IO;
    using System.Diagnostics;
    using System.Management.Automation;

    namespace Test
    {
        [Cmdlet("Test", "BinaryCmdlet", DefaultParameterSetName = "File")]
        public class TestCmdletCommand : PSCmdlet
        {
            [Parameter(Mandatory = true, ParameterSetName = "File")]
            public FileInfo File { get; set; }

            [Parameter(Mandatory = true, ParameterSetName = "StartInfo")]
            public ProcessStartInfo StartInfo { get; set; }

            protected override void ProcessRecord()
            {
                if (this.ParameterSetName == "File")
                {
                    WriteObject(File.Name);
                }
                else
                {
                    WriteObject(StartInfo.FileName);
                }
            }
        }
    }
'@
        $asmFile = [System.IO.Path]::GetTempFileName() + ".dll"
        Add-Type -TypeDefinition $code -OutputAssembly $asmFile

        ## Helper function to execute script
        function Execute-Script {
            [CmdletBinding(DefaultParameterSetName = "Script")]
            param(
                [Parameter(Mandatory)]
                [powershell]$ps,

                [Parameter(Mandatory, ParameterSetName = "Script")]
                [string]$Script,

                [Parameter(Mandatory, ParameterSetName = "Command")]
                [string]$Command,

                [Parameter(Mandatory, ParameterSetName = "Command")]
                [string]$ParameterName,

                [Parameter(Mandatory, ParameterSetName = "Command")]
                [object]$Argument
            )
            $ps.Commands.Clear()
            $ps.Streams.ClearStreams()

            if ($PSCmdlet.ParameterSetName -eq "Script") {
                $ps.AddScript($Script).Invoke()
            } else {
                $ps.AddCommand($Command).AddParameter($ParameterName, $Argument).Invoke()
            }
        }

        ## Helper command strings
        $changeToConstrainedLanguage = '$ExecutionContext.SessionState.LanguageMode = "ConstrainedLanguage"'
        $getLanguageMode = '$ExecutionContext.SessionState.LanguageMode'
        $importScriptModule = "Import-Module $TestDrive\module.psm1"
        $importCSharpModule = "Import-Module $asmFile"
    }

    AfterAll {
        ## Set the LanguageMode to force rebuilding the type conversion cache.
        ## This is needed because type conversions happen in the new powershell runspace with 'ConstrainedLanguage' mode
        ## will be put in the type conversion cache, and that may affect the default session.
        $ExecutionContext.SessionState.LanguageMode = "FullLanguage"
    }

    It "Custom type conversion in parameter binding is allowed in FullLanguage" {
        ## Create a powershell instance for the test
        $ps = [powershell]::Create()
        try {
            ## Import the modules in FullLanguage mode
            Execute-Script -ps $ps -Script $importScriptModule
            Execute-Script -ps $ps -Script $importCSharpModule

            $languageMode = Execute-Script -ps $ps -Script $getLanguageMode
            $languageMode | Should Be 'FullLanguage'

            $result1 = Execute-Script -ps $ps -Script "Test-ScriptCmdlet -File fileToUse"
            $result1 | Should Be "fileToUse"

            $result2 = Execute-Script -ps $ps -Script "Test-ScriptFunction -File fileToUse"
            $result2 | Should Be "fileToUse"

            $result3 = Execute-Script -ps $ps -Script "Test-BinaryCmdlet -File fileToUse"
            $result3 | Should Be "fileToUse"

            ## Conversion involves setting properties of an instance of the target type is allowed in FullLanguage mode
            $hashValue = @{ FileName = "filename"; Arguments = "args" }
            $psobjValue = [PSCustomObject] $hashValue

            ## Test 'Test-ScriptCmdlet -StartInfo' with IDictionary and PSObject with properties
            $result4 = Execute-Script -ps $ps -Command "Test-ScriptCmdlet" -ParameterName "StartInfo" -Argument $hashValue
            $result4 | Should Be "filename"
            $result5 = Execute-Script -ps $ps -Command "Test-ScriptCmdlet" -ParameterName "StartInfo" -Argument $psobjValue
            $result5 | Should Be "filename"

            ## Test 'Test-ScriptFunction -StartInfo' with IDictionary and PSObject with properties
            $result6 = Execute-Script -ps $ps -Command "Test-ScriptFunction" -ParameterName "StartInfo" -Argument $hashValue
            $result6 | Should Be "filename"
            $result7 = Execute-Script -ps $ps -Command "Test-ScriptFunction" -ParameterName "StartInfo" -Argument $psobjValue
            $result7 | Should Be "filename"

            ## Test 'Test-BinaryCmdlet -StartInfo' with IDictionary and PSObject with properties
            $result8 = Execute-Script -ps $ps -Command "Test-BinaryCmdlet" -ParameterName "StartInfo" -Argument $hashValue
            $result8 | Should Be "filename"
            $result9 = Execute-Script -ps $ps -Command "Test-BinaryCmdlet" -ParameterName "StartInfo" -Argument $psobjValue
            $result9 | Should Be "filename"
        }
        finally {
            $ps.Dispose()
        }
    }

    It "Some custom type conversion in parameter binding is allowed for trusted cmdlets in ConstrainedLanguage" {
        ## Create a powershell instance for the test
        $ps = [powershell]::Create()
        try {
            ## Import the modules in FullLanguage mode
            Execute-Script -ps $ps -Script $importScriptModule
            Execute-Script -ps $ps -Script $importCSharpModule

            $languageMode = Execute-Script -ps $ps -Script $getLanguageMode
            $languageMode | Should Be 'FullLanguage'

            ## Change to ConstrainedLanguage mode
            Execute-Script -ps $ps -Script $changeToConstrainedLanguage
            $languageMode = Execute-Script -ps $ps -Script $getLanguageMode
            $languageMode | Should Be 'ConstrainedLanguage'

            $result1 = Execute-Script -ps $ps -Script "Test-ScriptCmdlet -File fileToUse"
            $result1 | Should Be "fileToUse"

            $result2 = Execute-Script -ps $ps -Script "Test-ScriptFunction -File fileToUse"
            $result2 | Should Be "fileToUse"

            $result3 = Execute-Script -ps $ps -Script "Test-BinaryCmdlet -File fileToUse"
            $result3 | Should Be "fileToUse"

            ## If the conversion involves setting properties of an instance of the target type,
            ## then it's disallowed even for trusted cmdlets.
            $hashValue = @{ FileName = "filename"; Arguments = "args" }
            $psobjValue = [PSCustomObject] $hashValue

            ## Test 'Test-ScriptCmdlet -StartInfo' with IDictionary and PSObject with properties
            try {
                Execute-Script -ps $ps -Command "Test-ScriptCmdlet" -ParameterName "StartInfo" -Argument $hashValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingArgumentTransformationException,Execute-Script"
            }

            try {
                Execute-Script -ps $ps -Command "Test-ScriptCmdlet" -ParameterName "StartInfo" -Argument $psobjValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingArgumentTransformationException,Execute-Script"
            }

            ## Test 'Test-ScriptFunction -StartInfo' with IDictionary and PSObject with properties
            try {
                Execute-Script -ps $ps -Command "Test-ScriptFunction" -ParameterName "StartInfo" -Argument $hashValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingArgumentTransformationException,Execute-Script"
            }

            try {
                Execute-Script -ps $ps -Command "Test-ScriptFunction" -ParameterName "StartInfo" -Argument $psobjValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingArgumentTransformationException,Execute-Script"
            }

            ## Test 'Test-BinaryCmdlet -StartInfo' with IDictionary and PSObject with properties
            try {
                Execute-Script -ps $ps -Command "Test-BinaryCmdlet" -ParameterName "StartInfo" -Argument $hashValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingException,Execute-Script"
            }

            try {
                Execute-Script -ps $ps -Command "Test-BinaryCmdlet" -ParameterName "StartInfo" -Argument $psobjValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingException,Execute-Script"
            }
        }
        finally {
            $ps.Dispose()
        }
    }

    It "Custom type conversion in parameter binding is NOT allowed for untrusted cmdlets in ConstrainedLanguage" {
        ## Create a powershell instance for the test
        $ps = [powershell]::Create()
        try {
            $languageMode = Execute-Script -ps $ps -Script $getLanguageMode
            $languageMode | Should Be 'FullLanguage'

            ## Change to ConstrainedLanguage mode
            Execute-Script -ps $ps -Script $changeToConstrainedLanguage
            $languageMode = Execute-Script -ps $ps -Script $getLanguageMode
            $languageMode | Should Be 'ConstrainedLanguage'

            ## Import the modules in ConstrainedLanguage mode
            Execute-Script -ps $ps -Script $importScriptModule
            Execute-Script -ps $ps -Script $importCSharpModule

            $result1 = Execute-Script -ps $ps -Script "Test-ScriptCmdlet -File fileToUse"
            $result1 | Should Be $null
            $ps.Streams.Error.Count | Should Be 1
            $ps.Streams.Error[0].FullyQualifiedErrorId | Should Be "ParameterArgumentTransformationError,Test-ScriptCmdlet"

            $result2 = Execute-Script -ps $ps -Script "Test-ScriptFunction -File fileToUse"
            $result2 | Should Be $null
            $ps.Streams.Error.Count | Should Be 1
            $ps.Streams.Error[0].FullyQualifiedErrorId | Should Be "ParameterArgumentTransformationError,Test-ScriptFunction"

            ## Binary cmdlets are always marked as trusted because only trusted assemblies can be loaded on DeviceGuard machine.
            $result3 = Execute-Script -ps $ps -Script "Test-BinaryCmdlet -File fileToUse"
            $result3 | Should Be "fileToUse"

            ## Conversion that involves setting properties of an instance of the target type is disallowed.
            $hashValue = @{ FileName = "filename"; Arguments = "args" }
            $psobjValue = [PSCustomObject] $hashValue

            ## Test 'Test-ScriptCmdlet -StartInfo' with IDictionary and PSObject with properties
            try {
                Execute-Script -ps $ps -Command "Test-ScriptCmdlet" -ParameterName "StartInfo" -Argument $hashValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingArgumentTransformationException,Execute-Script"
            }

            try {
                Execute-Script -ps $ps -Command "Test-ScriptCmdlet" -ParameterName "StartInfo" -Argument $psobjValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingArgumentTransformationException,Execute-Script"
            }

            ## Test 'Test-ScriptFunction -StartInfo' with IDictionary and PSObject with properties
            try {
                Execute-Script -ps $ps -Command "Test-ScriptFunction" -ParameterName "StartInfo" -Argument $hashValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingArgumentTransformationException,Execute-Script"
            }

            try {
                Execute-Script -ps $ps -Command "Test-ScriptFunction" -ParameterName "StartInfo" -Argument $psobjValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingArgumentTransformationException,Execute-Script"
            }

            ## Test 'Test-BinaryCmdlet -StartInfo' with IDictionary and PSObject with properties
            try {
                Execute-Script -ps $ps -Command "Test-BinaryCmdlet" -ParameterName "StartInfo" -Argument $hashValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingException,Execute-Script"
            }

            try {
                Execute-Script -ps $ps -Command "Test-BinaryCmdlet" -ParameterName "StartInfo" -Argument $psobjValue
                throw "Expected exception was not thrown!"
            } catch {
                $_.FullyQualifiedErrorId | Should Be "ParameterBindingException,Execute-Script"
            }
        }
        finally {
            $ps.Dispose()
        }
    }
}
