# srvant-board

Design of the carrier board for the Raspberry Pi CM4. The main distinction from existing boards is the presence of the 
BMC (Baseboard Management Controller) which supposed to monitor and control the HOST, allowing the board to act as a real "server".

![board-3d.png](media%2Fboard-3d.png)

Highlevel design / idea:
BMC using lots of GPIO controls the HOST: power cycle, terminal access, switches USB into OTG for flushing.
![diagram.png](media%2Fdiagram.png)

* CM4 (HOST) features:
  * 1Gb/s ethernet
  * HDMI
  * 1 USB
  * PCIe exposed as M.2 socket to connect nvme drive
  * TPM2.0 (OPTIGA™ TPM SLB 9670)
  * RTC with battery
* BMC features:
  * Always ON
  * 1Gb/s management port
  * USB port for debug
  * USB connection to the HOST for flushing
  * I2C connection to the HOST for additional metrics
  * TTY connection to HOST for SOL (Serial over LAN)
  * measures Current/Power of the board
  * measures Temperature of the board
  * controls FAN (not available in the PoC)

BMC is based on the Allwinner T113 S3 SoM [link to aliexpress](https://www.aliexpress.com/item/1005005389129193.html).
