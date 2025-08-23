// Simple Bun JavaScript example

function greetUser(user) {
  return `Hello, ${user.name}! You are ${user.age} years old.`;
}

// Create a sample user
const user = {
  name: "Bun Developer",
  age: 25,
};

// Log the greeting
console.log(greetUser(user));

// Demonstrate Bun's built-in APIs
console.log(`Bun version: ${Bun.version}`);
console.log(`Platform: ${process.platform}`);

// Write output to file for testing
const output = JSON.stringify(
  {
    greeting: greetUser(user),
    bunVersion: Bun.version,
    platform: process.platform,
  },
  null,
  2
);

if(process.argv[2]) {
    await Bun.write(process.argv[2], output);
}

