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
            const instruction = vm.read_byte();
            switch (instruction) {
                .OP_RETURN => return .OK,
                .OP_CONSTANT => {
                    const constant: z.Value = vm.read_constant();
                    z.printValue(constant);
                    z.print("\n", .{});
                },
            }
        }
    }

    fn read_byte(vm: *VM) z.OpCode {
        defer vm.ip += 1;
        return @enumFromInt(vm.chunk.code.items[vm.ip]);
    }

    fn read_constant(vm: *VM) z.Value {
        defer vm.ip += 1;
        return vm.chunk.constants.values.items[vm.ip - 1];
    }

    pub fn free() void {}
};
