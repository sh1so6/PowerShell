<# 参考リンク
    http://nonsubject.arinco.org/p/shell-objects.html
    https://www.pg-fl.jp/program/winreg/classes.htm
    http://piyopiyocs.blog115.fc2.com/blog-entry-773.html
#>
$Script:Keys = @{root = "HKCU"
                 DirBK = "Directory\Background\shell";
                 Dir = "Directory\shell";
                 Object = "AllFilesystemObjects\shell";
                 }
$Script:DEF = @{menuName = "hoodoo"

               }
Function Main()
{
    Begin
    {
        if (!(Get-PSDrive HKCC -ErrorAction SilentlyContinue))
        {
            New-PSDrive -Name HKCC -PSProvider Registry -Root HKEY_CURRENT_CONFIG
            New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
            New-PSDrive -Name HKU  -PSProvider Registry -Root HKEY_USERS
            New-PSDrive -Name HKCU -PSProvider Registry -Root HKEY_CURRENT_USER
        }
    }
    Process
    {
        $str = "HKCU:\SOFTWARE\Classes\AllFilesystemObjects"
        if (!(Test-Path $str -ErrorAction SilentlyContinue))
        {
            MakeRecursiveRegistry($str)
        }
        #New-ItemProperty -Path ($Keys.root + ":\" + $Keys.DirBK) -Name $DEF.menuName -WhatIf
    }
    End
    {
        Remove-PSDrive HKCC
        Remove-PSDrive HKCR
        Remove-PSDrive HKU
        Remove-PSDrive HKCU
    }
}
Function MakeRecursiveRegistry([string]$target)
{
    $array = $target -split "\\"
    [string]$regPath = ""
    foreach($str in $array)
    {
        $regPath += $str + "\"
        if (!(Get-Item $regPath -ErrorAction SilentlyContinue))
        {
            New-Item -Path $regPath -WhatIf
        }
    }
}
Main