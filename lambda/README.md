# Lambda Function

## Building Lambda Functions:

1. Runtime: you need to pick from an available runtime or bring your own. This is the environment
   you code will run in.
2. Permissions: If your lambda needs to perform some API calls, then you will need to attach a role
   to do so.
3. Networking: You can - Optionally - define a VPC, subnet, and security groups your functions are
   part of.
4. Resources: Defining the amount of available memory will allocate how much CPU and RAM you code
   gets.
5. Trigger: What's going to alert your lambda function to start? Defining a trigger will kick Lambda
   off it that event occurs.
