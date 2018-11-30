# ウィンドウを取得
$WindowList = New-Object PSCustomObject
$i = 1
$psArray = [System.Diagnostics.Process]::GetProcesses()  | Sort-Object ProcessName
    foreach ($ps in $psArray){
    # [String]$ps.Handles + " : " + $ps.MainWindowTitle + " : " + $ps.MainWindowHandle
    $WindowList += Add-Member -MemberType NoteProperty -Index $i 
    $i += 1
}


$a = New-Object -com "Shell.Application";
$b = $a.windows()
# | Select-Object Name,HWND,LocationName | Sort-Object Name,HWND;
$b