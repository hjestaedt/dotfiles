.PHONY: help install uninstall update clean

# Default target
help:
	@echo "Makefile for bash configuration"
	@echo ""
	@echo "available targets:"
	@echo "  install              install bash configuration"
	@echo "  uninstall            uninstall bash configuration"
	@echo "  clean                remove all backup files"
	@echo "  help                 show this help message"

install:
	./install-local.sh -o -s

uninstall:
	./uninstall-local.sh -f -s

update: uninstall install

# Clean backup files
clean:
	@echo "removing backup files..."
	@rm -f ~/.bashrc.backup_*
	@rm -rf ~/.bashrc.d.backup_*
	@echo "backup files removed" 