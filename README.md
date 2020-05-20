# hammerspoon-init
my configuration of hammerspoon

## steps to configure it on your mac

1. install Hammerspoon <http://www.hammerspoon.org/>
2. clone this repo to your mac: `git clone git@github.com:zelig81/hammerspoon-init.git`
3. create a symbolic link of **.hammerspoon** folder to your home folder: `ln -s -f <folder_of_code>/hammerspoon-init/.hammerspoon ~/.hammerspoon`
4. press 'reload config' in Hammerspoon

## features

for hotkeys bindings [see in key-binding.lua](./.hammerspoon/key-binding.lua)
meta keys binding [see in init.lua](./.hammerspoon/init.lua)

- switching applications using specific hotkey for each application (meta key + `<letter of application>`)
- windows management (half window, maximized window, moving window between displays)
- switching language layouts (meta key + id number of language layout)
- reload hammerspoon config (meta key + 'h')

## further configuration

- if you prefer to change something / add something - [see hammerspoon reference](https://www.hammerspoon.org/docs/)
