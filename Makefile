PY?=
PELICAN?=pelican
PELICANOPTS=

# Use BASEDIR to detect current directory and set paths accordingly
BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

# FTP and SSH settings (you can ignore these if not using)
FTP_HOST=localhost
FTP_USER=anonymous
FTP_TARGET_DIR=/

SSH_HOST=localhost
SSH_PORT=22
SSH_USER=root
SSH_TARGET_DIR=/var/www

GITHUB_PAGES_BRANCH=main
GITHUB_PAGES_COMMIT_MESSAGE=Generate Pelican site

# Debugging options
DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

# Relative URL options
RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

SERVER ?= "0.0.0.0"

PORT ?= 0
ifneq ($(PORT), 0)
	PELICANOPTS += -p $(PORT)
endif

# Helper messages for make commands
help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          serve and regenerate together      '
	@echo '   make devserver-global               regenerate and serve on 0.0.0.0    '
	@echo '   make ssh_upload                     upload the web site via SSH        '
	@echo '   make sftp_upload                    upload the web site via SFTP       '
	@echo '   make rsync_upload                   upload the web site via rsync+ssh  '
	@echo '   make ftp_upload                     upload the web site via FTP        '
	@echo '   make github                         upload the web site via gh-pages   '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

# Generate the HTML output using pelican
html:
	"$(PELICAN)" "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

# Clean up by removing the generated files
clean:
	@if [ -d "$(OUTPUTDIR)" ]; then rm -rf "$(OUTPUTDIR)"; fi

# Regenerate files when changes are detected
regenerate:
	"$(PELICAN)" -r "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

# Serve the site locally
serve:
	"$(PELICAN)" -l "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

# Serve the site globally
serve-global:
	"$(PELICAN)" -l "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS) -b $(SERVER)

# Serve and regenerate together
devserver:
	"$(PELICAN)" -lr "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

# Serve and regenerate globally
devserver-global:
	"$(PELICAN)" -lr "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS) -b 0.0.0.0

# Publish the site using production settings
publish:
	"$(PELICAN)" "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(PUBLISHCONF)" $(PELICANOPTS)

# SSH upload target
ssh_upload: publish
	scp -P $(SSH_PORT) -r "$(OUTPUTDIR)"/* "$(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)"

# SFTP upload target
sftp_upload: publish
	printf 'put -r $(OUTPUTDIR)/*' | sftp $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

# Rsync upload target
rsync_upload: publish
	rsync -e "ssh -p $(SSH_PORT)" -P -rvzc --include tags --cvs-exclude --delete "$(OUTPUTDIR)"/ "$(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)"

# FTP upload target
ftp_upload: publish
	lftp ftp://$(FTP_USER)@$(FTP_HOST) -e "mirror -R $(OUTPUTDIR) $(FTP_TARGET_DIR) ; quit"

# GitHub Pages upload target
github: publish
	ghp-import -m "$(GITHUB_PAGES_COMMIT_MESSAGE)" -b $(GITHUB_PAGES_BRANCH) "$(OUTPUTDIR)" --no-jekyll
	git push origin $(GITHUB_PAGES_BRANCH)


.PHONY: html help clean regenerate serve serve-global devserver devserver-global publish ssh_upload sftp_upload rsync_upload ftp_upload github
