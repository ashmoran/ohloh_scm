#!/usr/bin/env sh

rm -r darcs darcs_tagged


### REPO darcs

mkdir darcs
cd darcs
darcs init

# Patch 1 - add helloworld.c

cat > helloworld.c <<END
/* Hello, World! */
#include <stdio.h>
main()
{
       printf("Hello, World!\n");
}
END

darcs add helloworld.c
darcs record -a --author 'Robin Luckey <robin@ohloh.net>' -m 'Initial Checkin'

sleep 1

# Patch 2 - add makefile

cat > makefile <<END
all: helloworld

helloworld: helloworld.c
  gcc -o helloworld helloworld.c
END

darcs add makefile
darcs record -a --author 'Robin Luckey <robin@ohloh.net>' -m 'added makefile'

sleep 1

# Patch 3 - update helloworld.c, add README

cat > helloworld.c <<END
/* Hello, World! */

/*
 * This file is not covered by any license, especially not
 * the GNU General Public License (GPL). Have fun!
 */

#include <stdio.h>
main()
{
  printf("Hello, World!\n");
}
END

cat > README <<END
This is a simple helloworld application.
It is just a test.
END

darcs add README
darcs record -a --author 'Robin Luckey <robin@ohloh.net>' -m 'added some documentation and licensing info'

sleep 1

# Patch 4 - remove helloworld.c

rm helloworld.c
darcs record -a --author 'Robin Luckey <robin@ohloh.net>' -m 'deleted helloworld.c'

sleep 1


### REPO darcs_tagged

cd ..
darcs get darcs darcs_tagged
cd darcs_tagged

# Patch 5 - tag

darcs tag --author 'Robin Luckey <robin@ohloh.net>' -m 'First tag'

sleep 1