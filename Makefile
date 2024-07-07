# Define the directories for installation
PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin/
SHAREDIR = $(PREFIX)/share/engine-stressor
SHAREDIR_DOC = $(PREFIX)/share/doc/engine-stressor
CONFIGDIR = $(HOME)/.config/engine-stressor

# Define the list of scripts and files
SCRIPTS = cgroup \
	memory \
	engine \
	network \
	engine-operations \
	processes \
	volume \
	stress \
	systemd \
	system \
	date \
	rpm \
	common \
	selinux

BIN_FILE = engine-stressor

DOCS = README.md LICENSE SECURITY.md NOTICE

CONFIG_FILE = constants

# Default target
all:
	@echo "Available targets: install, uninstall"

# Install target
install:
	@install -d $(DESTDIR)$(SHAREDIR)
	@install -d $(DESTDIR)$(SHAREDIR_DOC)
	@install -d $(DESTDIR)$(BINDIR)
	@install -d $(DESTDIR)$(CONFIGDIR)
	@for script in $(SCRIPTS); do \
                install -m 755 $$script $(DESTDIR)$(SHAREDIR); \
        done
	@for doc in $(DOCS); do \
                install -m 644 $$doc $(DESTDIR)$(SHAREDIR_DOC); \
        done
	@install -m 755 $(BIN_FILE) $(DESTDIR)$(BINDIR)
	@install -m 644 $(CONFIG_FILE) $(DESTDIR)$(CONFIGDIR)/$(CONFIG_FILE)
	@if ! grep -q '^SHARE_DIR=$(SHAREDIR)' $(DESTDIR)$(CONFIGDIR)/$(CONFIG_FILE); then \
                echo 'SHARE_DIR=$(SHAREDIR)' >> $(DESTDIR)$(CONFIGDIR)/$(CONFIG_FILE); \
        fi
	if [ -f /etc/os-release ]; then \
		. /etc/os-release; \
		if [ "$$ID" = "fedora" ] || [ "$$ID" = "centos" ]; then \
			if ! rpm -q aardvark-dns >/dev/null 2>&1; then \
				sudo dnf install -y aardvark-dns; \
			fi
		fi
	fi
	@echo "Installation complete."

# Uninstall target
uninstall:
	@for script in $(SCRIPTS); do \
                rm -f $(DESTDIR)$(SHAREDIR)/$$script; \
        done
	rm -rf $(DESTDIR)$(SHAREDIR)
	rm -rf $(DESTDIR)$(SHAREDIR_DOC)
	rm -rf $(DESTDIR)$(CONFIGDIR)
	rm -f $(DESTDIR)$(BINDIR)/$(BIN_FILE)
	@echo "Uninstallation complete."

.PHONY: all install uninstall

