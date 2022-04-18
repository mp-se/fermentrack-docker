#!/usr/bin/env python
#
# This script is adapted from https://github.com/LinuxChristian/tilt2mqtt
#
# Use this to install an environment for this script
#
# pip install requests PyBluez beacontools beaconscanner
# python tiltview.py
#

import time
import os
from beacontools import BeaconScanner, IBeaconFilter, parse_packet, const
import requests

# Unique bluetooth IDs for Tilt sensors
TILTS = {
        'a495bb10c5b14b44b5121370f02d74de': 'Red   ',
        'a495bb20c5b14b44b5121370f02d74de': 'Green ',
        'a495bb30c5b14b44b5121370f02d74de': 'Black ',
        'a495bb40c5b14b44b5121370f02d74de': 'Purple',
        'a495bb50c5b14b44b5121370f02d74de': 'Orange',
        'a495bb60c5b14b44b5121370f02d74de': 'Blue  ',
        'a495bb70c5b14b44b5121370f02d74de': 'Yellow',
        'a495bb80c5b14b44b5121370f02d74de': 'Pink  ',
}

def callback(bt_addr, rssi, packet, additional_info):
    #print(additional_info)
    msgs = []
    color = "unknown"

    try:
        uuid = additional_info["uuid"]
        color = TILTS[uuid.replace('-','')]
    except KeyError:
        print("Unable to decode tilt color. Additional info was {}".format(additional_info))

    try:
        # Get and convert temperature
        temperature_farenheit = float(additional_info["major"])
        temperature_celsius = (temperature_farenheit - 32) * 5/9

        # Get and convert gravity
        specific_gravity = float(additional_info["minor"])/1000
        degree_plato = 135.997*pow(specific_gravity, 3) - 630.272*pow(specific_gravity, 2) + 1111.14*specific_gravity - 616.868
        
        print( "Tilt data: {} {:.3f} {:.2f}C {:.1f}F".format(color, specific_gravity, temperature_celsius, temperature_farenheit) )
    except KeyError:
        print("Device does not look like a Tilt Hydrometer.")

scanner = BeaconScanner(callback)
scanner.start()
monitor = scanner._mon
while(1):
    time.sleep(10)
