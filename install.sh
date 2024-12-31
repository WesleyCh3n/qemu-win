rm win11.qcow2
qemu-img create -f qcow2 -o cluster_size=2M win11.qcow2 64G

sudo virt-install --virt-type kvm --name win11 --ram 8192 \
  --disk win11.qcow2,format=qcow2,discard=unmap,cache=none,bus=virtio \
  --disk ./virtio-win-0.1.266.iso,device=cdrom \
  --vcpu 32 \
  --cpu host-passthrough \
  --network network=default,model.type=virtio \
  --graphics spice,listen=0.0.0.0,port=5911,password=2002 \
  --noautoconsole \
  --os-variant=win11 \
  --sound default \
  --tpm model=tpm-crb,backend.version=2.0 \
  --features vmport.state=off \
  --channel type=spicevmc,target.name=com.redhat.spice.0 \
  --channel type=unix,source.mode=bind,target.name=org.qemu.guest_agent.0 \
  --redirdev bus=usb,type=spicevmc \
  --redirdev bus=usb,type=spicevmc \
  --video model.type=qxl \
  --xml 'xpath.delete=./devices/graphics' \
  --xml './devices/graphics/@type=spice' \
  --xml "./devices/graphics/@listen=0.0.0.0" \
  --xml "./devices/graphics/@port=5911" \
  --xml "./devices/graphics/@password=1234" \
  --xml './devices/graphics/@defaultMode=insecure' \
  --xml './devices/graphics/@autoport=no' \
  --xml './features/hyperv/@mode=custom' \
  --xml './features/hyperv/vpindex/@state=on' \
  --xml './features/hyperv/runtime/@state=on' \
  --xml './features/hyperv/synic/@state=on' \
  --xml './features/hyperv/stimer/@state=on' \
  --xml './features/hyperv/stimer/direct/@state=on' \
  --xml './features/hyperv/reset/@state=on' \
  --xml './features/hyperv/vendor_id/@state=on' \
  --xml './features/hyperv/vendor_id/@value=KVM Hv' \
  --xml './features/hyperv/frequencies/@state=on' \
  --xml './features/hyperv/reenlightenment/@state=on' \
  --xml './features/hyperv/tlbflush/@state=on' \
  --xml './features/hyperv/ipi/@state=on' \
  --boot cdrom,hd \
  --cdrom=Win11_24H2_English_x64.iso
  # --dry-run --print-xml
