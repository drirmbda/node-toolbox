# Common prefixes for installation directories.
# See: https://www.gnu.org/software/make/manual/make.html
prefix = /usr/local
exec_prefix = $(prefix)
sbindir = $(exec_prefix)/sbin
libdir = $(exec_prefix)/lib
# Should generally be /usr/local/etc but systemd only reads from /etc
sysconfdir=/etc

snnm:
	exit;

install:
	install -Dm755 snnm $(sbindir)/snnm;

# install -Dm644 snnm.service $(libdir)/systemd/system/snnm.service;
# install -Dm644 snnm.conf $(sysconfdir)/systemd/snnm.conf;

uninstall:
	rm -f $(sbindir)/snnm;

# rm -f $(libdir)/systemd/system/snnm.service;
# rm -f $(sysconfdir)/systemd/snnm.conf;

clean:
	rm  snnm;