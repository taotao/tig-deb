PROJECT=tig
VERSION=2.1.1
RELEASE_PATH=https://github.com/jonas/$(PROJECT)/archive

PROJECT_BUILD_DIR=$(PROJECT)-$(PROJECT)-$(VERSION)

ARCHIVE=$(PROJECT)-$(VERSION).tar.gz
ORIG_ARCHIVE=$(PROJECT)_$(VERSION).orig.tar.gz

DEB_FILE=$(PROJECT)_$(VERSION)-$(DEB_VERSION)_$(DEB_ARCH).deb

BINTRAY_UPLOAD_PATH=https://api.bintray.com/content/$(BINTRAY_USER)/$(BINTRAY_PROJECT)/$(PROJECT)/$(VERSION)/$(DEB_FILE)
BINTRAY_PUBLISH_PATH=https://api.bintray.com/content/$(BINTRAY_USER)/$(BINTRAY_PROJECT)/$(PROJECT)/$(VERSION)/publish

.PHONY: all clean deb download $(ARCHIVE) $(ORIG_ARCHIVE) changelog upload

all: deb

clean:
	rm -rf \
		$(PROJECT_SRC_DIR) \
		$(PROJECT_BUILD_DIR) \
		$(PROJECT)-*.tar.gz \
		$(PROJECT)_*.tar.gz \
		$(PROJECT)_*.build \
		$(PROJECT)_*.changes \
		$(PROJECT)_*.dsc \
		$(PROJECT)_*.deb

download:
	wget -q $(RELEASE_PATH)/$(ARCHIVE) -O $(ARCHIVE)

$(ORIG_ARCHIVE): $(ARCHIVE)
	cp $< $@

deb: download $(ORIG_ARCHIVE)
	tar zxvf $(ORIG_ARCHIVE)
	cp -r debian/ $(PROJECT_BUILD_DIR)
	cd $(PROJECT_BUILD_DIR) && debuild -us -uc

changelog:
	dch -v $(VERSION)-$(DEB_VERSION) -D $(DEB_DIST) -M -u low \
		--release-heuristic log

upload:
	@curl -X PUT -T $(DEB_FILE) -u$(BINTRAY_USER):$(BINTRAY_TOKEN) "$(BINTRAY_UPLOAD_PATH);deb_distribution=$(DEB_DIST);deb_component=$(DEB_COMP);deb_architecture=$(DEB_ARCH)"
	@curl --fail -X POST -u$(BINTRAY_USER):$(BINTRAY_TOKEN) "$(BINTRAY_PUBLISH_PATH)"
