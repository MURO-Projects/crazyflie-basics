# Crazyflie 2.1 [ROS packages] Documentation for MURO LAB

> Author : Sudhanshu Shankar

## Cyclic pursuit paper

The paper can be found here : [Collective circular motion of multi-vehicle systems](https://www.sciencedirect.com/science/article/pii/S0005109808002951)

### Summary : 

The paper presents a distributed controller for unicycle point sized vehicles to come around a circle of a stationary or moving Beacon.

**Key advantages of the controller :**

1. Does not depend on the number of agents
2. Can follow moving beacons
3. Avoids agent collisions who are within the control law


### Crazyflie fundamentals

Every time you power on a crazyflie, it initializes it's state as origin and 0 rad orientation. The world frame is also initialized at that point with x-axis pointing front and z-axis up. 

# Crazyflie setup

### This tutorial is for ubuntu
~~~
sudo apt install git python3-pip libxcb-xinerama0 libxcb-cursor0
~~~
~~~
pip3 install --upgrade pip
~~~

### Next we will install cflib
~~~
cd ~
~~~
~~~
git clone https://github.com/bitcraze/crazyflie-lib-python.git
~~~
~~~
cd crazyflie-lib-python
~~~
~~~
pip install -e .
~~~
### Next we need to give USB permissions

~~~
sudo groupadd plugdev
sudo usermod -a -G plugdev $USER
~~~

Now log out of and log in to your pc again 

~~~
cat <<EOF | sudo tee /etc/udev/rules.d/99-bitcraze.rules > /dev/null
# Crazyradio (normal operation)
SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="7777", MODE="0664", GROUP="plugdev"
# Bootloader
SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0101", MODE="0664", GROUP="plugdev"
# Crazyflie (over USB)
SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0664", GROUP="plugdev"
EOF
~~~

Now open a new terminal and try the command `cfclient`

You should be able to scan and connect to a Crazyflie using USB of Crazyradio

Connecting to a Crazyflie using USB cable

# Connecting to a Crazyflie using USB cable

1. Open a new terminal
2. Run `cfclient`
3. Connect a Crazyflie to the PC usin a USB-Type A cable and turn on the crazyflie
4. Click the "Scan" button
5. You should see the following URL - `usb://0`
6. Click the "Connect button"
7. You should be connected to the crazyflie now and can see the change status and the IMU GUI

# Naming crazyflies befor connecting to the crazyflie using the Crazyradio dongle

1. Open a terminal
2. Run `cfclient`
3. Connect to the crazyflie using the cable as shown in the previous tutorial
4. Go to "Connect" tab
5. Go to "configure 2.X" menu
6. Set the ID as you wish : example URL  `radio://0/80/2M/E7E7E7E710`
7. Hit "Write" option

Done!

# Connecting to the crazyflie using the Crazyradio dongle

1. Plug in the radio in the USB port
2. Open a terminal
3. Run `cfclient`
4. Put in the address you set in the last tutorial in the address text field
5.  Hit connect


# Use crazy-radio with wsl2 tutorial
> Credits : Isaac Lin, MAE, UCSD 


1. Ensure that `usbip` is installed on your Windows host system. If not download and run the installation file on https://github.com/dorssel/usbipd-win/releases/tag/v4.2.0 .
2. Enter the following command on the Windows command prompt:
`usbipd list` In order to find the `busid` of the crazyflie on your Windows host system.
3. Running the Windows command prompt as a administrator (IMPORTANT), bind your crazyflie for sharing using the following command: `usbipd bind --busid <busid>` Replacing `<busid>` with the `busid` of the Crazyflie.
4. On the same shell, enter the command: `usbipd list` to verify that the Crazyflie is now being shared by `usbipd`. If yes, attach the Crazyflie to WSL2 using the command (while simultaneously keeping a WSL2 shell running):
`usbipd attach -b <BUSID> --wsl`
Replacing `<busid>` with the busid of the Crazyflie.
5. Enter the command: `usbipd list` To verify that the crazyflie is attached to the WSL2 subsystem. Run `cfclient` on the WSL2 shell and check if the Crazyflie can be detected.