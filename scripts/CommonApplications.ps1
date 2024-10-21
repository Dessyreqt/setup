choco install -y 7zip.install
choco install -y agentransack
choco install -y bulkrenameutility.install
choco install -y chocolateygui
choco install -y dotnetcore-runtime.install
choco install -y dotnet-runtime
choco install -y dotnetfx
choco install -y dropbox
choco install -y firefox
# remove firefox's entry in chocolatey as it autoupdates
choco uninstall -n -x firefox
choco install -y googlechrome
# remove googlechrome's entry in chocolatey as it autoupdates
choco uninstall -n -x googlechrome
choco install -y keepassxc
choco install -y mremoteng
choco install -y notepadplusplus
choco install -y patchcleaner
choco install -y sysinternals
choco install -y treesizefree
