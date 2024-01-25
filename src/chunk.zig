const std = @import("std");

pub const OpCode = enum { OP_RETURN };

// no need to roll our own, just use std.ArrayList(u8)
/// chunk is a dynamic array of bytes.
const Chunk = struct {
    code: std.ArrayList(u8),

    pub fn init(c: *Chunk, alloc: std.mem.Allocator) void {
        c.code = std.ArrayList(u8).init(alloc);
    }

    pub fn write(c: *Chunk, byte: u8) !void {
        try c.code.append(byte);
    }

    pub fn free(c: *Chunk) void {
        c.code.deinit();
    }
};
