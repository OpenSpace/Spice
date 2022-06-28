# Spice
An unofficial GitHub presence of JPL's NAIF's SPICE library. You can find all information on the official website http://naif.jpl.nasa.gov/naif, including all source code, tutorials, training, support, and bug reports.


### Changelog to the official source release:
Combining the different source code releases for Visual Studio, Linux, MacOS, and Cygwin into a single source tree that contains `common` files and platform specific subfolders.

`fio.h`:
```cpp
- extern int isatty(int);
+ extern _ACRTIMP int isatty(int);
```
