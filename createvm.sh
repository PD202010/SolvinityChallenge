#!/bin/bash
export script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


#
# Pas de onderstaande variabelen aan op de omgeving
#
export sol_network='en0'
export sol_networktype='bridged'
export sol_vm_vcpus='1'
export sol_vm_memory='1024'
export sol_vm_disksize='8000'

export sol_vmname=$1
export sol_desc=$2
export sol_basepath=~/VirtualBox\ VMs
export sol_kickstartimage=$script_dir/kickstart_USB.vdi
export sol_isoimage=~/Downloads/CentOS-8.2.2004-x86_64-minimal.iso

echo '*** Create VM ***'
VBoxManage createvm --name "$sol_vmname" --ostype RedHat_64 --basefolder "$sol_basepath" --register
VBoxManage modifyvm        "$sol_vmname" --description "$sol_desc" --memory $sol_vm_memory --vram 20 --cpus $sol_vm_vcpus --cpuhotplug off --boot1 disk --boot2 dvd --boot3 none --boot4 none --graphicscontroller vmsvga
VBoxManage modifyvm        "$sol_vmname" --nic1 $sol_networktype  --nictype1 82540EM --cableconnected1 on --bridgeadapter1 $sol_network 
VBoxManage storagectl      "$sol_vmname" --name SATA --add sata --controller IntelAhci --bootable on --portcount 2 
VBoxManage storagectl      "$sol_vmname" --name USB  --add usb  --controller USB       --bootable on --portcount 8 
VBoxManage modifyvm        "$sol_vmname" --usb on

echo '*** Create HDD ***'
VBoxManage createmedium disk --filename "$sol_basepath/$sol_vmname/$1_DISK.vdi" --size $sol_vm_disksize --format VDI

echo '*** Attach storage ***'
VBoxManage storageattach   "$sol_vmname" --storagectl SATA --type hdd      --port 0 --medium "$sol_basepath/$1/$1_DISK.vdi" --mtype normal --nonrotational on
VBoxManage storageattach   "$sol_vmname" --storagectl SATA --type dvddrive --port 1 --medium "$sol_isoimage"
VBoxManage storageattach   "$sol_vmname" --storagectl USB  --type hdd      --port 0 --medium "$sol_kickstartimage" --mtype immutable

VBoxManage startvm "$sol_vmname"
