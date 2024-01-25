const std = @import("std");

const _chunk = @import("chunk.zig");

const Chunk = _chunk.Chunk;
const OpCode = _chunk.OpCode;
const Code = _chunk.Code;

const string = []const u8;

const print = std.debug.print;

pub fn disassembleChunk(chunk: *Chunk, name: string) void {
    // printf("== %s ==\n", name);
    print("== {s} ==\n", .{name});

    var offset: usize = 0;

    while (offset < chunk.code.items.len) {
        offset = disassembleInstruction(chunk, offset);
    }
}

pub fn disassembleInstruction(chunk: *Chunk, offset: usize) usize {
    print("{d:0>4} ", .{offset});

    const instruction = chunk.code.items[offset];

    switch (instruction) {
        .OP_RETURN => return simpleInstruction("OP_RETURN", offset),
        // else => {
        //     print("Unknown OpCode {d}\n", .{instruction});
        //     return offset + 1;
        // },
    }
}

pub fn simpleInstruction(name: string, offset: usize) usize {
    print("{s}\n", .{name});
    return offset + 1;
}
