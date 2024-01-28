const std = @import("std");
const z = @import("zlox.zig");

pub const OpCode = enum(u8) { OP_RETURN, OP_CONSTANT, OP_NEGATE };

/// arraylist of bytes
pub const Code = std.ArrayList(u8);

pub const LineNum = std.ArrayList(usize);

// no need to roll our own, just use std.ArrayList(u8)
/// chunk is a dynamic array of bytes.
pub const Chunk = struct {
    code: Code,
    lines: LineNum,
    constants: z.ValueArray,

    pub fn init(alloc: std.mem.Allocator) Chunk {
        return Chunk{
            .code = Code.init(alloc),
            .lines = LineNum.init(alloc),
            .constants = z.ValueArray.init(alloc),
        };
    }

    pub fn write(self: *Chunk, byte: u8, line: usize) !void {
        try self.code.append(byte);
        try self.lines.append(line);
    }

    pub fn free(self: *Chunk) void {
        self.code.deinit();
        self.lines.deinit();
        self.constants.free();
    }

    pub fn addConstant(self: *Chunk, val: z.Value) !u8 {
        try self.constants.write(val);
        return @intCast(self.constants.values.items.len - 1);
    }
};
