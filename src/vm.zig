const std = @import("std");
const z = @import("zlox.zig");

pub const STACK_MAX = 256;

pub const InterpretResult = enum(u8) { OK, COMPILE_ERROR, RUNTIME_ERROR };

pub const VM = struct {
    chunk: z.Chunk = undefined,
    /// Instruction Pointer: it's an index, unlike the original implementation
    ip: usize = 0,

    stack: [STACK_MAX]z.Value = undefined,

    /// stack_top is also an index, because arrays and pointers are weird.
    /// to get the element on top of the stack, you do stack[stack_top]
    stack_top: usize = 0,

    // can I use an array and a slice instead of a stack and index?

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
        return vm.stack[vm.stack_top - 1]; // off by 1?
    }

    pub fn init(vm: *VM) void {
        vm.reset_stack();
    }

    // pub fn interpret(vm: *VM, chunk: *z.Chunk) InterpretResult {
    //     vm.chunk = chunk.*;
    //     vm.ip = 0;

    //     return vm.run();
    // }

    pub fn interpret(source: z.string) InterpretResult {
        z.compile(source);
        return .OK;
    }

    fn run(vm: *VM) InterpretResult {
        while (true) {
            if (z.DEBUG_TRACE_EXECUTION) {
                z.print("          ", .{});
                for (0..vm.stack_top) |i| {
                    z.print("[ ", .{});
                    z.printValue(vm.stack[i]);
                    z.print(" ]", .{});
                }
                z.print("\n", .{});
                _ = z.disassembleInstruction(&vm.chunk, vm.ip);
            }

            const instruction: z.OpCode = @enumFromInt(vm.read_byte());
            switch (instruction) {
                .OP_RETURN => {
                    z.printValue(vm.pop());
                    z.print("\n", .{});
                    return .OK;
                },

                .OP_CONSTANT => {
                    const constant = vm.read_constant();
                    vm.push(constant);
                },

                .OP_ADD => vm.binary_op('+'),
                .OP_SUBTRACT => vm.binary_op('-'),
                .OP_MULTIPLY => vm.binary_op('*'),
                .OP_DIVIDE => vm.binary_op('/'),

                .OP_NEGATE => {
                    vm.push(-vm.pop());
                },
            }
        }
    }

    /// in lieu of the BINARY_OP macro, op is a single char like '+' or '*'
    // maybe a way to do this by metaprogramming? idk
    fn binary_op(vm: *VM, op: u8) void {
        const b = vm.pop();
        const a = vm.pop();

        switch (op) {
            '+' => vm.push(a + b),
            '-' => vm.push(a - b),
            '*' => vm.push(a * b),
            '/' => vm.push(a / b),
            else => {},
        }
    }

    fn read_byte(vm: *VM) u8 {
        // #define READ_BYTE() (*vm.ip++)

        defer vm.ip += 1;
        return vm.chunk.code.items[vm.ip];
    }

    fn read_constant(vm: *VM) z.Value {
        // defer vm.ip += 1;
        return vm.chunk.constants.values.items[vm.read_byte()];
        // return vm.chunk.constants.values.items[vm.ip - 1]; // off by 1?
    }

    pub fn free() void {}
};
