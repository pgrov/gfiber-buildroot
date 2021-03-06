#!/bin/bash
set -x
set -e
TARGET_DIR=$1
TARGET_SKELETON=$2
PLATFORM_PREFIX=$3
PROD=$4
UNSIGNED=$5
BINARIES_DIR=$TARGET_DIR/../images

# Some skeleton files are overwritten by installed packages. Recover them to
# the customized skeleton files.
support/scripts/copy-skeleton.sh "$TARGET_DIR" "$TARGET_SKELETON" "$PLATFORM_PREFIX"

# Strip out some files from the target file system that we shouldn't need.
echo "!!!!!!!!!! Stripping $TARGET_DIR "
support/scripts/strip-skeleton.sh "$TARGET_DIR"
echo "!!!!!!!!!! DONE Stripping $TARGET_DIR "

# Generate /etc/manifest, /etc/version, /etc/softwaredate
rm -f "$TARGET_DIR/etc/manifest"

if support/scripts/is-repo.sh; then
  repo --no-pager manifest -r -o "$TARGET_DIR/etc/manifest"
elif support/scripts/is-git.sh; then
  ( cd .. &&
    echo -n 'commitid ' &&
    git describe --no-abbrev --always
  ) >"$TARGET_DIR/etc/manifest"
else
  echo "ERROR: No version control folder found" >&2
  exit 1;
fi

version=$(support/scripts/version.sh "$TARGET_DIR/..")
echo -n "$PLATFORM_PREFIX$version" >"$TARGET_DIR/etc/version" 2>/dev/null
echo -n "fiberos" >"$TARGET_DIR/etc/os" 2>/dev/null

if [ "$PROD" != "y" ]; then
  echo -n "-$(whoami | cut -c1-2)" >>$TARGET_DIR/etc/version
fi
if [ "$UNSIGNED" == "y" ]; then
  echo -n '-unsigned' >>$TARGET_DIR/etc/version
fi
cp "$TARGET_DIR/etc/version" "$BINARIES_DIR/version"
(d="$(git log --date=iso --pretty=%ad -1)"; date +%s --date="$d"; echo "$d") \
  >$TARGET_DIR/etc/softwaredate

# Installer support for VFAT platforms (and harmless elsewhere)
mkdir -p $TARGET_DIR/install

# SpaceCast production build
if [ "$PLATFORM_PREFIX" = "gfsc100" -a "$PROD" = "y" ]; then
  # Disable root password login.
  sed -i 's/^root:[^:]*:/root:!:/' $TARGET_DIR/etc/passwd
  # Disable serial console.
  sed -i '/rungetty/d' $TARGET_DIR/etc/inittab
  echo "psi1:1:wait:/sbin/prodsysinfo /dev/ttyS0" >>$TARGET_DIR/etc/inittab
fi
