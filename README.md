# setup
A repository to keep setup scripts and settings

## Links to run the scripts

It appears the links no longer work as a one-click solution. As a workaround do the following:
- Run any link below. This should install Chocolatey. For some reason Boxstarter does not install with this script anymore.
- After the script finishes, open a PowerShell window as Administrator.
- Run the following command to install Boxstarter:
  ```powershell
  choco install boxstarter -y
  ```
- After Boxstarter is installed, run the link again. This should now work as expected.

| Click link to run | Description |
|---------|---------|
| [Basic Client Script](https://boxstarter.org/package/url?https://raw.githubusercontent.com/Dessyreqt/setup/master/BasicClient.ps1) | for a basic client machine |
| [Basic Server Script](https://boxstarter.org/package/url?https://raw.githubusercontent.com/Dessyreqt/setup/master/BasicServer.ps1) | for any server |
| [David's Dev Machine Script](https://boxstarter.org/package/url?https://raw.githubusercontent.com/Dessyreqt/setup/master/David.ps1) | for David's dev machines |
| [David's Non-Dev Machine Script](https://boxstarter.org/package/url?https://raw.githubusercontent.com/Dessyreqt/setup/master/DavidNoDev.ps1) | for David's non-dev machines |
| [No Applications](https://boxstarter.org/package/url?https://raw.githubusercontent.com/Dessyreqt/setup/master/NoApps.ps1) | for troubleshooting if the other scripts hang or fail |

If you need to debloat your Win10 install you may try [This Debloater Script](https://github.com/Sycnex/Windows10Debloater)
## some links
For inspiration

- https://www.ghostinthewires.co.uk/automating-windows-environments-setup-with-boxstarter-and-chocolatey-packages/ - some info about Boxstarter
- https://gist.github.com/jessfraz/7c319b046daa101a4aaef937a20ff41f - a sample Boxstarter script
- https://gist.github.com/NickCraver/7ebf9efbfd0c3eab72e9 - Lots of Windows settings changed here
- https://joshuachini.com/2017/10/27/automated-setup-of-a-windows-environment-using-boxstarter-and-powershell/ - Another Boxstarter example
- https://github.com/microsoft/windows-dev-box-setup-scripts - Microsoft's dev box scripts
- https://github.com/sayedihashimi/sayed-tools - More powershell-focused build scripts, check out machine-setup.ps1 and run-machine-setup.ps1
- https://edi.wang/post/2018/12/21/automate-windows-10-developer-machine-setup - Powershell only, but includes a neat trick to self-elevate the script

## Simple instructions for getting multiple git accounts on one Windows computer

These instructions assume you have a "normal" git account for everyday use, but need to use a second (for contributing to your local github from your work machine or vice versa.) This will assume all of your code is in a "HomeCode" directory.
1. Go to your gitconfig. By default, it should be in `%USERPROFILE%\.gitconfig`
1. Add the following:
    ```
    [includeIf "gitdir:**/HomeCode/**"]
      path = .gitconfig-homecode
    ```
1. Create the new file `.gitconfig-homecode` with the following contents:
    ```
    [user]
      name = Your Name
      email = youremail@domain.tld
    ```
1. Proceed with clone/checkout/commit in the HomeCode directory. At some point you should be asked for your password, which once provided should apply to any future changes made to that directory.
