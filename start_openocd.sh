# Start openocd for flashing and debugging. Use the JLink USB driver.  Init with the rtl8710.ocd script.

openocd -f interface/jlink.cfg \
        -f rtl8710.ocd \
        -c "init" \
        -c "reset"
