# Start openocd for flashing and debugging

openocd -f interface/jlink.cfg -f rtl8710.ocd \
        -c "init" \
        -c "reset"

#openocd -f interface/jlink.cfg -f rtl8710.ocd \
#        -c "init" \
#        -c "reset halt" \
#        -c "rtl8710_flash_read_id" \
#        -c "rtl8710_flash_read dump.bin 0 1048576" \
#        -c "shutdown"
