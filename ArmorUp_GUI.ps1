
Add-Type -AssemblyName System.Windows.Forms

# Main Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "ArmorUp GUI"
$form.Size = New-Object System.Drawing.Size(420,300)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true

# Title Label
$label = New-Object System.Windows.Forms.Label
$label.Text = "ArmorUp: Windows Security Toolkit"
$label.AutoSize = $true
$label.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
$label.Location = New-Object System.Drawing.Point(60,20)
$form.Controls.Add($label)

# Output Box
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.Size = New-Object System.Drawing.Size(360,100)
$outputBox.Location = New-Object System.Drawing.Point(20,60)
$outputBox.ReadOnly = $true
$outputBox.WordWrap = $false
$outputBox.ScrollBars = 'Both'
$form.Controls.Add($outputBox)

function Run-AndLog {
    param([string]$cmd)
    $outputBox.AppendText("Running: $cmd`r`n")
    try {
        Invoke-Expression $cmd | ForEach-Object { $outputBox.AppendText("$_`r`n") }
    } catch {
        $outputBox.AppendText("Error: $_`r`n")
    }
    $outputBox.AppendText("Done.`r`n`r`n")
}

# Run ArmorUp Button
$runBtn = New-Object System.Windows.Forms.Button
$runBtn.Text = "Run ArmorUp"
$runBtn.Size = New-Object System.Drawing.Size(110,30)
$runBtn.Location = New-Object System.Drawing.Point(20,180)
$runBtn.Add_Click({ Run-AndLog "Start-Process -FilePath 'ArmorUp_v1.2.bat' -Verb RunAs" })
$form.Controls.Add($runBtn)

# Run Check Script Button
$checkBtn = New-Object System.Windows.Forms.Button
$checkBtn.Text = "Verify Settings"
$checkBtn.Size = New-Object System.Drawing.Size(110,30)
$checkBtn.Location = New-Object System.Drawing.Point(150,180)
$checkBtn.Add_Click({ Run-AndLog "powershell -ExecutionPolicy Bypass -File Enhanced_Security_Check_Script.ps1" })
$form.Controls.Add($checkBtn)

# Reboot Button
$rebootBtn = New-Object System.Windows.Forms.Button
$rebootBtn.Text = "Reboot"
$rebootBtn.Size = New-Object System.Drawing.Size(110,30)
$rebootBtn.Location = New-Object System.Drawing.Point(280,180)
$rebootBtn.Add_Click({ Start-Process "cmd.exe" "/c shutdown /r /t 5" -Verb RunAs })
$form.Controls.Add($rebootBtn)

# Show form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
