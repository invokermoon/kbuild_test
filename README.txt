>>>Target:
    generate a test.bin

>>>Knowledge:
    Kbuild.mk
    Makefile

>>>Makefile Run Flow
   Makefile-------------->build/base.mk----------------->build/Makefile.build
step 1:
    convert the config/Kconfig to out/kbuild/config.h
    convert the CONFIG_XXXX =y to #define CONFIG_XXX  1
step 2:
   compile the file in the Kbuild.mk
    ├── kapp
    │   └── libkbuildout.a----------->add.o subtraction.o main.o {include the top_built.a} (This .a contain all of the .o defined in the Kbuil.mk)
    ├── kbuild
    │   ├── built-in.a
    │   ├── config.h
    │   └── main_code
    │       ├── algo
    │       │   ├── add.o
    │       │   ├── built-in.a
    │       │   └── subtraction.o----->add.o subtraction.o
    │       ├── built-in.a------------>add.o subtraction.o main.o
    │       └── main.o
    └── test.bin

