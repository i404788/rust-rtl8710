# rustl8710 - Rust on PADI Realtek RTL8710

Original background and usage instructions at [https://polyfractal.com/post/rustl8710/](https://polyfractal.com/post/rustl8710/)

-----
## rustl8710 Updates

Updated article on rustl8710: <br>
https://medium.com/@ly.lee/running-rust-and-freertos-on-the-padi-iot-stamp-fb36c5ef4844

- The rustl8710 code here has been updated to use OpenOCD instead of JLink as the JTAG tool for flashing and debugging, because JLink no longer works with the PADI SWD Debugger USB dongle. See https://forum.pine64.org/archive/index.php?thread-4579-2.html

- Replaced `gdb-arm-none-eabi` (obsolete) by `gdb-multiarch`

- Build, flash and debug PADI from Visual Studio Code

Tested on:

- Ubuntu 18.04 LTS x86 64-bit on Oracle VirtualBox 5.2.12 (hosted on Windows 10)

- Ubuntu 18.04 LTS x86 64-bit on Intel Atom x5-Z8300 notebook PC

-----
## Hardware components

You will need the following development hardware (US$ 14):

- PADI IoT Stamp with Assembled PADI Breadboard Adapter

    https://www.pine64.org/?product=assembled-padi-breadboard-adapter

- PADI SWD Debugger: For flashing and debugging the PADI

    https://www.pine64.org/?product=swd-debugger

- PADI Serial Console:  For interacting with the PADI serial console input / output

    https://www.pine64.org/?product=padi-serial-console

-----
## Install prerequisites

Run the following commands on Ubuntu:

```bash
sudo apt update
sudo apt install build-essential gawk bc libc6-dev:i386 lib32ncurses5-dev
sudo apt install gcc-arm-none-eabi
sudo apt install gdb-multiarch
sudo apt install cutecom
sudo apt install openocd
```

## Download rustl8710 code

Run the following command on Ubuntu:

```bash
git clone https://github.com/lupyuen/rustl8710
```

## Install Rust components

1. On Ubuntu, install `rustup` from https://rustup.rs/

1. Run the following commands on Ubuntu:

    ```bash
    cd rustl8710
    rustup update
    rustup override set nightly
    rustup component add rust-src
    cargo install xargo
    ```

-----
## Select OpenOCD instead of JLink as JTAG tool

Run the following command on Ubuntu:

```bash
make setup GDB_SERVER=openocd
```

-----
## Connect PADI and SWD Debugger to computer

1. Connect the PADI to your computer via the PADI SWD Debugger USB adapter according to <br>
http://files.pine64.org/doc/PADI/documentation/padi-jtag-swd-connections-diagram.pdf


    <table>
        <thead>
            <td>
                PADI IoT Stamp
            </td>
            <td>
                PADI SWD Debugger
            </td>
        </thead>
        <tbody>
            <tr>
                <td> VDD33 [Red] </td>
                <td> VCC (SWD Pin 1) </td>
            </tr>
            <tr>
                <td> GE3 [Green] </td>
                <td> SWDIO (SWD Pin 7) </td>
            </tr>
            <tr>
                <td> GE4 [Blue] </td>
                <td> SWCLK (SWD Pin 9) </td>
            </tr>
            <tr>
                <td> GND [Black] </td>
                <td> GND (SWD Pin 4) </td>
            </tr>
        </tbody>
    </table>

1. Although the document states that an external power supply is needed, from experience
    this is not necessary. The USB port of the computer should provide sufficient power
    to the VDD33 / VCC pins.

## For Windows: Redirect SWD Debugger port from Windows to VirtualBox

1. If you're using VirtualBox on Windows, you should configure VirtualBox to allow the Ubuntu Virtual Machine to access the USB port used by the PADI SWD Debugger. Here's how...

1. In the Virtual Machine window, click `Devices → USB → USB Settings`. Add a USB Device Filter for `SEGGER J-Link [0100]`. This ensures that the SWD Debugger is always accessible to the Ubuntu Virtual Machine whenever the SWD Debugger is connected to the computer.

    ![Add a USB Device Filter](https://raw.githubusercontent.com/lupyuen/rustl8710/master/images/usb1.png)

1. Alternatively, click `Devices → USB → SEGGER J-Link [0100]` so that it shows a tick. This allows the Ubuntu Virtual Machine to access the SWD Debugger temporarily while the SWD Debugger is connected to the computer.

    ![Allow access to USB Device](https://raw.githubusercontent.com/lupyuen/rustl8710/master/images/usb2.png)

-----
## Flashing and debugging the PADI from the console

### Build flash image from console

1. At the Ubuntu console, run:

    ```bash
    make
    ```
1. Check for errors in the build. When the build is complete, you should see:

    ```text
    ===========================================================
    Image manipulating
    ===========================================================
    ...
    size = 286640
    checksum 1bbbe7d
    ...
    make[1]: Leaving directory '/home/user/rustl8710'
    ```

### Start OpenOCD from console before flashing and debugging

1. Run this command in a new Ubuntu window before writing the flash image or debugging:

    ```bash
    ./start_openocd.sh
    ```

1. Keep it running while flashing or debugging. When OpenOCD has been started, you should see:

    ```text
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

### Write flash image from console (using Realtek SDK)

1. At the Ubuntu console, run:

    ```bash
    make flash
    ```

1. Check for errors in the log.  When the flashing is complete, you should see:

    ```text
    dump for check
    start addr of dumping$327 = 0x98000000
    end addr of dumping$328 = 0x98050fb0
    Breakpoint 3: file rtl_flash_download.c, line 556.
    Breakpoint 3, RtlFlashProgram () at rtl_flash_download.c:556
    556     in rtl_flash_download.c
    make[1]: Leaving directory '/home/user/rustl8710'
    ```

### Debug flash code from console

1. At the Ubuntu console, run:

    ```bash
    make debug
    ```

2. Common GDB commands:

    - `step`: Execute the current source line, step into functions if present.
        Same as the `step into` command in Visual Studio Code.

    - `next`: Execute the current source line, don't step into functions.
        Same as the `step over` command in Visual Studio Code.

    - `where`: Show stack trace.

    - `where full`: Show stack trace with local variables.

    - More commands: https://darkdust.net/files/GDB%20Cheat%20Sheet.pdf

3. You may ignore the following messages in the `start_openocd` console:

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

### Run flash code from console

1. Set the Voltage jumper of PADI Serial Console USB adapter to 3V3

1. Connect the PADI to your computer via the PADI Serial Console USB adapter according to Page 2 of <br>
http://files.pine64.org/doc/PADI/quick-start-guide/padi-iot-stamp-qsg.pdf


    <table>
        <thead>
            <td>
                PADI Serial Console
            </td>
            <td>
                PADI IoT Stamp
            </td>
        </thead>
        <tbody>
            <tr>
                <td> GND [Black] </td>
                <td> GND </td>
            </tr>
            <tr>
                <td> 3V3 [Red] </td>
                <td> VDD </td>
            </tr>
            <tr>
                <td> RxD [Brown] </td>
                <td> GA4 (UART2_OUT) </td>
            </tr>
            <tr>
                <td> TxD [White] </td>
                <td> GA0 (UART2_IN) </td>
            </tr>
        </tbody>
    </table>

1. Connect PADI Serial Console to the USB port of your computer to power up the PADI IoT Stamp

1. For Windows: Install and run `putty` from <br>
    https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html <br>
    Look for the COM port of the PADI in Device Manager, descibed in Page 4 of <br>
    http://files.pine64.org/doc/PADI/quick-start-guide/padi-iot-stamp-qsg.pdf <br>
    It should look like `COM4`, `COM5`, ...

1. For Ubuntu: Run

    ```bash
    sudo cutecom
    ```

1. In `putty` or `cutecom`, connect to the Windows COM port or Ubuntu serial port (e.g.         `/dev/ttyUSB0`, `/dev/ttyUSB1`) with these settings:

    - Speed: 38400
    - Data Bits: 8
    - Parity: None
    - Stop Bits: 1

    ![putty configuration](https://raw.githubusercontent.com/lupyuen/rustl8710/master/images/putty1.png)

    ![cutecom configuration](https://raw.githubusercontent.com/lupyuen/rustl8710/master/images/cutecom1.png)

1. You are now connected to the UART Serial Console for the PADI. Press a few keys like `a b c 1 2 3` and you'll see that the PADI responds with:

    ```text
    Received: a
    Received: b
    Received: c
    Received: 1
    Received: 2
    Received: 3
    ```

    ![putty console](https://raw.githubusercontent.com/lupyuen/rustl8710/master/images/putty2.png)

    ![cutecom console](https://raw.githubusercontent.com/lupyuen/rustl8710/master/images/cutecom2.png)

### Inspecting the sample flash code

The sample source code is located here: <br>
https://github.com/lupyuen/rustl8710/blob/master/src/rust/src/lib.rs

```rust
pub extern fn main_entry() {
    let mut s = Serial::new();
    s.tx_string("Hello from Rust!\n");
    loop {
        let data = s.rx_i32();
        s.tx_string("Received: ");
        s.tx_i32(data);
        s.tx_string("\n");
    }
}
```

The Rust program reads one character at a time from the UART Serial Console.
For every character received, the program prints the character preceded by `Received:`.
The message `Hello from Rust!` appears as soon as the PADI powers on. Since the serial console is not connected to `putty` or `cutecom` during power on, we can't see the first message.

-----
## Flashing and debugging the PADI from Visual Studio Code

Open the Visual Studio Code workspace:

1. On Ubuntu, install Video Studio Code from <br>
    https://code.visualstudio.com/download

1. Launch Video Studio Code on Ubuntu with the command:

    ```bash
    code
    ```

1. Click `File → Open Workspace`

1. Browse to the `rustl8710` folder. Select `workspace.code-workspace`

Install the following Visual Studio Code extensions:

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

    ![Visual Studio Code extensions to be installed](https://raw.githubusercontent.com/lupyuen/rustl8710/master/images/vscode2.png)

### Build flash image from Visual Studio Code

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

### Start OpenOCD from Visual Studio Code before flashing and debugging

1. Before flashing or debugging, start OpenOCD in the background:

    Click `Tasks` → `Run Task` → `Start OpenOCD`

1. Keep it running while flashing or debugging in Visual Studio Code.
    Check for errors in the `Start OpenOCD` terminal window. When OpenOCD has been started, you should see:

    ```text
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

### Write flash image from Visual Studio Code

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

### Debug flash code from Visual Studio Code

1. Check that OpenOCD has been started.

1. Click `Debug` → `Start Debugging`

    ![Debugging PADI with Visual Studio Code](https://raw.githubusercontent.com/lupyuen/rustl8710/master/images/vscode1.png)

1. Click the debugger toolbar at top right to debug your Rust program:

    ![Visual Studio Code debugger toolbar](https://raw.githubusercontent.com/lupyuen/rustl8710/master/images/debug.png)

    - Contunue
    - Step Over
    - Step Into
    - Step Out
    - Step Back
    - Reverse
    - Restart
    - Stop

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

### Run flash code from Visual Studio Code

Use the same instructions as _"Run Flash Code From Console"_ above.

-----
## Other commands

The following commands are useful for creating a full flash image backup (e.g. the factory-installed image) and for restoring the image.

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

-----
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

Rust wrapper for FreeRTOS: <br>
https://github.com/hashmismatch/freertos.rs

Xargo cross compiler for Rust: <br>
https://github.com/japaric/xargo

Concurrency and safety in Rust: <br>
https://blog.rust-lang.org/2015/04/10/Fearless-Concurrency.html
