#!/bin/sh

# Optware repository: http://ipkg.nslu2-linux.org/feeds/optware/oleg/cross/stable/
# Entware repository: http://wl500g-repo.googlecode.com/svn/ipkg/openwrt/

# Initialize variables
TESTF="optware_test"
STATICF="static-tools.tar"
BASEOPT="base_optware.tar"
IRFAKE="irfake.tar"
WWW="http://playonx.googlecode.com/files"

cleanexit() {
	echo -e "\033[0m"
	exit $$;
}

installpre()	{
	# Kill current processes
	for proce in dropbear transmission-daemon vsftpd
	do
		killall $proce
	done
	
	echo "Downloading standalone wget binary"
	wget "$WWW/wget" -O /tmp/wget
	chmod +x /tmp/wget
	ln -sf /tmp/wget /usr/bin/wget
	
	echo "Deleting previous Optware/Entware installation"
	rm -R "/opt/"*
}

echo
echo -e "\033[1;35mWelcome to PlayOn!X Optware/Entware installer!"
echo

# Remount / filesytem as RW (works only on yaffs2)
mount -o,remount,rw /

# Try to create a test file in /opt
touch "/opt/$TESTF"

# Check if /opt exists
if [ ! -d /opt/ ]
then
	echo "Error: /opt doesn't exist. Make sure it's available in your firmware."
	cleanexit;
fi

# Check if /opt is on RW
if [ ! -e "/opt/$TESTF" ]
then
	echo "Error: /opt is read-only (most likely due to squashfs). Please use overmounting."
	echo -e "First, you have to connect HDD/USB with Linux ext2/3 partition to media player.\n"	
	echo "In case it's mounted as RO, re-mount it as RW (don't forget about it in future)."
	echo -e "Example: \033[01;31mmount -o remount,rw /tmp/usbmounts/sdb2/ \033[1;35m\n"
	
	echo -e "Create /opt directory on Linux ext2/3 partition."
	echo -e "Example: \033[01;31mmkdir /tmp/usbmounts/sdb2/opt/ \033[1;35m\n"
	
	echo "Mount RW ext2/3 partition over RO /opt."
	echo -e "Example: \033[01;31mmount -o bind /tmp/usbmounts/sdb2/opt/ /opt/\033[1;35m\n"
	
	echo "If everything is working properly, you should add mount command into start-up file."
	echo -e "(in PlayOn!X use \033[01;31m/usr/local/etc/myS\033[1;35m, in other firmware use \033[01;31m/usr/local/etc/rcS\033[1;35m instead).\n"
	cleanexit;
fi

echo -e "\033[01;31mWARNING: All contents of /opt directory will be removed!\033[1;35m\n"
echo -e "Enter \033[01;32mo\033[1;35m if you'd like to install Optware (at least 3.3 MB)"
echo -e "Enter \033[01;32me\033[1;35m if you'd like to install Entware (at least 3.8 MB)"
echo -e "Enter \033[01;32mc\033[1;35m if you'd like to continue with installing extra packages"
echo -e "Enter \033[01;32mq\033[1;35m if you'd like to stop installation process"
echo
while true; do
  echo -ne "\033[01;32mPlease make selection: "
  read -p "" sel
  case "$sel" in
    [Oo] )	echo -e "\033[1;30mInstalling Optware.." 
			installpre;
			
			# Using packed base files, because /tmp/package/[ipkg] is sometimes linked to RO /usr/local/bin/Resource/package
			cd /opt/	
			echo "Installing base files"		
			wget "$WWW/$BASEOPT"
			tar xf "$BASEOPT"
			
			/opt/sbin/ldconfig
			/opt/bin/ipkg update
			/opt/bin/ipkg install -force-reinstall uclibc-opt
			/opt/bin/ipkg install -force-reinstall ipkg-opt
			
			echo "Cleanup"
			rm -f "/opt/$BASEOPT"
			
			echo
			echo -e "\033[1;35mWould you like to install basic Optware package set (208 MB)?"
			echo -e "If you enter \033[01;32mY\033[1;35m, following packages will be automatically installed:"
			echo -e "\033[01;32mbash dropbear ffmpeg icecast links2 madplay mc mediatomb nano ntfs-3g psutils samba36 samba36-swat smartmontools transmission unzip vsftpd\033[1;35m"
			echo -e "Enter any other key to skip\n"
			echo -ne "\033[01;32mPlease make selection: "
			read -p "" optset
			case "$optset" in
			[Yy] )	echo -e "\033[1;30mInstalling Optware packages"
					/opt/bin/ipkg install bash dropbear ffmpeg icecast links2 madplay mc mediatomb nano ntfs-3g psutils samba36 samba36-swat smartmontools transmission unzip vsftpd
					break;;
			* ) 	break;;
			esac
			
			break;;
    [Ee] ) 	echo -e "\033[1;30mInstalling Entware.."
			installpre;
			
			for folder in bin etc include lib sbin share tmp usr var
			do
			if [ -d "/opt/$folder" ]
			then
				echo "Warning: Folder /opt/$folder exists!"
			else
				mkdir "/opt/$folder"
			fi
			done
			[ -d /opt/lib/opkg ] || mkdir -p /opt/lib/opkg
			[ -d /opt/var/lock ] || mkdir -p /opt/var/lock
			[ -d /opt/var/log ] || mkdir -p /opt/var/log
			[ -d /opt/var/run ] || mkdir -p /opt/var/run

			echo "Downloading opkg package manager"
			wget http://wl500g-repo.googlecode.com/svn/ipkg/opkg -O /opt/bin/opkg
			chmod +x /opt/bin/opkg
			wget http://wl500g-repo.googlecode.com/files/opkg.conf -O /opt/etc/opkg.conf

			/opt/bin/opkg update
			echo "Installing base files"			
			/opt/bin/opkg install uclibc-opt
			
			echo
			echo -e "\033[1;35mWould you like to install basic Entware package set (42 MB)?"
			echo -e "If you enter \033[01;32mY\033[1;35m, following packages will be automatically installed:"
			echo -e "\033[01;32mbash dropbear ffmpeg icecast madplay mc mediatomb mjpg-streamer movgrab nano psmisc samba36-server smartmontools streamripper transmission-daemon transmission-web tvheadend unzip vsftpd-ext\033[1;35m"
			echo -e "Enter any other key to skip\n"
			echo -ne "\033[01;32mPlease make selection: "
			read -p "" entset
			case "$entset" in
			[Yy] )	echo -e "\033[1;30mInstalling Entware packages"
					/opt/bin/opkg install bash dropbear ffmpeg icecast madplay mc mediatomb mjpg-streamer movgrab nano psmisc samba36-server smartmontools streamripper transmission-daemon transmission-web tvheadend unzip vsftpd-ext
					break;;
			* ) 	break;;
			esac
			
			break;;
    [Cc] ) 	break;;
    [Qq] ) 	cleanexit;;
	* ) 	echo "Invalid option";;
  esac
done

# Install PHP with cURL from Oscar
echo
echo -e "\033[1;35mIt is highly recommended to install PHP with cURL package (by Oscar)."
echo "This action requires 16 MB of space on /opt."
echo
echo -e "Enter \033[01;32my\033[1;35m if you'd like to install PHP with cURL"
echo -e "Enter any other key to skip\n"
while true; do
  echo -ne "\033[01;32mPlease make selection: "
  read -p "" cur
  case "$cur" in
    [Yy] )	echo -e "\033[1;30mInstalling PHP with cURL package.."
			cd /tmp && wget http://oscar-db.googlecode.com/files/phpc_install.sh && sh phpc_install.sh
			break;;
	* ) 	break;;
  esac
done

# Install statically compiled binaries (rtmpdump, msdl, mplayer etc)
echo
echo -e "\033[1;35mYou can install extra binaries (rtmpdump, msdl, mplayer etc)."
echo "This action requires 23 MB of space on /opt."
echo
echo -e "Enter \033[01;32my\033[1;35m if you'd like to install extra binaries"
echo -e "Enter any other key to skip\n"
while true; do
  echo -ne "\033[01;32mPlease make selection: "
  read -p "" ext
  case "$ext" in
    [Yy] )	echo -e "\033[1;30mInstalling statically compiled binaries.."
			cd /opt/
			wget "$WWW/$STATICF"
			echo "Extracting.."
			tar xf "$STATICF"
			echo "Cleanup"
			rm -f "/opt/$STATICF"
			break;;
	* ) 	break;;
  esac
done

# Install irfake
echo
echo -e "\033[1;35mYou can install irfake to use different IR keys (by Sekator)."
echo "This action requires 100 kB of space on /usr/local/etc."
echo
echo -e "Enter \033[01;32my\033[1;35m if you'd like to install irfake"
echo -e "Enter any other key to skip\n"

while true; do
  echo -ne "\033[01;32mPlease make selection: "
  read -p "" irf
  case "$irf" in
    [Yy] )	echo -e "\033[1;30mInstalling irfake.."
			mkdir -p /usr/local/etc/irfake
			cd /usr/local/etc/irfake/
			wget "$WWW/$IRFAKE"
			echo "Extracting.."
			tar xf "$IRFAKE"
			echo "Cleanup"
			rm -f "$IRFAKE"
			break;;
	* ) 	break;;
  esac
done

# Fine-tuning
if [ -z "`grep /opt/ /etc/profile`" ]
then
	echo -e "\033[1;30mUpdating /etc/profile"
	echo -e "\nPATH=$PATH:/opt/bin:/opt/sbin\nexport PATH" >> /etc/profile
fi

cleanexit;