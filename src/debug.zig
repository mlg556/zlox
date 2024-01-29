const std = @import("std");

const z = @import("zlox.zig");

pub fn disassembleChunk(chunk: *z.Chunk, name: z.string) void {
    // printf("== %s ==\n", name);
    z.print("== {s} ==\n", .{name});

    var offset: usize = 0;

    while (offset < chunk.code.items.len) {
        offset = disassembleInstruction(chunk, offset);
    }
}

pub fn disassembleInstruction(chunk: *z.Chunk, offset: usize) usize {
    z.print("{d:0>4} ", .{offset});

    // print line numbers
    const lines = chunk.lines.items;
    if (offset > 0 and lines[offset] == lines[offset - 1]) {
        z.print("   | ", .{});
    } else {
        z.print("{d:4} ", .{lines[offset]});
    }

    const instruction: z.OpCode = @enumFromInt(chunk.code.items[offset]);

    // lets avoid repetition by using @tagName
    switch (instruction) {
        .OP_CONSTANT => return constantInstruction("OP_CONSTANT", chunk, offset),
        // the rest are simple instructions
        else => return simpleInstruction(@tagName(instruction), offset),
    }
}

pub fn simpleInstruction(name: z.string, offset: usize) usize {
    z.print("{s}\n", .{name});
    return offset + 1;
}

pub fn constantInstruction(name: z.string, chunk: *z.Chunk, offset: usize) usize {
    const constant: u8 = chunk.code.items[offset + 1];

    z.print("{s:<16} {d:4} '", .{ name, constant });
    z.printValue(chunk.constants.values.items[constant]);
    z.print("'\n", .{});

    return offset + 2;
}
