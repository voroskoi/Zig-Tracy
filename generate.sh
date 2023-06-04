#!/bin/sh
zig translate-c tracy/tracy/TracyC.h -lc -DTRACY_ENABLE >tracy_c.zig
