const std = @import("std");
const z = @import("zlox.zig");

pub const STACK_MAX = 256;

pub const InterpretResult = enum(u8) { OK, COMPILE_ERROR, RUNTIME_ERROR };

pub const VM = struct {
    chunk: z.Chunk = undefined,
    /// Instruction Pointer: it's an index, unline the original implementation
    ip: usize = 0,

    stack: [STACK_MAX]z.Value = undefined,

    /// stack_top is also an index, because arrays and pointers are weird.
    /// to get the element on top of the stack, you do stack[stack_top]
    stack_top: usize = 0,

    // stack stuff
    fn reset_stack(vm: *VM) void {
        vm.stack_top = 0;
    }

    pub fn push(vm: *VM, val: z.Value) void {
        vm.stack[vm.stack_top] = val;
        vm.stack_top += 1;
    }

    pub fn pop(vm: *VM) z.Value {
        defer vm.stack_top -= 1;
        return vm.stack[vm.stack_top];
    }

    pub fn init(vm: *VM) void {
        vm.reset_stack();
    }

    pub fn interpret(vm: *VM, chunk: *z.Chunk) InterpretResult {
        vm.chunk = chunk.*;
        vm.ip = 0;

        return vm.run();
    }

    fn run(vm: *VM) InterpretResult {
        while (true) {
            if (z.DEBUG_TRACE_EXECUTION) {
                _ = z.disassembleInstruction(&vm.chunk, vm.ip);
            }
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
