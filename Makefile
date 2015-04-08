#
# Makefile
#

SUBDIRS =

include ./Makefile.ax

install-local:
	install -d -o $(USER) -g $(GROUP) -m 755 \
	 $(DESTDIR)$(PREFIX)/bin
	install -p -o $(USER) -g $(GROUP) -m 755 appify.sh \
	 $(DESTDIR)$(PREFIX)/bin/appify
