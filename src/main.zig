const std = @import("std");

const _c = @import("chunk.zig");
const Chunk = _c.Chunk;
const OpCode = _c.OpCode;

const debug = @import("debug.zig");

pub fn main() !void {
    // var buffer: [1000]u8 = undefined;
    // var fba = std.heap.FixedBufferAllocator.init(&buffer);
    // const allocator = fba.allocator();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var chunk = Chunk.init(allocator);
    defer chunk.free();

    const constant = try chunk.addConstant(1.2);
    try chunk.write(@intFromEnum(OpCode.OP_CONSTANT), 123);
    try chunk.write(constant, 123);

    try chunk.write(@intFromEnum(OpCode.OP_RETURN), 123);

    debug.disassembleChunk(&chunk, "chunk0");
}
