# Spice
An unofficial GitHub presence of JPL's NAIF's SPICE library. You can find all information on the official website http://naif.jpl.nasa.gov/naif, including all source code, tutorials, training, support, and bug reports.


### Changelog to the official source release:
`fio.h`:
```cpp
+ #ifdef WIN32
+ #define LINKAGE _ACRTIMP
+ #else
+ #define LINKAGE
+ #endif

- extern int isatty(int);
+ extern LINKAGE int isatty(int);

```
