const std = @import("std");

const _chunk = @import("chunk.zig");
const _value = @import("value.zig");

const Chunk = _chunk.Chunk;
const OpCode = _chunk.OpCode;
const Code = _chunk.Code;

const Value = _value.Value;
const printValue = _value.printValue;

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

    // print line numbers
    const lines = chunk.lines.items;
    if (offset > 0 and lines[offset] == lines[offset - 1]) {
        print("   | ", .{});
    } else {
        print("{d:4} ", .{lines[offset]});
    }

    const instruction: OpCode = @enumFromInt(chunk.code.items[offset]);

    switch (instruction) {
        .OP_RETURN => return simpleInstruction("OP_RETURN", offset),
        .OP_CONSTANT => return constantInstruction("OP_CONSTANT", chunk, offset),
    }
}

pub fn simpleInstruction(name: string, offset: usize) usize {
    print("{s}\n", .{name});
    return offset + 1;
}

pub fn constantInstruction(name: string, chunk: *Chunk, offset: usize) usize {
    const constant: u8 = chunk.code.items[offset + 1];
    // printf("%-16s %4d '", name, constant);

    print("{s:<16} {d:4} '", .{ name, constant });
    printValue(chunk.constants.values.items[constant - 1]);
    print("'\n", .{});

    return offset + 2;
}
