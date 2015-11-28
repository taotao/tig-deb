tig debian package

# Add changelogfile
```
DEB_VERSION=0custom1 DEB_DIST=unstable make changelog
```

# Upload to bintray
```
DEB_VERSION=0custom1 DEB_DIST=unstable DEB_COMP=main DEB_ARCH=amd64 BINTRAY_USER=$user BINTRAY_TOKEN=$token BINTRAY_PROJECT=$project make upload
```
