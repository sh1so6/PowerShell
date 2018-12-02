#[reflection.assembly]::LoadWithPartialName("System.IO.Directory.EnumerateFiles")
#[reflection.assembly]::LoadWithPartialName("System.IO.Directory.EnumerateDirectories")
Add-Type -AssemblyName System.Windows.Forms
# $EF = New-Object ([System.IO.SearchOption]::AllDirectories)

# 引数値でディレクトリ内検索を行う
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

# 検索結果ビュー作成
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
    $cType.Width = 100
    [System.Windows.Forms.ColumnHeader[]]$c = ($cName,$cType)
    # ヘッダー設定
    $_ListView.Columns.AddRange($c)
    # 並び替えの許可
    $_ListView.AllowColumnReorder = $true   
    # グリッド線の許可
    $_ListView.GridLines = $true

    # Anchor設定
    # $_ListView.Anchor = [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Bottom
    # Dock設定
    $_ListView.Dock = [System.Windows.Forms.DockStyle]::Fill

    return $_ListView
}

# 検索パス入力ボックス作成
function CreatePathBox {
    # [CmdletBinding()]
    param (
        
    )
    begin {
        $ErrorActionPreference = "SilentlyContinue"
    }
    process {
        $_textBox = New-Object System.Windows.Forms.TextBox
        # Dock設定
        $_textBox.Dock = [System.Windows.Forms.DockStyle]::Top

        return $_textBox
    }
    end {
        $ErrorActionPreference = "Stop"
    }
}

# 検索パス入力ボックスラベル作成
function CreatePathLabel {
    # [CmdletBinding()]
    param (

    )
    begin {
        $ErrorActionPreference = "SilentlyContinue"
    }
    process {
        $_label = New-Object System.Windows.Forms.Label
        $_label.Text = "検索対象パス"
        # Dock設定
        $_label.Dock = [System.Windows.Forms.DockStyle]::Top

        return $_label
    }
    end {
        $ErrorActionPreference = "Stop"
    }
}

# 検索ボタン作成
function CreateSearchButton {
    # [CmdletBinding()]
    param (
        
    )
    begin {
        $ErrorActionPreference = "SilentlyContinue"
    }
    process {
        $_button = New-Object System.Windows.Forms.Button
        $_button.Text = "検索"

        # Dock設定
        $_button.Dock = [System.Windows.Forms.DockStyle]::Top

        return $_button
    }
    end {
        $ErrorActionPreference = "Stop"
    }
}

# 追加アイテム作成
function CreateItem {
    # [CmdletBinding()]
    param (
        [string]$path
    )
    begin {
        $ErrorActionPreference = "SilentlyContinue"
    }
    process {
        $_item = New-Object System.Windows.Forms.ListViewItem($path)
        return $_item
    }
    end {
        $ErrorActionPreference = "Stop"
    }
}

# メインウィンドウの作成
function CreateMainWindow {
    $_form = New-Object System.Windows.Forms.Form

    # 検索結果ビュー作成
    $listView = CreateListView
    $_form.Controls.Add($listView)
    # 検索パス入力ボックス追加
    $pathBox = CreatePathBox
    $_form.Controls.Add($pathBox)
    # 検索パス入力ラベル追加
    $pathLabel = CreatePathLabel
    $_form.Controls.Add($pathLabel)
    # 検索ボタン追加
    $searchButton = CreateSearchButton
    $_form.Controls.Add($searchButton)

    return $_form
}

# Main
$form = CreateMainWindow
# 最前面表示
$form.TopMost = $true
$res = $form.ShowDialog()