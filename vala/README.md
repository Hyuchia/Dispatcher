# Dispatcher for Linux


## Dependencies

To build the dispatcher you'll need the following installed:

* Cmake
* Vala
* Gtk 3.0

### Debian and Ubuntu

To get this packages in Debian, Ubuntu and it's derivatives, you can install the following packages:

```
apt install build-essentials
apt install valac
```

### Elementary OS
To get this packages in eOS and, you can install the following packages:

```
apt install elementary-sdk
```

### Fedora and RHEL
To get this packages in Fedora or RHEL and, you can install the following packages:

```
dnf install vala
```


## Building

To build the Dispatcher on Linux, you can clone this directory and then execute the following commands from terminal:




```
cd Dispatcher
cd vala
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ../
make
make install
```

This will install the dispatcher in your applications, to run it simply click on it's icon or to run from cli, simply type:

```
dispatcher
```
