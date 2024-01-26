const std = @import("std");

const Chunk = @import("chunk.zig").Chunk;
const debug = @import("debug.zig");

pub fn main() !void {
    var buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    var chunk = Chunk.init(allocator);
    defer chunk.free();

    const constant = try chunk.addConstant(42);
    try chunk.write(.OP_CONSTANT);
    try chunk.write(constant);

    try chunk.write(.OP_RETURN);

    debug.disassembleChunk(&chunk, "chunk0");
}
