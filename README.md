# rustl8710 - Rust on PADI Realtek RTL8710

Original background and usage instructions at [https://polyfractal.com/post/rustl8710/](https://polyfractal.com/post/rustl8710/)

## rustl8710 Updates

- The rustl8710 code here has been updated to use OpenOCD instead of JLink as the JTAG tool for flashing and debugging, because JLink no longer works with the PADI SWD Debugger USB dongle. See https://forum.pine64.org/archive/index.php?thread-4579-2.html

- Replaced `gdb-arm-none-eabi` (obsolete) by `gdb-multiarch`

- Build, flash and debug PADI from Visual Studio Code

Tested on:

- Ubuntu 18.04 LTS x86 64-bit on Oracle VirtualBox 5.2.12 (hosted on Windows 10)

- Ubuntu 18.04 LTS x86 64-bit on Intel Atom x5-Z8300 notebook PC

## Hardware components

- PADI IoT Stamp with Assembled PADI Breadboard Adapter

    https://www.pine64.org/?product=assembled-padi-breadboard-adapter

- PADI SWD Debugger

    https://www.pine64.org/?product=swd-debugger

- PADI Serial Console

    https://www.pine64.org/?product=padi-serial-console

## Install prerequisites

```bash
sudo apt update
sudo apt install build-essential gawk bc libc6-dev:i386 lib32ncurses5-dev
sudo apt install gcc-arm-none-eabi
sudo apt install gdb-multiarch
sudo apt install cutecom
sudo apt install openocd
```

## Download rustl8710 code

```bash
git clone https://github.com/lupyuen/rustl8710
```

## Install Rust components

1. Install `rustup` from https://rustup.rs/

1. Run the following commands:

    ```bash
    cd rustl8710
    rustup update
    rustup override set nightly
    rustup component add rust-src
    cargo install xargo
    ```

## Select OpenOCD instead of JLink as JTAG tool

```bash
make setup GDB_SERVER=openocd
```

## Connect PADI and SWD Debugger to computer

TODO

## Redirect SWD Debugger port from Windows to VirtualBox

TODO

## Flashing and debugging the PADI from the console

### Build flash image from console

```bash
make
```

### Start OpenOCD from console before flashing and debugging

1. Run this command in a new window before writing the flash image or debugging:

    ```bash
    ./start_openocd.sh
    ```

1. Keep it running while flashing or debugging.

### Write flash image from console (using Realtek SDK)

```bash
make flash
```

### Debug flash code from console

```bash
make debug
```

Common GDB commands:

- `step`: Execute the current source line, step into functions if present.

- `next`: Execute the current source line, don't step into functions.

- `where`: Show stack trace.

- `where full`: Show stack trace with local variables.

- More commands: https://darkdust.net/files/GDB%20Cheat%20Sheet.pdf

### Run flash code from console

TODO: Connect PADI and Serial Console to computer

TODO: Run cutecom or putty

```bash
sudo cutecom
```

Device: `/dev/ttyUSB0` or `/dev/ttyUSB1`

## Flashing and debugging the PADI from Visual Studio Code

TODO: Open workspace

1. Click `File → Open Workspace`

1. Select `workspace.code-workspace`

TODO: Install extensions

1. Better TOML (bungcip)<br>
    https://marketplace.visualstudio.com/items?itemName=bungcip.better-toml

1. C/C++ (Microsoft)<br>
    https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools

1. GitLens - Git supercharged (Eric Amodio)<br>
    https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens

1. markdownlint (David Anson)<br>
    https://marketplace.visualstudio.com/items?itemName=davidanson.vscode-markdownlint

1. Native Debug (WebFreak)<br>
    https://marketplace.visualstudio.com/items?itemName=webfreak.debug

1. Rust (kalitaalexey)<br>
    https://marketplace.visualstudio.com/items?itemName=kalitaalexey.vscode-rust

1. Rust (rls) (rust-lang)<br>
    https://marketplace.visualstudio.com/items?itemName=rust-lang.rust

1. Tcl (sleutho)<br>
    https://marketplace.visualstudio.com/items?itemName=sleutho.tcl

### Build flash image in Visual Studio Code

1. Click `Tasks` → `Run Build Task`

1. Check for errors in the `Build PADI Image` terminal window. When       the build is complete, you should see:

    ```text
    ===========================================================
    Image manipulating
    ===========================================================
    ...
    size = 286640
    checksum 1bbbe7d
    ...
    make[1]: Leaving directory '/home/user/rustl8710'
    Terminal will be reused by tasks, press any key to close it.
    ```

### Start OpenOCD in Visual Studio Code before flashing and debugging

1. Before flashing or debugging, start OpenOCD in the background:

    Click `Tasks` → `Run Task` → `Start OpenOCD`

1. Keep it running while flashing or debugging in Visual Studio Code.
    Check for errors in the `Start OpenOCD` terminal window. When OpenOCD has been started, you should see:

    ```
    Open On-Chip Debugger 0.10.0
    ...
    adapter speed: 4000 kHz
    adapter_nsrst_delay: 100
    cortex_m reset_config sysresetreq
    rtl8710_reboot
    Info : No device selected, using first device.
    Info : J-Link ARM-OB STM32 compiled Aug 22 2012 19:52:04
    Info : Hardware version: 7.00
    Info : VTarget = 3.300 V
    Info : clock speed 4000 kHz
    Info : SWD DPIDR 0x2ba01477
    Info : rtl8710.cpu: hardware has 6 breakpoints, 4 watchpoints
    ```

### Write flash image in Visual Studio Code

1. Check that OpenOCD has been started.

1. Click `Tasks` → `Run Task` → `Flash PADI`

1. Check for errors in the `Flash PADI` terminal window.  When the flashing is complete, you should see:

    ```text
    dump for check
    start addr of dumping$327 = 0x98000000
    end addr of dumping$328 = 0x98050fb0
    Breakpoint 3: file rtl_flash_download.c, line 556.
    Breakpoint 3, RtlFlashProgram () at rtl_flash_download.c:556
    556     in rtl_flash_download.c
    make[1]: Leaving directory '/home/user/rustl8710'
    Terminal will be reused by tasks, press any key to close it.
    ```

### Debug flash code in Visual Studio Code

1. Check that OpenOCD has been started.

1. Click `Debug` → `Start Debugging`

1. You may ignore the following messages in the `Start OpenOCD` terminal window:

    ```text
    Info : accepting 'gdb' connection on tcp/3333
    undefined debug reason 7 - target needs reset
    Info : SWD DPIDR 0x2ba01477
    Error: Failed to read memory at 0xfffff000
    ...
    target halted due to debug-request, current mode: Thread
    xPSR: 0x01000000 pc: 0x00000100 msp: 0x1ffffffc
    Warn : Receiving data from device timed out, retrying.
    Info : dropped 'gdb' connection
    ```

### Run flash code in Visual Studio Code

Use the same instructions as _"Run Flash Code From Console"_ above.

## Other commands

### Read flash memory directly (using rtl8710.ocd)

```bash
openocd -f interface/jlink.cfg -f rtl8710.ocd \
        -c "init" \
        -c "reset halt" \
        -c "rtl8710_flash_read_id" \
        -c "rtl8710_flash_read dump.bin 0 1048576" \
        -c "shutdown"
```

### Write flash memory image directly (using rtl8710.ocd)

```bash
openocd -f interface/jlink.cfg -f rtl8710.ocd \
        -c "init" \
        -c "reset halt" \
        -c "rtl8710_flash_auto_erase 1" \
        -c "rtl8710_flash_auto_verify 1" \
        -c "rtl8710_flash_write dump.bin 0" \
        -c "shutdown"
```

## References

Official PADI docs: <br>
https://www.pine64.org/?page_id=946

Original rustl8710 article: <br>
https://polyfractal.com/post/rustl8710/

JLink no longer works with the PADI SWD Debugger USB dongle: <br>
https://forum.pine64.org/archive/index.php?thread-4579-2.html

Alternative OpenOCD config (rtl8710.ocd): <br>
https://bitbucket.org/rebane/rtl8710_openocd/src

Using OpenOCD with SWD Transport: <br>
http://openocd.org/doc-release/html/Debug-Adapter-Configuration.html#SWD-Transport
