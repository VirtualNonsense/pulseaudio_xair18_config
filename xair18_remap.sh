#!/bin/bash
pacmd unload-module module-remap-source
pacmd unload-module module-remap-sink
echo unloaded modules
sleep 2
# 8x8 channel mode
#MULTIOUT=alsa_output.usb-BEHRINGER_X-USB_23C8EABF-00.analog-surround-71
#MULTIIN=alsa_input.usb-BEHRINGER_X-USB_23C8EABF-00.analog-surround-71??
# 16x16 or any combination with more than 8
MULTIOUT=alsa_output.usb-BEHRINGER_X18_XR18_3DD95256-00.multichannel-output
MULTIIN=alsa_input.usb-BEHRINGER_X18_XR18_3DD95256-00.multichannel-input
#FLOW8
# MULTIOUT=alsa_output.usb-Behringer_FLOW_8_04-EE-03-00-37-24-00.analog-surround-40
# MULTIIN=alsa_input.usb-Behringer_FLOW_8_04-EE-03-00-37-24-00.multichannel-input
# 8x8 -> 1:front-left 2:front-right 3:center 4:lfe 5:rear-left 6:rear-right 7:side-left 8:side-right
# 16x16 -> 1:front-left 2:front-right 3:rear-left 4:rear-right 5:center 6:lfe 7:side-left 8:side-right 9:aux0 10:aux1 n:...
# 10x4 -> 1:front-left 2:front-right 3:rear-left 4:rear-right 5:front-center 6:lfe 7:side-left 8:side-right 9:aux0 10:aux1
# -> 1:front-left 2:front-right 3:rear-left 4:rear-right
CH1=front-left
CH2=front-right
CH3=rear-left
CH4=rear-right
CH5=front-center
CH6=lfe
CH7=side-left
CH8=side-right
CH9=aux0
CH10=aux1
CH11=aux2 
CH12=aux3 
CH13=aux4 
CH14=aux5 
CH15=aux6 
CH16=aux7 

# Create virtual inputs from multi-channel sound card
echo INPUTS: Mic1 Mic2
pacmd load-module module-remap-source\
 channels=1 remix=no channel_map=mono\
 source_name=mic1 source_properties=device.description=XAir-In1\
 master=${MULTIIN} master_channel_map=${CH1}

pacmd load-module module-remap-source\
 channels=1 remix=no channel_map=mono\
 source_name=mic2 source_properties=device.description=XAir-In2\
 master=${MULTIIN} master_channel_map=${CH2}

#Create virtual outputs to 'surround 4.0' sound card
echo OUTPUTS: USB1-2 USB3-4
pacmd load-module module-remap-sink\
 channels=2 remix=no channel_map=front-left,front-right\
 sink_name=usb12 sink_properties=device.description=XAir-Out1-2\
 master=${MULTIOUT} master_channel_map=${CH1},${CH2}
 
pacmd load-module module-remap-sink\
 channels=2 remix=no channel_map=front-left,front-right\
 sink_name=usb34 sink_properties=device.description=XAir-Out3-4\
 master=${MULTIOUT} master_channel_map=${CH3},${CH4}
echo "###########sinks#############"
pactl list sinks short
echo "##########sources############"
pactl list sources short
