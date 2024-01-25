const std = @import("std");

pub const OpCode = enum(u8) { OP_RETURN };
pub const Code = std.ArrayList(OpCode);

// no need to roll our own, just use std.ArrayList(u8)
/// chunk is a dynamic array of bytes.
pub const Chunk = struct {
    code: std.ArrayList(OpCode),

    pub fn init(alloc: std.mem.Allocator) Chunk {
        return Chunk{ .code = std.ArrayList(OpCode).init(alloc) };
    }

    pub fn write(c: *Chunk, op: OpCode) !void {
        try c.code.append(op);
    }

    pub fn free(c: *Chunk) void {
        c.code.deinit();
    }
};
