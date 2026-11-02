# profiledef.sh — Albanix OS archiso profile definition
# Runs on the HOST (build machine) when mkarchiso processes this profile.
#
# archiso reads this file to learn the ISO label, publisher, application,
# version, architecture and the pacman.conf to use for building the live root.

profile_name="albanix"
iso_label="ALBANIX_OS_$(date +%Y%m%d)"
iso_publisher="Albanix OS <https://github.com/arda/albanix-os>"
iso_application="Albanix OS live / installation medium"
iso_version="$(date +%Y.%m.%d)"
buildmodes=('iso')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_compression="zstd"

# File permissions applied inside the airootfs (owner:group:mode).
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:000"
  ["/root"]="0:0:750"
  ["/etc/sddm.conf.d/albanix.conf"]="0:0:644"
  ["/etc/albanix-theme"]="0:0:755"
)