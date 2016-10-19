# Building and Installing

To build the Dispatcher on Linux, you can clone this directory and then execute the following commands from terminal:

```
cd Dispatcher
cd vala
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ../
make install
```

This will install the dispatcher in your applications, to run it simply click on it's icon or to run from cli, simply type:

```
dispatcher
```
