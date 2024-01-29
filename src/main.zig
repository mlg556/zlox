const std = @import("std");
const z = @import("zlox.zig");

pub fn main() !void {}

test "machine code" {
    z.print(" \n", .{});

    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // const allocator = gpa.allocator();

    var chunk = z.Chunk.init(std.testing.allocator);
    defer chunk.free();

    var vm = z.VM{};

    // -((1.2 + 3.4) / 5.6) = -0.8214285714285714
    //
    //        |-|
    //         |
    //        |/|
    //       /   \
    //     |+|   |5.6|
    //    /   \
    // |1.2| |3.4|

    var constant = try chunk.addConstant(1.2);
    try chunk.write(@intFromEnum(z.OpCode.OP_CONSTANT), 1);
    try chunk.write(constant, 1);

    constant = try chunk.addConstant(3.4);
    try chunk.write(@intFromEnum(z.OpCode.OP_CONSTANT), 1);
    try chunk.write(constant, 1);

    try chunk.write(@intFromEnum(z.OpCode.OP_ADD), 1);

    constant = try chunk.addConstant(5.6);
    try chunk.write(@intFromEnum(z.OpCode.OP_CONSTANT), 1);
    try chunk.write(constant, 1);

    try chunk.write(@intFromEnum(z.OpCode.OP_DIVIDE), 1);
    try chunk.write(@intFromEnum(z.OpCode.OP_NEGATE), 1);
    try chunk.write(@intFromEnum(z.OpCode.OP_RETURN), 1);

    // z.disassembleChunk(&chunk, "test chunk");

    _ = vm.interpret(&chunk);
}
