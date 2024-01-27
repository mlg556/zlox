const std = @import("std");

const _chunk = @import("chunk.zig");
const Chunk = _chunk.Chunk;

pub const VM = struct {
    chunk: Chunk,

    pub fn init(alloc: std.mem.Allocator) VM {
        return VM{ .chunk = Chunk.init(alloc) };
    }

    pub fn free(self: *VM) void {
        self.chunk.free();
    }
};
