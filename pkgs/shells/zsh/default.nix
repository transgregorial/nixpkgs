{ stdenv, fetchurl, ncurses, coreutils }:

let

  version = "5.0.2";

  documentation = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}-doc.tar.bz2";
    sha256 = "99ee08cfc91935af8714bd98db652f016d6c7a8a71ba7c6d6223910cd0b7fbf1";
  };
  
in

stdenv.mkDerivation {
  name = "zsh-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}.tar.bz2";
    sha256 = "eb220ae5a8076191ec6b4c6a5a2f18122d074a19f25b45f0320b44b8166c5a03";
  };
  
  buildInputs = [ ncurses coreutils ];

  preConfigure = ''
    configureFlags="--enable-maildir-support --enable-multibyte --enable-zprofile=$out/etc/zprofile --with-tcsetpgrp"
  '';

  # XXX: think/discuss about this, also with respect to nixos vs nix-on-X
  postInstall = ''
    mkdir -p $out/share/
    tar xf ${documentation} -C $out/share
    mkdir -p $out/etc/
    cat > $out/etc/zprofile <<EOF
if test -e /etc/NIXOS; then
  if test -r /etc/zprofile; then
    . /etc/zprofile
  else
    emulate bash
    alias shopt=false
    . /etc/profile
    unalias shopt
    emulate zsh
  fi
  if test -r /etc/zprofile.local; then
    . /etc/zprofile.local
  fi
else
  # on non-nixos we just source the global /etc/zprofile as if we did
  # not use the configure flag
  if test -r /etc/zprofile; then
    . /etc/zprofile
  fi
fi
EOF
    $out/bin/zsh -c "zcompile $out/etc/zprofile"
    mv $out/etc/zprofile $out/etc/zprofile_zwc_is_used
  '';
  # XXX: patch zsh to take zwc if newer _or equal_

  meta = {
    description = "the Z shell";
    longDescription = "Zsh is a UNIX command interpreter (shell) usable as an interactive login shell and as a shell script command processor.  Of the standard shells, zsh most closely resembles ksh but includes many enhancements.  Zsh has command line editing, builtin spelling correction, programmable command completion, shell functions (with autoloading), a history mechanism, and a host of other features.";
    license = "MIT-like";
    homePage = "http://www.zsh.org/";
    maintainers = with stdenv.lib.maintainers; [ chaoflow ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
