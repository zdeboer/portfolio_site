param(
  [string]$MysqlRootPassword = $env:MYSQL_ROOT_PASSWORD,
  [string]$DbName = $env:DB_NAME,
  [string]$DbUser = $env:DB_USER,
  [string]$DbPass = $env:DB_PASS,
  [string]$AdminUsername = $env:ADMIN_USERNAME,
  [string]$AdminEmail = $env:ADMIN_EMAIL,
  [string]$AdminPassword = $env:ADMIN_PASSWORD,
  [string]$PmaBlowfishSecret = $env:PMA_BLOWFISH_SECRET
)

if (-not $MysqlRootPassword) { $MysqlRootPassword = 'root' }
if (-not $DbName) { $DbName = 'music' }
if (-not $DbUser) { $DbUser = 'app' }
if (-not $DbPass) { $DbPass = 'app' }
if (-not $AdminUsername) { $AdminUsername = 'admin' }
if (-not $AdminEmail) { $AdminEmail = 'admin@example.com' }
if (-not $AdminPassword) { $AdminPassword = 'admin' }
if (-not $PmaBlowfishSecret) { $PmaBlowfishSecret = '0123456789abcdef0123456789abcdef' }

docker build -t deboer_zack_final_site:latest .

# Remove any prior containers without failing if they don't exist
cmd /c "docker rm -f deboer_zack_coding_assignment14 >nul 2>nul"
cmd /c "docker rm -f portfolio-lamp >nul 2>nul"

docker run -d --name deboer_zack_coding_assignment14 -p 5575:80 `
  -e MYSQL_ROOT_PASSWORD="$MysqlRootPassword" `
  -e DB_NAME="$DbName" `
  -e DB_USER="$DbUser" `
  -e DB_PASS="$DbPass" `
  -e ADMIN_USERNAME="$AdminUsername" `
  -e ADMIN_EMAIL="$AdminEmail" `
  -e ADMIN_PASSWORD="$AdminPassword" `
  -e PMA_BLOWFISH_SECRET="$PmaBlowfishSecret" `
  -v portfolio_db:/var/lib/mysql `
  deboer_zack_final_site:latest