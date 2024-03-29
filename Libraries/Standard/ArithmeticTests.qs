// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

namespace Microsoft.Quantum.ArithmeticTests {
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;


    operation InPlaceXorTestHelper (testValue : Int, numberOfQubits : Int) : Unit {
        use register = Qubit[numberOfQubits];
        let registerLE = LittleEndian(register);
        ApplyXorInPlace(testValue, registerLE);
        let measuredValue = MeasureInteger(registerLE);
        EqualityFactI(testValue, measuredValue, $"Did not measure the integer we expected.");
    }

    @Test("QuantumSimulator")
    operation CheckApplyXorInPlace() : Unit {
        ApplyToEach(InPlaceXorTestHelper, [(63, 6), (42, 6)]);
    }


    operation IncrementByIntegerTestHelper (summand1 : Int, summand2 : Int, numberOfQubits : Int) : Unit {
        use register = Qubit[numberOfQubits];
        let registerLE = LittleEndian(register);
        ApplyXorInPlace(summand1, registerLE);
        IncrementByInteger(summand2, registerLE);
        let expected = ModulusI(summand1 + summand2, 2 ^ numberOfQubits);
        let actual = MeasureInteger(registerLE);
        EqualityFactI(expected, actual, $"Expected {expected}, got {actual}");
    }


    /// # Summary
    /// Exhaustively tests Microsoft.Quantum.Artihmetic.IncrementByInteger
    /// on 4 qubits
    @Test("QuantumSimulator")
    operation CheckIncrementByInteger() : Unit {
        let numberOfQubits = 4;

        for summand1 in [0, 3, 9, 2 ^ numberOfQubits - 1] {
            for summand2 in [-2 ^ numberOfQubits, -1, 0, 15, 32, 2 ^ numberOfQubits] {
                IncrementByIntegerTestHelper(summand1, summand2, numberOfQubits);
            }
        }
    }


    operation IncrementByModularIntegerHelper (summand1 : Int, summand2 : Int, modulus : Int, numberOfQubits : Int) : Unit {
        use register = Qubit[numberOfQubits];
        let registerLE = LittleEndian(register);
        ApplyXorInPlace(summand1, registerLE);
        IncrementByModularInteger(summand2, modulus, registerLE);
        let expected = ModulusI(summand1 + summand2, modulus);
        let actual = MeasureInteger(registerLE);
        EqualityFactI(expected, actual, $"Expected {expected}, got {actual}");

        use controls = Qubit[2];
        ApplyXorInPlace(summand1, registerLE);
        Controlled IncrementByModularInteger(controls, (summand2, modulus, registerLE));
        let actual2 = MeasureInteger(registerLE);
        EqualityFactI(summand1, actual2, $"Expected {summand1}, got {actual2}");

        // now set all controls to 1
        ApplyXorInPlace(summand1, registerLE);
        (ControlledOnInt(0, IncrementByModularInteger(summand2, modulus, _)))(controls, registerLE);
        let actual3 = MeasureInteger(registerLE);
        EqualityFactI(expected, actual3, $"Expected {expected}, got {actual3}");
        // restore controls back to |0⟩
    }


    /// # Summary
    /// Tests Microsoft.Quantum.Arithmetic.IncrementByModularInteger
    /// on 4 qubits with modulus 13
    @Test("QuantumSimulator")
    operation CheckIncrementByModularInteger() : Unit {
        let numberOfQubits = 4;
        let modulus = 13;
        let scenarios = [0, 6, modulus - 2, modulus - 1];

        for summand1 in scenarios {
            for summand2 in scenarios {
                IncrementByModularIntegerHelper(summand1, summand2, modulus, numberOfQubits);
            }
        }
    }


    operation MultiplyAndAddByModularIntegerTestHelper (summand : Int, multiplier1 : Int, multiplier2 : Int, modulus : Int, numberOfQubits : Int) : Unit {
        use register = Qubit[numberOfQubits * 2];
        let summandLE = LittleEndian(register[0 .. numberOfQubits - 1]);
        let multiplierLE = LittleEndian(register[numberOfQubits .. 2 * numberOfQubits - 1]);

        ApplyXorInPlace(summand, summandLE);
        ApplyXorInPlace(multiplier1, multiplierLE);
        MultiplyAndAddByModularInteger(multiplier2, modulus, multiplierLE, summandLE);

        let expected = ModulusI(summand + multiplier1 * multiplier2, modulus);
        let actual = MeasureInteger(summandLE);
        let actualMult = MeasureInteger(multiplierLE);
        EqualityFactI(expected, actual, $"Expected {expected}, got {actual}");
        EqualityFactI(multiplier1, actualMult, $"Expected {multiplier1}, got {actualMult}");
    }


    /// # Summary
    /// Tests Microsoft.Quantum.Canon.ModularAddProductLE
    /// on 4 qubits with modulus 13
    @Test("QuantumSimulator")
    operation CheckMultiplyAndAddByModularInteger() : Unit {
        let numberOfQubits = 4;
        let modulus = 13;
        let scenarios = [0, 6, modulus - 2, modulus - 1];

        for summand in scenarios {
            for multiplier1 in scenarios {
                for multiplier2 in scenarios {
                    MultiplyAndAddByModularIntegerTestHelper(summand, multiplier1, multiplier2, modulus, numberOfQubits);
                }
            }
        }
    }


    operation MultiplyByModularIntegerTestHelper (multiplier1 : Int, multiplier2 : Int, modulus : Int, numberOfQubits : Int) : Unit {
        use register = Qubit[numberOfQubits];

        if (IsCoprimeI(multiplier2, modulus)) {
            let multiplierLE = LittleEndian(register);
            ApplyXorInPlace(multiplier1, multiplierLE);
            MultiplyByModularInteger(multiplier2, modulus, multiplierLE);
            let expected = ModulusI(multiplier1 * multiplier2, modulus);
            let actualMult = MeasureInteger(multiplierLE);
            EqualityFactI(expected, actualMult, $"Expected {expected}, got {actualMult}");
        }
    }


    /// # Summary
    /// Tests Microsoft.Quantum.Canon.ModularMultiplyByConstantLE
    /// on 4 qubits with modulus 13
    @Test("QuantumSimulator")
    operation CheckMultiplyByModularInteger() : Unit {
        let numberOfQubits = 4;
        let modulus = 13;
        let scenarios = [0, 6, modulus - 2, modulus - 1];

        for multiplier1 in scenarios {
            for multiplier2 in scenarios {
                MultiplyByModularIntegerTestHelper(multiplier1, multiplier2, modulus, numberOfQubits);
            }
        }
    }

}
