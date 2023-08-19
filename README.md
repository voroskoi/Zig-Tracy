# How to use this binding

## Linking to Your project

### ...as a ZON dependency

```zig
.{
	.name = "my_program",
	.version = "0.0.1",

	.dependencies = .{
		.tracy = .{
			.url = "https://github.com/silversquirl/Zig-Tracy/archive/main.tar.gz",
            .hash = "12200000000000000000000000000000000000000000000000000000000000000000",
		},
	},
}
```

First try will complain because of hash mismatch, but `zig build` gives You the expected one.

In `build.zig` You have to add the following code:

```zig
XXX - No idea how to link
```

### ...as a git submodule or by vendoring

1. Create a git submodule or copy this repo to project root `libs/Zig-Tracy`.
2. Copy the content of Zig-Tracy `build.zig` to Your project, and do not forget to link the lib
(Something like `exe.linkLibrary(lib)`, where `exe` is a `std.Build.Step.Compile`.

## Within the project code

```zig
const tracy = @import("tracy");

pub fn main() void {
	const trancy_main = tracy.Zone(@src());
	errdefer tracy_main.End();
	defer tracy_main.End();

	// here comes Your code
}
```

You can check if profiling is enabled via the `tracy.enabled` variable.

For your convenience, the minimal source needed to build tracy client v0.9.1 is vendored in this repo.
The tracy server and further documentation are available in the
[official tracy repo](https://github.com/wolfpld/tracy).
