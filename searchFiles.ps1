#[reflection.assembly]::LoadWithPartialName("System.IO.Directory.EnumerateFiles")
#[reflection.assembly]::LoadWithPartialName("System.IO.Directory.EnumerateDirectories")
Add-Type -AssemblyName System.Windows.Forms
# $EF = New-Object ([System.IO.SearchOption]::AllDirectories)

function SearchDirectories {
    #[CmdletBinding()]
    param (
        
    )
    begin {
        $ErrorActionPreference = "SilentlyContinue"
    }
    process {
        $terms = @{
            path    = "D:\";
            pattern = "*"; #正規表現はサポート外。ワイルドカード
            option  = @{
                recurse = [System.IO.SearchOption]::AllDirectories;
                topOnly = [System.IO.SearchOption]::TopDirectoryOnly;
            }
        }
        $result = [System.IO.Directory]::EnumerateDirectories($terms.path, $terms.pattern, $terms.option.recurse)   
        foreach ($str in $result) {
            $fRes = [System.IO.Directory]::EnumerateFiles($str, $terms.pattern, $terms.option.topOnly)
            foreach ($re in $fRes) {
                Write-Output $re
            }
        }
    }
    end {
        $ErrorActionPreference = "Stop"
    }
}
function CreateListView {
    $_ListView = New-Object System.Windows.Forms.ListView
    # スタイル設定
    $_ListView.View = [System.Windows.Forms.View]::Details
    # ヘッダー生成
    $cName = New-Object System.Windows.Forms.ColumnHeader
    $cName.Text = "名前"
    $cName.Width = 500
    $cType = New-Object System.Windows.Forms.ColumnHeader
    $cType.Text = "ファイル/フォルダ"
    $cName.Width = 100
    [System.Windows.Forms.ColumnHeader[]]$c = $cName,$cType
    # ヘッダー設定
    $_ListView.Columns.AddRange($c)
    # 並び替えの許可
    $_ListView.AllowColumnReorder = $true   
    # グリッド線の許可
    $_ListView.GridLines = $true


    return $_ListView
}

$form = New-Object System.Windows.Forms.Form
$listView = CreateListView
$listView.Items.Add("aaa")
$form.Controls.Add($listView)
# 最前面表示
$form.TopMost = $true
$res = $form.ShowDialog()