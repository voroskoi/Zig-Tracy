const std = @import("std");
const Builder = std.Build.Builder;
const LibExeObjStep = std.Build.LibExeObjStep;

/// Build required sources, use tracy by importing "tracy.zig"
pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("tracy", .{
        .source_file = .{ .path = "tracy.zig" },
    });

    const lib = b.addStaticLibrary(.{
        .name = "tracy",
        .root_source_file = .{ .path = "nothing.zig" }, // Give the linker something to link when tracy is disabled
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lib);
    lib.addIncludePath(.{ .path = "tracy" });
    lib.addCSourceFile(.{
        .file = .{ .path = "tracy/TracyClient.cpp" },
        // MinGW doesn't have all the newfangled windows features,
        // so we need to pretend to have an older windows version.
        .flags = &.{
            "-DTRACY_ENABLE",
            "-D_WIN32_WINNT=0x601",
            "-fno-sanitize=undefined",
        },
    });

    lib.linkLibC();
    lib.linkLibCpp();

    if (lib.target.isWindows()) {
        lib.linkSystemLibrary("Advapi32");
        lib.linkSystemLibrary("User32");
        lib.linkSystemLibrary("Ws2_32");
        lib.linkSystemLibrary("DbgHelp");
    }
}
