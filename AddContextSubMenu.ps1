<# 参考リンク
    http://nonsubject.arinco.org/p/shell-objects.html
    https://www.pg-fl.jp/program/winreg/classes.htm
    http://piyopiyocs.blog115.fc2.com/blog-entry-773.html
#>
Function Main()
{
    Begin
    {
    <#
        if (!(Get-PSDrive HKCC -ErrorAction SilentlyContinue))
        {
            New-PSDrive -Name HKCC -PSProvider Registry -Root HKEY_CURRENT_CONFIG
            New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
            New-PSDrive -Name HKU  -PSProvider Registry -Root HKEY_USERS
            New-PSDrive -Name HKCU -PSProvider Registry -Root HKEY_CURRENT_USER
        }
    #>
    }
    Process
    {
        [XML]$xml = (Get-Content -Path "D:\Repos\PowerShell\reg.xml" -Encoding UTF8)
        foreach($a in $xml.ROOT)
        {
            Find($a)
        }
    }
    End
    {
    <#
        Remove-PSDrive HKCC
        Remove-PSDrive HKCR
        Remove-PSDrive HKU
        Remove-PSDrive HKCU
    #>
    }
}
function Find
{
    param (
        $param
    )
    
    begin 
    {

    }
    process {
        foreach($key in $param.ChildNodes)
        {
            Write-Output($key.Name)
            Find($key)
        }
    }
    end 
    {

    }
}
Main