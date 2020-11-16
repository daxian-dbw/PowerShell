# Current preview release

## [7.2.0-preview.1] - 2020-11-16

### Engine Updates and Fixes

- Change the default fallback encoding for `GetEncoding` in `Start-Transcript` to be `UTF8` without `BOM` (#13732) (Thanks @Gimly!)

### General Cmdlet Updates and Fixes

- Update `pwsh -?` output to match docs (#13748)
- Enable the check on the order of modifiers (#13958) (Thanks @xtqqczze!)
- Fix `NullReferenceException` in `Test-Json` (#12942) (Thanks @iSazonov!)
- Make `Dispose` in `TranscriptionOption` idempotent (#13839) (Thanks @krishnayalavarthi!)
- Add additional PowerShell modules to the tracked modules list (#12183) (Thanks @SydneyhSmith!)
- Relax further `SSL` verification checks for `WSMan` on non-Windows hosts with verification available (#13786) (Thanks @jborean93!)
- Add the `OutputTypeAttribute` to `Get-ExperimentalFeature` (#13738) (Thanks @ThomasNieto!)
- Fix blocking wait when starting file associated with a Windows application (#13750)
- Emit warning if `ConvertTo-Json` exceeds `-Depth` value (#13692)

### Code Cleanup

<details>

<summary>

<p>We thank the following contributors!</p>
<p>@xtqqczze, @mkswd, @ThomasNieto, @PatLeong, @paul-cheung, @georgettica</p>

</summary>

<ul>
<li>Fix RCS1049: Simplify boolean comparison (#13994) (Thanks @xtqqczze!)</li>
<li>Enable nullable: System.Management.Automation.Internal.IValidateSetValuesGenerator (#14018) (Thanks @xtqqczze!)</li>
<li>Enable IDE0062: MakeLocalFunctionStatic (#14044) (Thanks @xtqqczze!)</li>
<li>Enable CA2207: Initialize value type static fields inline (#14068) (Thanks @xtqqczze!)</li>
<li>Enable CA1837: Use 'Environment.ProcessId' (#14063) (Thanks @xtqqczze!)</li>
<li>Remove unnecessary usings part 5 (#14050) (Thanks @xtqqczze!)</li>
<li>Remove unnecessary usings part 6 (#14065) (Thanks @xtqqczze!)</li>
<li>Remove unnecessary usings part7 (#14066) (Thanks @xtqqczze!)</li>
<li>Remove LINQ Count method uses (#13545) (Thanks @xtqqczze!)</li>
<li>Autofix SA1518: The code must not contain extra blank lines at the end of the file (#13574) (Thanks @xtqqczze!)</li>
<li>Enable CA1829: Use Length/Count property instead of Count() (#13925) (Thanks @xtqqczze!)</li>
<li>Enable CA1827: Do not use Count() or LongCount() when Any() can be used (#13923) (Thanks @xtqqczze!)</li>
<li>Fix nullable usage on displayDescriptionData_Wide (#13805) (Thanks @mkswd!)</li>
<li>Fix nullable usage on displayDescriptionData_Table.cs (#13808) (Thanks @mkswd!)</li>
<li>Remove unnecessary usings part 3 (#14021) (Thanks @xtqqczze!)</li>
<li>Remove unnecessary usings part 2 (#14017) (Thanks @xtqqczze!)</li>
<li>Remove unnecessary usings part 1 (#14014) (Thanks @xtqqczze!)</li>
<li>Enable IDE0040: AddAccessibilityModifiers (#13962) (Thanks @xtqqczze!)</li>
<li>Revert changes to ComInterop (#14012) (Thanks @xtqqczze!)</li>
<li>Make applicable private Guid fields readonly (#14000) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 11 (#13966) (Thanks @xtqqczze!)</li>
<li>Fix CA1003: Use generic event handler instances (#13937) (Thanks @xtqqczze!)</li>
<li>Simplify delegate creation (#13578) (Thanks @xtqqczze!)</li>
<li>Fix RCS1033: Remove redundant boolean literal part 1 (#13454) (Thanks @xtqqczze!)</li>
<li>Fix RCS1221: Use pattern matching instead of combination of 'as' operator and null check (#13333) (Thanks @xtqqczze!)</li>
<li>Use <code>is not</code> syntax part 2 (#13338) (Thanks @xtqqczze!)</li>
<li>Replace magic number with constant in PDH (#13536) (Thanks @xtqqczze!)</li>
<li>Fix accessor order (#13538) (Thanks @xtqqczze!)</li>
<li>Enable IDE0054: Use compound assignment (#13546) (Thanks @xtqqczze!)</li>
<li>Fix RCS1098: Constant values should be on right side of comparisons (#13833) (Thanks @xtqqczze!)</li>
<li>Enable CA1068: CancellationToken parameters must come last (#13867) (Thanks @xtqqczze!)</li>
<li>Enable CA10XX rules with suggestion severity (#13870) (Thanks @xtqqczze!)</li>
<li>Enable CA20XX rules with suggestion severity (#13928) (Thanks @xtqqczze!)</li>
<li>Enable IDE0064: MakeStructFieldsWritable (#13945) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 12 (#13967) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 13 (#13968) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 15 (#13970) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 16 (#13971) (Thanks @xtqqczze!)</li>
<li>Enable CA18XX rules with suggestion severity (#13924) (Thanks @xtqqczze!)</li>
<li>Run <code>dotnet-format</code> to improve formatting of source code (#13503) (Thanks @xtqqczze!)</li>
<li>Enable CA1825: Avoid zero-length array allocations (#13961) (Thanks @xtqqczze!)</li>
<li>Mark PowerShellAssemblyLoadContextInitializer with static modifier (#13874) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 14 (#13969) (Thanks @xtqqczze!)</li>
<li>Remove unnecessary using in utils folder (#13863) (Thanks @ThomasNieto!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 1 (#13884) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 8 (#13891) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 4 (#13887) (Thanks @xtqqczze!)</li>
<li>Add IDE analyzer rule IDs to comments (#13960) (Thanks @xtqqczze!)</li>
<li>Fix nullable usage on authenticode (#13804) (Thanks @mkswd!)</li>
<li>Enable CA1830: Prefer strongly-typed Append and Insert method overloads on StringBuilder (#13926) (Thanks @xtqqczze!)</li>
<li>Enforce code style in build (#13957) (Thanks @xtqqczze!)</li>
<li>Use Environment.CurrentManagedThreadId (#13803) (Thanks @PatLeong!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 10 (#13893) (Thanks @xtqqczze!)</li>
<li>Enable CA1836: Prefer IsEmpty over Count when available (#13877) (Thanks @xtqqczze!)</li>
<li>Enable CA1834: Consider using 'StringBuilder.Append(char)' when applicable (#13878) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 2 (#13885) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 5 (#13888) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 9 (#13892) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 6 (#13889) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 3 (#13886) (Thanks @xtqqczze!)</li>
<li>Fix IDE0044: MakeFieldReadonly part 7 (#13890) (Thanks @xtqqczze!)</li>
<li>Enable IDE0048: AddRequiredParentheses (#13896) (Thanks @xtqqczze!)</li>
<li>Enable IDE1005: InvokeDelegateWithConditionalAccess (#13911) (Thanks @xtqqczze!)</li>
<li>Enable IDE0036: OrderModifiers (#13881) (Thanks @xtqqczze!)</li>
<li>Use span-based string.Concat inatead of string.Substring (#13500) (Thanks @xtqqczze!)</li>
<li>Enable CA1050: Declare types in namespaces (#13872) (Thanks @xtqqczze!)</li>
<li>Remove unnecessary using in namespaces folder (#13860) (Thanks @ThomasNieto!)</li>
<li>Remove unnecessary using in security folder (#13861) (Thanks @ThomasNieto!)</li>
<li>Minor fix keyword typo in csharp comment. (#13811) (Thanks @paul-cheung!)</li>
<li>Remove unnessary using (#13814) (Thanks @ThomasNieto!)</li>
<li>Change Nullable usage (#13793) (Thanks @georgettica!)</li>
</ul>

</details>

### Tools

- Enable `CodeQL` Security scanning (#13894)
- Add global `AnalyzerConfig` with default configuration (#13835) (Thanks @xtqqczze!)

### Build and Packaging Improvements

<details>

<summary>

<p>We thank the following contributors!</p>
<p>@anamnavi, @mkswd, @xtqqczze</p>

</summary>

<ul>
<li>Bump Microsoft.NET.Test.Sdk from 16.7.1 to 16.8.0 (#14020)</li>
<li>Bump Microsoft.CodeAnalysis.CSharp from 3.7.0 to 3.8.0 (#14075)</li>
<li>Remove workarounds for .NET 5 RTM builds (#14038)</li>
<li>Migrate 3rd party signing to ESRP (#14010)</li>
<li>Fixes to release pipeline for GA release (#14034)</li>
<li>Don't do a shallow checkout (#13992)</li>
<li>Add validation and dependencies for <code>Ubuntu 20.04</code> distribution to packaging script (#13993) (Thanks @anamnavi!)</li>
<li>Add .NET install workaround for RTM (#13991)</li>
<li>Move to ESRP signing for Windows files (#13988)</li>
<li>Bump <code>Microsoft.PowerShell.Native</code> version from <code>7.1.0-rc.2</code> to <code>7.1.0</code> (#13976)</li>
<li>Update <code>PSReadLine</code> version to <code>2.1.0</code> (#13975)</li>
<li>Bump .NET to version <code>5.0.100-rtm.20526.5</code> (#13920)</li>
<li>Update script to use .NET RTM feeds (#13927)</li>
<li>Add checkout step to release build templates (#13840)</li>
<li>Turn on <code>/features:strict</code> for all projects (#13383) (Thanks @xtqqczze!)</li>
<li>Bump <code>Microsoft.PowerShell.Native</code> to <code>7.1.0-rc.2</code> (#13794)</li>
<li>Move PowerShell build to .NET 5 RC.2 (#13780)</li>
<li>Update <code>PSReadLine</code> version to <code>2.1.0-rc1</code> (#13777)</li>
<li>Bump NJsonSchema from 10.2.1 to 10.2.2 (#13751)</li>
<li>Add flag to make Linux script publish to production repo (#13714)</li>
<li>Bump Markdig.Signed from 0.21.1 to 0.22.0 (#13741)</li>
<li>Bump NJsonSchema from 10.1.26 to 10.2.1 (#13722)</li>
<li>Use new release script for Linux packages (#13705)</li>
</ul>

</details>

### Documentation and Help Content

- Fix links to `LTS` versions for Windows (#14070)
- Fix `crontab` formatting in example doc (#13712) (Thanks @dgoldman-msft!)

[7.2.0-preview.1]: https://github.com/PowerShell/PowerShell/compare/v7.1.0...v7.2.0-preview.1
