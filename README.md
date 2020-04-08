STEPS TO SETUP Pi

* INITIAL INSTALL 
  * Install Raspbian standard distribution. Current version is Rasbian 10.
  * Go through usual setup steps.
  * Under preferences, change hostname to cams
  * Under preferences, enable ssh
* INSTALL FULL VIM DISTRIBUTION
  * sudo apt update
  * sudo apt install vim
* INSTALL SAMBA/CIFS TOOLS
  * (see https://raspberypi.org/documentation/remote-access/samba.md)
  * sudo apt update
  * sudo apt install samba samba-common-bin smbclient cifs-utils
  * sudo nano /etc/samba/smb.conf
    <update workgroup to RIVERS>
* INSTALL XRDP
  * sudo apt install xrdp
  * sudo reboot
* INSTALL FTP SERVER
  * (see https://raspberrypi.org/documentation/remote-access/ftp.md)
  * sudo apt update
  * sudo apt install pure-ftpd
  * sudo groupadd ftpgroup
  * sudo useradd ftpuser -g ftpgroup -s /sbin/nologin -d /dev/null
  * sudo mkdir /srv/ftp
  * sudo chown -R ftpuser:ftpgroup /srv/ftp
  * sudo pure-pw useradd cam -u ftpuser -g ftpgroup -d /srv/ftp -m
    (password stored in password database)
  * sudo pure-pw mkdb
  * sudo ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/60puredb
  * sudo service pure-ftpd restart
* INSTALL RESOURCE MONITOR
  * (see https://novaspirit.com/2017/02/23/desktop-widget-raspberry-pi-using-conky/)
  * sudo apt update
  * sudo apt-get install conky -y
  * wget -O /home/pi/.conkyrc https://raw.githubusercontent.com/novaspirit/rpi_conky/master/rpi3_conkyrc
  * sudo nano /usr/bin/conky.sh
    #!/bin/sh
    (sleep 4s && conky) &
    exit 0
  * sudo nano /etc/xdg/autostart/conky.desktop
    [Desktop Entry]
    Name=conky
    Type=Application
    Exec=sh /usr/bin/conky.sh
    Terminal=false
    Comment=System monitoring tool
    Categories=Utility;
  * sudo reboot
* RESTORE PREFERENCE FILES
  * Checkout the repository if not already done:
    * mkdir /home/pi/Documents/repos
    * cd /home/pi/Documents/repos
    * git clone https://github.com/eagle79/camscripts.git
    * cd camscripts
  * cp ./pisetup/conf/home/bashrc /home/pi/.bashrc
  * cp ./pisetup/conf/home/gitconfig /home/pi/.gitconfig
  * sudo cp ./pisetup/conf/etc/vim/vimrc /etc/vim/vimrc
  * close and reopen terminal
* ADD SCRIPTS AND AUTOMATION
  * By this point, the camera should be recording files via FTP. A directory
    will be present in the /srv/ftp directory for the camera. Use the name
    of this directory as needed below. If no directory is present, 
    troubleshoot FTP setup.
  * cd /home/pi/Documents/repos/camscripts
  * sudo mkdir /srv/ftp/<CAM_DIR>/scripts
  * sudo cp ./cam2/clean-archive.sh /srv/ftp/<CAM_DIR>/scripts
  * edit /srv/ftp/<CAM_DIR>/scripts/clean-archive.sh as follows:
    * set HOMEDIR to /srv/ftp/<CAM_DIR>
    * set ARCHIVE_DAYS as desired (currently 5)
  * sudo touch /srv/ftp/<CAM_DIR>/scripts/archive_cleanup.log
  * sudo chmod 755 /srv/ftp/<CAM_DIR>/scripts
  * sudo chmod 740 /srv/ftp/<CAM_DIR>/scripts/clean-archive.sh
  * sudo chmod 644 /srv/ftp/<CAM_DIR>/scripts/archive_cleanup.log
  * sudo crontab -e
    add this to the end of the crontab:
    0 2 * * * /srv/ftp/<CAM_DIR>/scripts/clean-archive.sh > /srv/ftp/<CAM_DIR>/scripts/archive_cleanup.log 2>&1
  * cd /home/pi/Documents/repos/camscripts
  * sudo cp ./cam2/camlauncher.desktop /etc/xdg/autostart/
  * edit /etc/xdg/autostart/camlauncher.desktop and replace credentials and
    IP in command URL
  * ln -s /etc/xdg/autostart/camlauncher.desktop /home/pi/Desktop/camlauncher.desktop
  * Open file manager got to preferences, select "Don't ask options on launch
    executable file"
  * sudo reboot
  * Test as needed.

