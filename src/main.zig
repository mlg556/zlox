const std = @import("std");

const _c = @import("chunk.zig");
const Chunk = _c.Chunk;
const OpCode = _c.OpCode;

const debug = @import("debug.zig");

pub fn main() !void {
    var buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    var chunk = Chunk.init(allocator);
    defer chunk.free();

    const constant = try chunk.addConstant(42);
    try chunk.write(@intFromEnum(OpCode.OP_CONSTANT));
    try chunk.write(constant);

    try chunk.write(@intFromEnum(OpCode.OP_RETURN));

    debug.disassembleChunk(&chunk, "chunk0");
}
