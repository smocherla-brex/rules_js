// Test script to validate the output
const fs = require('fs');
const path = require('path');

// Read the generated output
const outputPath = path.join(process.cwd(), 'output.json');
let output;

try {
    const data = fs.readFileSync(outputPath, 'utf8');
    output = JSON.parse(data);
} catch (error) {
    console.error('Failed to read or parse output.json:', error);
    process.exit(1);
}

// Validate the structure
const requiredFields = ['greeting', 'bunVersion', 'platform'];
for (const field of requiredFields) {
    if (!(field in output)) {
        console.error(`Missing required field: ${field}`);
        process.exit(1);
    }
}

// Validate the greeting content
if (!output.greeting.includes('Hello, Bun Developer!')) {
    console.error('Greeting does not contain expected text');
    process.exit(1);
}

// Validate that bunVersion is present
if (!output.bunVersion || typeof output.bunVersion !== 'string') {
    console.error('bunVersion should be a non-empty string');
    process.exit(1);
}

// Validate that platform is present
if (!output.platform || typeof output.platform !== 'string') {
    console.error('platform should be a non-empty string');
    process.exit(1);
}

console.log('✅ All tests passed!');
console.log(`Greeting: ${output.greeting}`);
console.log(`Bun Version: ${output.bunVersion}`);
console.log(`Platform: ${output.platform}`);