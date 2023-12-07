#!/usr/bin/env bash
#
# @file User
# @brief User customizations and AUR package installation.

echo "
====================================================================
   █████╗ ██████╗  ██████╗██╗  ██╗██╗      █████╗ ██████╗ ███████╗
  ██╔══██╗██╔══██╗██╔════╝██║  ██║██║     ██╔══██╗██╔══██╗██╔════╝
  ███████║██████╔╝██║     ███████║██║     ███████║██████╔╝███████╗
  ██╔══██║██╔══██╗██║     ██╔══██║██║     ██╔══██║██╔══██╗╚════██║
  ██║  ██║██║  ██║╚██████╗██║  ██║███████╗██║  ██║██████╔╝███████║
  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝
====================================================================
                   Automated Arch Linux Installer
====================================================================
"
source "${HOME}/ArchLAbS/configs/setup.conf"

uppercase_desktopenv=$(printf "%s" "${DESKTOP_ENV}" | tr '[:lower:]' '[:upper:]')
echo "[*] Installing ${uppercase_desktopenv} Desktop Environment..."
cd ~ || exit 1

sed -n '/'${INSTALL_TYPE}'/q;p' ~/ArchLAbS/pkg-files/"${DESKTOP_ENV}".txt | while read line; do
	if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]; then
		# If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
		continue
	fi
	echo "INSTALLING: ${line}"
	sudo pacman -S --noconfirm --needed "${line}"
done

if [[ ${AUR_HELPER} != none ]]; then
	echo "[*] Installing AUR Helper..."
	(
		cd ~ || exit 1
		git clone "https://aur.archlinux.org/${AUR_HELPER}.git"
		cd ~/"${AUR_HELPER}" || exit 1
		makepkg -si --noconfirm --needed
	)
	case ${AUR_HELPER} in
	"yay" | "yay-bin")
		aur_command="yay"
		;;
	"paru" | "paru-bin")
		aur_command="paru"
		;;
	"trizen")
		aur_command="trizen"
		;;
	"pikaur")
		aur_command="pikaur"
		;;
	"aurman")
		aur_command="aurman"
		;;
	"pacaur")
		aur_command="pacaur"
		;;
	"pakku")
		aur_command="pakku"
		;;
	*) ;;
	esac

	echo "[*] Installing AUR packages..."
	# sed $INSTALL_TYPE is using install type to check for MINIMAL installation, if it's true, stop
	# stop the script and move on, not installing any more packages below that line
	sed -n '/'${INSTALL_TYPE}'/q;p' ~/ArchLAbS/pkg-files/aur-pkgs.txt | while read line; do
		if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]; then
			# If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
			continue
		fi
		echo "INSTALLING: ${line}"
		"${aur_command}" -S --noconfirm --needed "${line}"
	done
fi

echo "
====================================================================
                  SYSTEM READY FOR 3-post-setup.sh
====================================================================
"
clear
exit
