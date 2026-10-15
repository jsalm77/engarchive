$root = $PSScriptRoot
$prefix = "http://localhost:8123/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Host "Serving $root at $prefix (Press Ctrl+C to stop)"
Start-Process "$prefix"  # opens student page
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $path = $ctx.Request.Url.LocalPath.TrimStart('/')
  if ([string]::IsNullOrWhiteSpace($path)) { $path = 'index.html' }
  $file = Join-Path $root $path
  if (Test-Path $file -PathType Leaf) {
    $bytes = [IO.File]::ReadAllBytes($file)
    $ctx.Response.OutputStream.Write($bytes,0,$bytes.Length)
  } else {
    $ctx.Response.StatusCode = 404
  }
  $ctx.Response.Close()
}