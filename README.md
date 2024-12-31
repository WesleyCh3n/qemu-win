# QEMU/KVM Windows 11 with HyperV

## Prerequisites

- [Win11 ISO](https://www.microsoft.com/zh-tw/software-download/windows11)
- [Virtio Win ISO](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/): `virtio-stable` > `virtio-win-x.x.xxx.iso`

## Installation

```sh
./install.sh
```

> First time need to press any key in the monitor quickly so that it will boot on CDROM.
> I use [Remmina](https://remmina.org/) for the connection.

If after short Installation, the VM stop running, edit vm xml by

```sh
sudo virsh edit win11
```

Find `<os>` tag then remove
```html
<boot dev='cdrom'/>
<boot dev='hd'/>
```

Find the system `qcow2` and `win11.iso` part under `<device>`, add the boot order.

```html
<disk type='file' device='disk'>
  <driver name='qemu' type='qcow2' cache='none' discard='unmap'/>
  <source file='/path/to/win11.qcow2'/>
  <target dev='vda' bus='virtio'/>
  <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
  <boot order='2'/>   <!-- Add this Line -->
</disk>
.....
<disk type='file' device='cdrom'>
  <driver name='qemu' type='raw'/>
  <source file='/path/to/Win11_24H2_English_x64.iso'/>
  <target dev='sda' bus='sata'/>
  <readonly/>
  <boot order='1'/>   <!-- Add this Line -->
  <address type='drive' controller='0' bus='0' target='0' unit='0'/>
</disk>
```

Save the file, then
```sh
sudo virsh start win11
```

## During Installation

- In Disk selection page, there should appear nothing.
    1. Press `Load Driver`, Find the `E: virtio-win.iso` > `viostor` > `win11` > `amd64`
    2. Click OK. Install the driver
- Then, install network driver
    1. Press `Load Driver`, Find the `E: virtio-win.iso` > `NetKVM` > `win11` > `amd64`
    2. Click OK. Install the driver
- Continue the Installation
- Use `Shift + F10` spawn CMD and type `oobe\bypassnro` when starting to select region.
- Also, disable network by also use `Shift + F10` spawn CMD and type `ipconfig /release` to ensure no login process.
- when boot into desktop, install `virtio-win-guest-tools.exe` in `virtio-win` CD Drive.
- Power off. Remove two CD Drive by edit xml

```sh
sudo virsh edit win11
```

Then, remove `<disk>` part of `win11 iso` and `virtio iso`

## Performance

- Disable SysMain
```ps1
net stop SysMain
sc config "SysMain" start= disabled
```

- Adjust Visual Effects
    - Search `Adjust the appearance and performance`
    - Choose `Adjust for best performance` > `Apply`

## Reference
- https://sysguides.com/install-a-windows-11-virtual-machine-on-kvm
- https://manuelcortez.net/2023/12/creating-vm-windows11-libvirt/
