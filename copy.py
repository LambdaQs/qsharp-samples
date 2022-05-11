#!/usr/bin/env python

import glob
from pathlib import Path
import os
import shutil

# Libraries
directory = "submodules/QuantumLibraries/Chemistry/"
target = "Libraries/Chemistry"
for filename in glob.iglob(directory + '**/*.qs', recursive=True):
    shutil.copyfile(filename, os.path.join(target, Path(filename).stem + ".qs"))
directory = "submodules/QuantumLibraries/MachineLearning/"
target = "Libraries/MachineLearning"
for filename in glob.iglob(directory + '**/*.qs', recursive=True):
    shutil.copyfile(filename, os.path.join(target, Path(filename).stem + ".qs"))
directory = "submodules/QuantumLibraries/Numerics/"
target = "Libraries/Numerics"
for filename in glob.iglob(directory + '**/*.qs', recursive=True):
    shutil.copyfile(filename, os.path.join(target, Path(filename).stem + ".qs"))
directory = "submodules/QuantumLibraries/Standard/"
target = "Libraries/Standard"
for filename in glob.iglob(directory + '**/*.qs', recursive=True):
    shutil.copyfile(filename, os.path.join(target, Path(filename).stem + ".qs"))

# Katas
directory = "submodules/QuantumKatas"
target = "Katas"
for dirname in os.listdir(directory):
    d = os.path.join(directory, dirname)
    if os.path.isdir(d):
        for filename in os.listdir(d):
            if filename == "ReferenceImplementation.qs":
                f = os.path.join(d, filename)
                shutil.copyfile(f, os.path.join(target, dirname + ".qs"))

# Contests
directory = "submodules/silq/test/codeforces/summer18/contest"
target = "Contests/summer18"
for filename in os.listdir(directory):
    if filename.endswith(".qs"):
        f = os.path.join(directory, filename)
        shutil.copyfile(f, os.path.join(target, filename))
directory = "submodules/silq/test/codeforces/winter19/contest"
target = "Contests/winter19"
for filename in os.listdir(directory):
    if filename.endswith(".qs"):
        f = os.path.join(directory, filename)
        shutil.copyfile(f, os.path.join(target, filename))
