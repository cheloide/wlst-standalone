# wlst-standalone

## Tool to create a wlst standalone without the bloat of a Weblogic Installation.

### Downloads 
* Weblogic Server 12.2.1.3.0 installer: http://download.oracle.com/otn/nt/middleware/12c/12213/fmw_12.2.1.3.0_wls_Disk1_1of1.zip
* Server JRE 8u211: https://download.oracle.com/otn/java/jdk/8u221-b11/230deb18db3e4014bb8e3e8324f81b43/server-jre-8u221-linux-x64.tar.gz

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

