# Dans_Jail
Jail System for RedEM:RP <br>
Using policejob to jail. <br>

# Installation
Insert dans_jail.sql into your database. <br>
Add ```ensure dans_jail``` to your server.cfg <br>
Follow below steps for correct usage! <br>

# Using this script
Currently the function to open the jail menu is - jailMenu() <br>

To use the menu you will need to plug it into an existing menu. I have converted my policejob to use menu_base, but I am sure the premise is the same for warmenu. <br>
Example: <br>
```
This would be located in your client.lua of policejob, in the F4 Menu for player interaction

elseif(data.current.value == 'jail') then
 exports['dans_jail']:jailMenu()
 menu.close()
end
```
There is a test keybind that can be used to open the jailMenu without plugging it into anything. <br>
To enable it, go to dans_fines -> client.lua, and from line 11 to 18, uncomment those lines. <br>
The keybind is Left Arrow to open jailMenu() <br>


To utilise the deathJail() function, navigate to your redemrp_respawn -> cl_main.lua, and line 191 should contain SavePosition() in the Callback 'select' <br>
Create a new line underneath it and add the following piece of code. <br>
```
exports['dans_jail']:deathJail()
```
And that should be all you need! <br>

# Required Resources
RedEM:RP is required <br>
Forum Post -> https://forum.cfx.re/t/redem-roleplay-gamemode-the-roleplay-gamemode-for-redm/915043 <br>
Github -> https://github.com/RedEM-RP/redem_roleplay <br>

RedEM:RP Police Job is required <br>
Github -> https://github.com/CryptoGenics/redemrp_policejob <br>

# Known Bugs
No known bugs at this point in time. <br>

# Credits
Thank you to RedEM and RedEM:RP <br>
RedEM:RP Discord -> https://discord.gg/JS82WmQ7nG <br>
<br>
Thank you to CryptoGenics for the policejob script <br>
CryptoGenics Github -> https://github.com/CryptoGenics <br>
