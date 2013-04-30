#
# Build Authy OpenVPN plugin module on *nix.

CC=gcc
LIBNAME=authy-openvpn
CFLAGS=-fPIC -O2 -Wall
OBJFLAGS=-I./include/ -c
LIBFLAGS=-shared -Wl,-soname
PAM=pam

all: $(LIBNAME).so $(PAM).so

objects:
	rm -f *.o
	$(CC) $(CFLAGS) -lcurl $(OBJFLAGS) src/*.c src/*.h

$(LIBNAME).so: objects
	# MAC SUPER dylib compile gcc -dynamiclib	-Wl,-headerpad_max_install_names,-undefined,dynamic_lookup,-compatibility_version,1.0,-current_version,1.0,-install_name,/usr/local/lib/lib$(OBJ).1.dylib	-o lib$(OBJ).1.dylib $(OBJ).o
	$(CC) $(CFLAGS) $(LIBFLAGS),$(LIBNAME).so -o $(LIBNAME).so *.o -lc -lcurl

$(PAM).o:
	rm -f *.o
	$(CC) $(CFLAGS) -lpam $(OBJFLAGS) custom-pam-module/*.c custom-pam-module/*.h

$(PAM).so: $(PAM).o
	$(CC) $(CFLAGS) $(LIBFLAGS),$(PAM).so -o $(PAM).so *.o -lc -lpam

install: $(LIBNAME).so $(PAM).so
	cp $(LIBNAME).so $(PAM).so $(DESTDIR)/

clean:
	rm -f *.o
