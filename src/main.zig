const std = @import("std");

const _chunk = @import("chunk.zig");
const Chunk = _chunk.Chunk;
const OpCode = _chunk.OpCode;

const debug = @import("debug.zig");

pub fn main() !void {}

// test catches memory leaks (via std.testing.allocator), so we'll use that
test "test" {
    var chunk = Chunk.init(std.testing.allocator);
    defer chunk.free();

    const constant = try chunk.addConstant(1.2);
    try chunk.write(@intFromEnum(OpCode.OP_CONSTANT), 123);
    try chunk.write(constant, 123);

    try chunk.write(@intFromEnum(OpCode.OP_RETURN), 123);

    debug.disassembleChunk(&chunk, "test chunk");

    try std.testing.expect(true);
}
