3EMS2Player
===========
An VVC video player based on OpenVVC and MPV.

# On Ubuntu 22.04:
Install dependencies:

## Dependencies oneliner (for hasty people):
```
sudo apt install build-essential yasm libtool autoconf automake meson cmake pkg-config nasm libass-dev libdrm-dev libegl-dev libgles2-mesa-dev libglx-dev liblua libwayland-dev libxcb1-dev libxinerama-dev libxrandr-dev libxss-dev libxv-dev libxml2-dev openssl
```


## Build utilities:
### Generic build utilities:
```
sudo apt install build-essential pkg-config
```

### Assembly compilers (required by FFmpeg):
```
sudo apt install nasm yasm 
```

### GNU AutoTools (required by OpenVVC)
```
sudo apt install libtool autoconf automake 
```

### Meson cmake builds (required by MPV):
```
sudo apt install meson cmake
```

## MPV dependencies
### MPV scripting utilities
```
sudo apt install liblua
```

### OpenGL and graphical stuff
```
sudo apt install libdrm-dev libegl-dev libgles2-mesa-dev libglx-dev 
sudo apt install libass-dev 
```

### Wayland (if needed)
```
sudo apt install libwayland-dev 
```

### X Display utilites
```
sudo apt install libxcb1-dev libxinerama-dev libxrandr-dev libxv-dev libxss-dev 
```

## Additionnal requirements for FFmpeg DASH support
```
sudo apt install libxml2-dev openssl
```

# Build:
This project uses git submodules utility. When checking out into different commits, you need to update submodules position in order to ensure the version of submodule projects is compatible with the current commit. This is done by running:
```
git submodules update --init
```

In order to build the project you just need to run th shell script:
```
./build.sh <PATH_TO_SLHDR_LIB>
```

# Using virtual Environment
At the current time installation is done in the tmp dir.
To launch MPV from the terminal you just need to source the env.mak script resulting from the corresponding build into a running shell program.

```
. env.mak
```

To open the player:
```
mpv <PATH_TO_VIDEO>
```


Once done with the player You can reset the environment variables back to what they were by calling:
```
3ems2_exit_venv
```


