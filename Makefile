
dump-qemu-cmd:
	sudo virsh domxml-to-native qemu-argv --domain win11

dumpxml:
	sudo virsh dumpxml win11 >> ./backup/win11.xml
