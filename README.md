# wlst-standalone

## Tool to create a wlst standalone without the bloat of a Weblogic Installation.

### Downloads 
* Weblogic Server 12.2.1.3.0 installer: (fmw_12.2.1.3.0_wls_disk1_1of1.zip): https://www.oracle.com/middleware/technologies/weblogic-server-downloads.html
* Server JRE8: https://www.oracle.com/java/technologies/javase-server-jre8-downloads.html

### Usage

To create the required files run:


```sh
    ./packager/repack_wlst122130.sh <JRE path> <WLS zipped installer path> <Destination folder>
```

example:
```sh
./packager/repack_wlst122130.sh \
$HOME/Downloads/server-jre-8u221-linux-x64.tar.gz \
$HOME/Downloads/fmw_12.2.1.3.0_wls_Disk1_1of1.zip \
$HOME/wlst-standalone
```

