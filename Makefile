PCPGIT  := /home/vagrant/pcp
PCPWEB  := /home/vagrant/performancecopilot.github.io
URL = https://pcp.io
-include ./localdefs

RSYNC := rsync -azvP --prune-empty-dirs --exclude '*.scss' --exclude '*.haml' \
	--exclude 'Makefile' --exclude 'README' --exclude 'TODO' --exclude 'links.out' \
	--exclude '.git' --exclude '*.swp' --exclude '.sass-cache' \
	--exclude '.gitignore' --exclude 'scripts' --exclude 'README.md' --exclude 'compass' \
	--exclude '*.[1-9]' --exclude 'GNUmakefile' --exclude 'Check' --exclude 'stock-images' \
	--exclude 'pcp-brand' --exclude 'NEWRELEASE' --exclude 'pcp.git' --exclude 'pcp-gui.git' \
	--exclude 'srpm' --exclude 'Vagrantfile' --exclude '.vagrant' \

HAMLFILES = \
	index features documentation community website faq \
	presentations glider screenshots download testimonials \
	gsoc/2015/ideas gsoc/2016/ideas gsoc/2017/ideas gsoc/2018/ideas \
	gsoc/2019/ideas gsoc/2020/ideas \
	gsod/2019/ideas gsod/2020/ideas \
	conference/2018/home conference/2018/contact conference/2018/schedule \
	conference/2019/home conference/2019/contact conference/2019/schedule \

all: clean import man docs prep local

local: 
	find . -type f -exec chmod 644 "{}" \;
	find scripts/ -type f -iname '*.sh' -exec chmod 755 "{}" \;
	find scripts/ -type f -iname '*.py' -exec chmod 755 "{}" \;
	$(RSYNC) . $(PCPWEB)
	cd $(PCPWEB) && git add . && cd $(PCPWEB) && git commit \
	    -m "Automated update from performancecopilot/pcp-website.git"

install: 
	cd $(PCPWEB) && git push

prep: 
	compass compile -c compass/config.rb -s compressed
	for h in `echo $(HAMLFILES)`; do \
	    haml $$h.haml > $$h.html; \
	done
	./scripts/build-team.py $(PCPGIT) | haml > team.html

man:
	./scripts/build-man.sh $(PCPGIT)
	./scripts/create-manindex.py

docs:
	./scripts/build-docs.sh

import:
	mkdir doc docs man images 2>/dev/null || /bin/true
	rsync -Lrdp stock-images/* images/
	rsync -Lrdp $(PCPGIT)/man/html/* docs/
	rsync -Lrdp $(PCPGIT)/man/* man
	rsync -Lrdp $(PCPGIT)/man/html/images/* images/
	rsync -Lrdp $(PCPGIT)/images/* docs/images
	rm -rf man/html man/retired
	ln -s images/pcp.ico favicon.ico

uncompressed:
	sass mycss.scss css/uncompressed.css

check:
	linkchecker --check-extern -v $(URL) | grep -v seconds > links.out || /bin/true
	grep "errors found" links.out

checkimages:
	./scripts/check-for-unused-images.py $(PCPWEB)

.PHONY: clean man docs

clean:
	rm -rf *.html doc docs man images favicon.ico $(PCPWEB)/* assets/css/*.css conference/*/*.html gsod/*/*.html gsoc/*/*.html || /bin/true
