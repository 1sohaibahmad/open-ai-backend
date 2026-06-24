$scriptPath = Join-Path (Get-Location) "src/server.js"
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "node.exe"
$psi.Arguments = $scriptPath
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$p = [System.Diagnostics.Process]::Start($psi)
Start-Sleep -Seconds 4

$body = @{prompt="test prompt"} | ConvertTo-Json
try {
    $r = Invoke-WebRequest -Uri "http://localhost:4000/generate" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing -TimeoutSec 60
    Write-Host "Status: $($r.StatusCode)"
    Write-Host "Response: $($r.Content)"
} catch {
    Write-Host "Request Error: $($_.Exception.Message)"
}

# Capture stderr from the server process
$stderr = $p.StandardError.ReadToEnd()
if ($stderr) { Write-Host "Server stderr: $stderr" }

$p.Kill()
