// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

namespace Microsoft.Quantum.Tests {
    open Microsoft.Quantum.AmplitudeAmplification;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Oracles;

    // Here we consider the smallest example of amplitude amplification
    // Suppose we have a single-qubit oracle that prepares the state
    // O |0> = \lambda |1> + \sqrt{1-|\lambda|^2} |0>
    // The goal is to amplify the |1> state
    // We can do this either by synthesizing the reflection about the start and target states ourselves,
    // We can also do it by passing the oracle for state preparation
    internal operation ExampleStatePrepImpl(lambda : Double, idxFlagQubit : Int, qubitStart : Qubit[]) : Unit is Adj + Ctl {
        let rotAngle = 2.0 * ArcSin(lambda);
        Ry(rotAngle, qubitStart[idxFlagQubit]);
    }


    internal function ExampleStatePrep(lambda : Double) : StateOracle {
        return StateOracle(ExampleStatePrepImpl(lambda, _, _));
    }


    // In this minimal example, there are no system qubits, only a single flag qubit.
    // ExampleStatePrep is already of type  StateOracle, so we call
    // StandardAmplitudeAmplification(iterations: Int, stateOracle : StateOracle, idxFlagQubit : Int startQubits: Qubit[]) : ()
    @Test("QuantumSimulator")
    operation CheckAmpAmpByOracle() : Unit {
        use qubits = Qubit[1];

        for nIterations in 0 .. 5 {
            for idx in 1 .. 20 {
                let lambda = IntAsDouble(idx) / 20.0;
                let rotAngle = ArcSin(lambda);
                let idxFlag = 0;
                let startQubits = qubits;
                let stateOracle = ExampleStatePrep(lambda);
                (StandardAmplitudeAmplification(nIterations, stateOracle, idxFlag))(startQubits);
                let successAmplitude = Sin(IntAsDouble(2 * nIterations + 1) * rotAngle);
                let successProbability = successAmplitude * successAmplitude;
                AssertMeasurementProbability([PauliZ], [startQubits[idxFlag]], One, successProbability, "Error: Success probability does not match theory", 1E-10);
                ResetAll(qubits);
            }
        }
    }

    @Test("QuantumSimulator")
    operation CheckAmpAmpObliviousByOraclePhases() : Unit {
        use qubits = Qubit[1];

        for nIterations in 0 .. 5 {
            let phases = StandardReflectionPhases(nIterations);

            for idx in 0 .. 20 {
                let rotAngle = (IntAsDouble(idx) * PI()) / 20.0;
                let idxFlag = 0;
                let auxRegister = qubits;
                let systemRegister = [];
                let ancillaOracle = DeterministicStateOracle(Exp([PauliY], rotAngle * 0.5, _));
                let signalOracle = ObliviousOracle(NoOp);
                (ObliviousAmplitudeAmplificationFromStatePreparation(phases, ancillaOracle, signalOracle, idxFlag))(auxRegister, systemRegister);
                let successAmplitude = Sin((IntAsDouble(2 * nIterations + 1) * rotAngle) * 0.5);
                let successProbability = successAmplitude * successAmplitude;
                AssertMeasurementProbability([PauliZ], [auxRegister[idxFlag]], One, successProbability, "Error: Success probability does not match theory", 1E-10);
                ResetAll(qubits);
            }
        }
    }

    @Test("QuantumSimulator")
    operation CheckAmpAmpTargetStateReflectionOracle() : Unit {
        use qubits = Qubit[1];

        for idx in 0 .. 20 {
            let rotangle = (IntAsDouble(idx) * PI()) / 20.0;
            let targetStateReflection = TargetStateReflectionOracle(0);
            let success = Cos(0.5 * rotangle) * Cos(0.5 * rotangle);
            H(qubits[0]);
            targetStateReflection!(rotangle, qubits);
            AssertMeasurementProbability([PauliX], qubits, Zero, success, "Error: Success probability does not match theory", 1E-10);
            ResetAll(qubits);
        }
    }

    @Test("QuantumSimulator")
    operation TestRotationPhasesAsReflectionPhases() : Unit {
        let rotationPhases = RotationPhases([0.1, 0.2, 0.3, 0.4, 0.5]);
        let reflectionPhases = RotationPhasesAsReflectionPhases(rotationPhases);

        EqualityFactI(Length(reflectionPhases::AboutStart), 3, "Unexpected length of reflection phases");
        EqualityFactI(Length(reflectionPhases::AboutTarget), 3, "Unexpected length of reflection phases");

        Fact(All(NearlyEqualD, Zipped(reflectionPhases::AboutStart, [1.4707963267948965,3.041592653589793,3.041592653589793])), "Unexpected reflection phases");
        Fact(All(NearlyEqualD, Zipped(reflectionPhases::AboutTarget, [-3.241592653589793,-3.241592653589793,-1.0707963267948966])), "Unexpected reflection phases");
    }

}
