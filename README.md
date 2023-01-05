My personal overlay for Gentoo Linux. It includes ebuilds for AppImageLauncher and a working driver for my TP-Link Archer T3U Wireless Adapter.


Use Layman to add it to your system:

```
sudo layman -o https://raw.githubusercontent.com/q-g-j/qgj-overlay/master/qgj.xml -f -a qgj
```
<br/>

Not all ebuilds are my own work. Most are taken from other overlays that I did not want to add as a whole. I modified a few of them, e.g.:
- ``games-roguelike/dwarf-fortress`` - fixed an openal related segmentation fault
- ``media-sound/carla`` - enabled Win VST support (needs a mingw cross compiler provided by crossdev)
- ``kde-plasma/discover`` - enabled snap support (depends on app-emulation/snapd-glib; also in my overlay)
- ``net-firewall/parprouted`` - updated the download link and fixed the code to use /bin/ip instead of /sbin/ip
- ``app-emulation/vendor-reset`` - get the kernel version from the sources symlinked to "/usr/src/linux" instead of the running kernel

My own ebuilds so far are:
- ``app-misc/appimagelauncher-bin``
- ``net-wireless/rtl88x2bu``
