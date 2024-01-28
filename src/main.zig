const std = @import("std");
const z = @import("zlox.zig");

pub fn main() !void {
    z.print(" \n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var chunk = z.Chunk.init(allocator);
    defer chunk.free();

    var vm = z.VM{};

    const constant = try chunk.addConstant(1.2);
    try chunk.write(@intFromEnum(z.OpCode.OP_CONSTANT), 123);
    try chunk.write(constant, 123);

    try chunk.write(@intFromEnum(z.OpCode.OP_NEGATE), 123);

    try chunk.write(@intFromEnum(z.OpCode.OP_RETURN), 123);

    z.disassembleChunk(&chunk, "test chunk");

    _ = vm.interpret(&chunk);
}

// test catches memory leaks (via std.testing.allocator), which is also nice
test "test" {
    z.print(" \n", .{});

    var chunk = z.Chunk.init(std.testing.allocator);
    defer chunk.free();

    var vm = z.VM{};

    const constant = try chunk.addConstant(1.2);
    try chunk.write(@intFromEnum(z.OpCode.OP_CONSTANT), 123);
    try chunk.write(constant, 123);

    // try chunk.write(@intFromEnum(z.OpCode.OP_NEGATE), 123);

    try chunk.write(@intFromEnum(z.OpCode.OP_RETURN), 123);

    z.disassembleChunk(&chunk, "test chunk");

    _ = vm.interpret(&chunk);

    try std.testing.expect(true);
}
