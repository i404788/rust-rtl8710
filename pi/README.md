# Building rustl8710 on Raspberry Pi

The `rustl8710` build script includes the Realtek Ameba RTL8710AF SDK, which uses x86 binaries for the build: `pick, pad, chksum`.
To build `rustl8710` on a Raspberry Pi we need to use `qemu-i386` to emulate an x86 environment to run the x86 binaries.

Run the following commands on Raspberry Pi Rasbian:

```bash
sudo apt update
sudo apt install build-essential gawk bc 

# libc6-dev:i386 lib32ncurses5-dev dont exist. Use instead:
sudo apt install libc6-dev libncurses5-dev

sudo apt install gcc-arm-none-eabi
sudo apt install gdb-multiarch
sudo apt install cutecom
sudo apt install openocd

git clone https://github.com/lupyuen/rustl8710

# Install rustup
curl https://sh.rustup.rs -sSf | sh
cd rustl8710
rustup update
rustup override set nightly
rustup component add rust-src
cargo install xargo

# Install qemu-i386 user-mode emulator for running x86 binaries on Pi, e.g. pick, pad, chksum
sudo apt install qemu-user
sudo dpkg --add-architecture armhf
sudo apt-get update
sudo apt-get install libc6:armhf

# Install x86 dynamic libraries, copied from /lib32 on Ubuntu x86.
sudo cp -r pi/qemu-i386 /opt/

```

Edit `application.mk` and add `EMU` so that the x86 binaries are run with `qemu-i386`:

```bash
#### Lup Yuen: Support emulator for Raspberry Pi
EMU = qemu-i386 -L /opt/qemu-i386
...
	#### Lup Yuen: Support Raspberry Pi
	$(EMU) $(PICK) 0x`grep __ram_image2_text_start__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` 0x`grep __ram_image2_text_end__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` $(BIN_DIR)/ram_2.bin $(BIN_DIR)/ram_2.p.bin body+reset_offset+sig
	$(EMU) $(PICK) 0x`grep __ram_image2_text_start__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` 0x`grep __ram_image2_text_end__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` $(BIN_DIR)/ram_2.bin $(BIN_DIR)/ram_2.ns.bin body+reset_offset
	$(EMU) $(PICK) 0x`grep __sdram_data_start__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` 0x`grep __sdram_data_end__ $(BIN_DIR)/$(TARGET).nmap | gawk '{print $$1}'` $(BIN_DIR)/sdram.bin $(BIN_DIR)/ram_3.p.bin body+reset_offset
	$(EMU) $(PAD) 44k 0xFF $(BIN_DIR)/ram_1.p.bin
	cat $(BIN_DIR)/ram_1.p.bin > $(BIN_DIR)/$(RAMALL_BIN)
	chmod 777 $(BIN_DIR)/$(RAMALL_BIN)
	cat $(BIN_DIR)/ram_2.p.bin >> $(BIN_DIR)/$(RAMALL_BIN)
	if [ -s $(BIN_DIR)/sdram.bin ]; then cat $(BIN_DIR)/ram_3.p.bin >> $(BIN_DIR)/$(RAMALL_BIN); fi
	cat $(BIN_DIR)/ram_2.ns.bin > $(BIN_DIR)/$(OTA_BIN)
	chmod 777 $(BIN_DIR)/$(OTA_BIN)
	if [ -s $(BIN_DIR)/sdram.bin ]; then cat $(BIN_DIR)/ram_3.p.bin >> $(BIN_DIR)/$(OTA_BIN); fi
	$(EMU) $(CHKSUM) $(BIN_DIR)/$(OTA_BIN) || true
	rm $(BIN_DIR)/ram_*.p.bin $(BIN_DIR)/ram_*.ns.bin
```

Start the build:

```bash
make
```

If the build fails, run this command and rebuild:

```bash
mkdir ~/.rustup/toolchains/nightly-arm-unknown-linux-gnueabihf/lib/rustlib/arm-unknown-linux-gnueabihf/bin
```

## Visual Studio Code

Unfortunately Visual Studio Code (`code-oss`) doesn't work right now on Raspberry Pi. It terminates with a segmentation fault.
So this prevents me from using the Raspberry Pi as a headless development tool for teaching PADI development.

See https://code.headmelted.com/

## Testing

The Raspbian build was tested on a Raspberry Pi emulated with `qemu`. See `emupi.cmd` for the emulation script.

## References

https://wiki.debian.org/QemuUserEmulation

https://techfindings.one/archives/tag/qemu
