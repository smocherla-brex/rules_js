# Bun TypeScript Example

This example demonstrates how to use Bun as a JavaScript runtime with TypeScript in Bazel.

## Running with Bun

To run the TypeScript code with Bun runtime instead of Node.js, use the custom build flag:

```bash
# Run the binary with Bun runtime
bazel run //examples/bun:main --//js:js_runtime=bun

# Run the test with Bun runtime  
bazel test //examples/bun:bun_runtime_test --//js:js_runtime=bun

# Build and test with Bun runtime
bazel test //examples/bun:main_test --//js:js_runtime=bun
```

## Default Node.js Runtime

Without the flag, it will use the default Node.js runtime:

```bash
# Run with Node.js (default)
bazel run //examples/bun:main

# Test with Node.js (default) - note: will fail because Bun object is not available
bazel test //examples/bun:bun_runtime_test
```

## What This Example Shows

- TypeScript compilation and execution with Bun
- Using Bun-specific APIs like `Bun.version` and `Bun.write()`
- File I/O operations with Bun's built-in APIs
- Testing the output structure and content
- How to switch between Node.js and Bun runtimes using build flags

## Files

- `main.ts` - TypeScript source with Bun-specific APIs
- `test.js` - Test script to validate the generated output
- `package.json` - Package configuration
- `BUILD.bazel` - Bazel build configuration