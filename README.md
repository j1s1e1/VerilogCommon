# VerilogCommon
Verilog files expected to be shared between multiple projects

This project is intended to serve as a library that can be used for shared code for many of my other projects.

Directories:

Precision   

Top directory containing code for variable precision math functions  

The intent is to provide functions that will perform the samefunctions on different varable types.  The type is defined by two parameters BITS and PRECISION.  There are top level functions like Add Suptract Multiply Divide that use the parameters to select the correct lower level files for different precisions.  This allows the same code to be used for single or half precision calculations by changing the parameters in higher level modules.  These functions are setup to generate one output per clock cycle.  Latency can vary for some functions, which may require additional parameter.  These could also be provided in an additional project package.

Precision/Complex   Provides combined functions for complex versions of other types
Precision/Fixed     Various fixed point values
Precision/Half      16 bit float
Precision/Single    32 bit float

Although the float functions use a lot of resources, the intent is to allow relatively quick experimentation during initial development.  Once an algorithm is working, it can be modified to use fixed point or functions could be replaced by vendor specific libraries.  Note that although the float format follows most IEEE conventions, checking for overflow / underflow etc is not provided.

