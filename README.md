# rustl8710 - Rust on PADI Realtek RTL8710

Original background and usage instructions at: [https://polyfractal.com/post/rustl8710/](https://polyfractal.com/post/rustl8710/)

## Updates by Lup Yuen

- The rustl8710 code has been updated to use OpenOCD instead of JLink as the JTAG tool for flashing and debugging, because JLink no longer works with the PADI SWD Debugger USB dongle. See https://forum.pine64.org/archive/index.php?thread-4579-2.html

- Replaced `gdb-arm-none-eabi` (obsolete) by `gdb-multiarch`

Tested on:
- Ubuntu 18.04 LTS x86 64-bit on Oracle VirtualBox 5.2.12 (hosted on Windows 10)
- Ubuntu 18.04 LTS x86 64-bit on Cherry Atom notebook PC

## Hardware components

- PADI IoT Stamp with Assembled PADI Breadboard Adapter

    https://www.pine64.org/?product=assembled-padi-breadboard-adapter

- PADI SWD Debugger

    https://www.pine64.org/?product=swd-debugger

- PADI Serial Console

    https://www.pine64.org/?product=padi-serial-console

## Install prerequisites

```
sudo apt update
sudo apt install build-essential gawk bc libc6-dev:i386 lib32ncurses5-dev
sudo apt install gcc-arm-none-eabi
sudo apt install gdb-multiarch
sudo apt install cutecom
sudo apt install openocd
```

## Download rustl8710 code

```
git clone https://github.com/lupyuen/rustl8710
```

## Install Rust components

Install `rustup` from https://rustup.rs/

Then run the following commands:
```
cd rustl8710
rustup update
rustup override set nightly
rustup component add rust-src
cargo install xargo
```

## Select OpenOCD instead of JLink as JTAG tool

```
make setup GDB_SERVER=openocd
```

## Build flash image

```
make
```

## Connect PADI and SWD Debugger to computer

TODO

## Redirect SWD Debugger port from Windows to VirtualBox

TODO

## Start OpenOCD for flashing and debugging

Run this command in a new window before writing the flash image or debugging:
```
debug.sh
```

## Write flash image (using Realtek SDK)

```
make flash
```

## Debug flash code

```
make debug
```

Common GDB commands:
- `step`: Execute the current source line, step into functions if present.
- `next`: Execute the current source line, don't step into functions.
- `where`: Show stack trace.
- `where full`: Show stack trace with local variables.

Summary of GDB commands: https://darkdust.net/files/GDB%20Cheat%20Sheet.pdf

## Run flash code

TODO: Connect PADI and Serial Console to computer

TODO: Run cutecom or putty

## Read flash memory (using rtl8710.ocd)

```
openocd -f interface/jlink.cfg -f rtl8710.ocd \
        -c "init" \
        -c "reset halt" \
        -c "rtl8710_flash_read_id" \
        -c "rtl8710_flash_read dump.bin 0 1048576" \
        -c "shutdown"
```

## Write flash memory image (using rtl8710.ocd)

```
openocd -f interface/jlink.cfg -f rtl8710.ocd \
        -c "init" \
        -c "reset halt" \
        -c "rtl8710_flash_auto_erase 1" \
        -c "rtl8710_flash_auto_verify 1" \
        -c "rtl8710_flash_write dump.bin 0" \
        -c "shutdown"
```

## References

https://polyfractal.com/post/rustl8710/

https://forum.pine64.org/archive/index.php?thread-4579-2.html

https://bitbucket.org/rebane/rtl8710_openocd/src

http://openocd.org/doc-release/html/Debug-Adapter-Configuration.html#SWD-Transport
