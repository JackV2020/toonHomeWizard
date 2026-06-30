### Toon HomeWizard APP

Monitor and control up to 8 HomeWizard Energy Sockets from your Toon 1 / 2, optionally show HomeWizard P1 Meter data like kWh usage and kWh production and optionally show data for up to 4 HomeWizard Batteries.

When you click on the app tile on your Toon and you have no device configured yet, you get an information screen explaining how to use the app. See first screenshot below.

When you click the blue button you go to the Toon app screen with 8 icons for 8 Energy Sockets and 1 for a  P1 Meter you can add. See screenshot 2 below.

For each HomeWizard Socket and P1 Meter you want in this app:
<br>&nbsp;&nbsp;&nbsp;&nbsp;(Note Batteries are added in a different way, see further below)

    - start the offical HomeWizard app on your phone/tablet
    - click ⚙️ in the top right corner to see a menu
    - select "Aparaten" 
    - select your Energy Socket or P1 Meter
    - enable "Lokale API"
    - and find the IP address like 192.168.4.123 just below "Lokale API"

On the Toon app screen you click a setup button on the left to enter the IP address for each of your HomeWizard devices.
<br>Note that the optional P1 Meter module is at the bottom.

During entering a valid IP address you will be able to modify the default name of the device which appears and more.
See screenshot 3.
<br>When you edit a saved device you will also see a delete button.

There is a setup button <img src='./drawables/settings.png' width="20" height="20"> at the bottom right to access a screen with some app settings.
<br>When you have a P1 Meter Active, you have an extra option to activate Batteries functionality (Batterijen Y/N). See screenshot 4.
<br>The available options for Tile Data depend on what you have activated.

Screenshot 5 shows the app screen with 6 Energy Sockets, the P1 Meter.
The Screen Switch for "Fietsen" is blue because it is disabled in its settings. 
<br>Note Extra button on top left of the screen to select the Batteries screen. 

When you click the button for the Batteries and have no Batteries configured yet you will see an information screen explaining how to use this part of the app.
Screenshot 6 looks like screenshot 1 but contains batteries related information.

When you click the blue button you get the Toon app screen with 4 icons for 4 batteries. See screenshot 7 below.
<br>The Summary row on top shows averages and totals for the batteries you configured.

In short to add a battery:

    - on you physical battery you find a round button just above the led strip, check that
    - find the Battery IP address like 192.168.2.123 in the app on your phone
    - on your phone you make sure that the switch Koppelingsknop is off, so to the left and not green
    - put the IP address in a Battery setup and give it a name like you did for an Enegery Socket
        (see screenshot 8)
    - click the "Save" button and wait for the button to turn yellow and change to "Log In"
    - click that "Log In" button and after 5 seconds touch the button on the physical battery
    - when you did things right the battery may still be red for a while because there is no data yet
    - it should be fine in a minute
  
During the "Log In" phase a login is created in the battery to enable the app to collect data.
<br>When you edit a saved device you will also see a delete button.
When you later decide to delete the Battery and the physical battery is still online the login will be removed from the physical battery.
When you delete the Battery while it is offline the login remains in the battery and will be replaced when you add it to the Toon app again.
<br>Note that every Toon has a unique hardware specific address and that is used in the login name so you can add 1 battery to more that 1 Toon.

Screenshot 9 shows an overview with 2 Batteries

Screenshot 10 is an example of what the tile looks like when you choose "1 Socket : 1 Segment" and switches 1,3,5 and 7 are on. The Watts in the center are as measured by the P1 Meter. A positive number means you use energy, a negative number means energy is leaving your house. Just below that you see Battery data, average state of charge level and the active total Watts in/out.

### Install the app 

This app is available in the Toon Store but when you want to do it manually :

    - on Toon create a folder /qmf/qml/apps/toonHomeWizard
    - put at least the qml files and the drawables folder in the toonHomeWizard folder
    - best to prepare for future updates via the Toon Store and also copy version.txt
    - restart the GUI / reboot your Toon
    - add a tile for "HomeWizard" ( green slider switch )
    - for updates you copy the files again or start using the Toon Store
      (to switch from manual to Toon Store you can use the Toon Store to uninstall and install again)

Thanks for reading and enjoy the HomeWizard app.

<table border = 1 bordercolor ="red" align = center>
<tr>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_1.png">
</td>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_2.png">
</td>
</tr>
<tr>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_3.png">
</td>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_4.png">
</td>
</tr>
<tr>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_5.png">
</td>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_6.png">
</td>
</tr>
</tr>
<tr>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_7.png">
</td>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_8.png">
</td>
<tr>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_9.png">
</td>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_10.png">
</td>
</tr>
</table>
