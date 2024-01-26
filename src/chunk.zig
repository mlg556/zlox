const std = @import("std");
const _v = @import("value.zig");

const Value = _v.Value;
const ValueArray = _v.ValueArray;

pub const OpCode = enum(u8) { OP_RETURN, OP_CONSTANT };
pub const Code = std.ArrayList(OpCode);

// no need to roll our own, just use std.ArrayList(u8)
/// chunk is a dynamic array of bytes.
pub const Chunk = struct {
    code: std.ArrayList(OpCode),
    constants: ValueArray,

    pub fn init(alloc: std.mem.Allocator) Chunk {
        return Chunk{
            .code = std.ArrayList(OpCode).init(alloc),
            .constants = ValueArray.init(alloc),
        };
    }

    pub fn writeOp(self: *Chunk, op: OpCode) !void {
        try self.code.append(op);
    }

    pub fn free(self: *Chunk) void {
        self.code.deinit();
        self.constants.free();
    }

    pub fn addConstant(self: *Chunk, val: Value) !usize {
        try self.constants.write(val);
        return self.constants.values.items.len;
    }
};
