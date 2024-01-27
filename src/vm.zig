const std = @import("std");
const z = @import("zlox.zig");

pub const InterpretResult = enum(u8) { OK, COMPILE_ERROR, RUNTIME_ERROR };

pub const VM = struct {
    chunk: z.Chunk = undefined,
    /// Instruction Pointer: it's an index, unline the original implementation
    ip: usize = 0,

    pub fn init() void {}

    pub fn interpret(vm: *VM, chunk: *z.Chunk) InterpretResult {
        vm.chunk = chunk.*;
        vm.ip = 0;

        return vm.run();
    }

    fn run(vm: *VM) InterpretResult {
        while (true) {
            const instruction: z.OpCode = @enumFromInt(vm.chunk.code.items[vm.ip]);
            vm.ip += 1;
            switch (instruction) {
                .OP_RETURN => return .OK,
                .OP_CONSTANT => {},
            }
        }
    }

    pub fn free() void {}
};
