// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
namespace Microsoft.Quantum.Tests {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;

    function Square(x : Int) : Int {
        return x * x;
    }

    operation ApplyOp<'T, 'U>(op : ('T => 'U), input : 'T) : 'U {
        return op(input);
    }

    @Test("ToffoliSimulator")
    operation TestCall() : Unit {
        EqualityFactI(Call(Square, 4), 16, "Call failed with Square.");
    }

    @Test("ToffoliSimulator")
    operation TestToOperation() : Unit {
        let op = FunctionAsOperation(Square);
        EqualityFactI(ApplyOp(op, 3), 9, "ToOperation failed with Square.");
    }

}
