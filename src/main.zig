const std = @import("std");

const Chunk = @import("chunk.zig").Chunk;
const debug = @import("debug.zig");

pub fn main() !void {
    var buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    var chunk = Chunk.init(allocator);
    defer chunk.free();

    try chunk.write(.OP_RETURN);

    debug.disassembleChunk(&chunk, "chunk0");
}

// test "chunky" {
//     var chunk = Chunk.init(std.testing.allocator);
//     try chunk.write(.OP_RETURN);
//     debug.disassembleChunk(&chunk, "chunk0");
// }
