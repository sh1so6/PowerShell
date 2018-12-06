# Learning to Recursive Process
$palatte = @{
    nine = @{
        kokoiro = $true;
        soraoto = $true;
        harukaze = $true;
    }
    radio = @{
        homeraji = $true;
        radioXmaiden = $true;
    }
    qualia = @{
        otomeXdomain = $true;
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
        foreach($key in $param.keys)
        {
            Write-Output($key)
            Find($param[$key])
        }
    }
    end 
    {

    }
}
Find($palatte)