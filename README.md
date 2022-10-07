# Penny - The Scripting Language

 Penny is a new scripting language currently in development. Developed with Dart, Penny aims to simplify scripting and will support modern language features such as list and map literals, type inference, as well as a new storage pattern not implemented in any mainstream language. 

 Penny is still in early development, but the tokenizer, and expression parsing have been mostly completed.

 Penny files have the extension .pen

## Development Status

![99](https://progress-bar.dev/99?title=Tokenizer)
![95%](https://progress-bar.dev/95?title=Parser)
![20%](https://progress-bar.dev/20?title=Runtime)
![0%](https://progress-bar.dev/0?title=Website)


## Data Types
### Integer: 32 bit integer 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `var x = 12345`

### Float: 32 bit float
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `var x = 12.345`

### Strings
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `var s = "Hello World!"`

### Boolean
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `var b = false`

### List
Penny suports multidimensional arrays which may contain any data-type simultaneously. 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `var l = [1, 2, ["Hello", 1.56], y]`

### Dictionary
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `var d = {1: "One", 2: "Two", 3: "Three"}`

## Explicit types
Penny supports defining objects with explicit typing. Simply follow the name of your object with a colon, and the type. 

```
var x : int = 5

var s : string = "Hello"

func my_func(x :int, y: list, z: string){

}
```

</br>

## Statements

### ***-> For***
The for statement has several different options for iteration
Parenthesis are optional.
```
// Iterate over a range of 5
for i in 5{
    <body>
}

// Iterate over a customized range
for i in range(start[, stop][, step]){
    <body>
}

// Iterate over a list
for i in [1, 2, 5]{
    <body>
}

//Parenthesis are optional
for (i in range(5)){

}
```

### ***-> If/Else If/Else***
Penny supports the standard if, else if and else statements. The else if, and else statements must be attached to an if statement. 
Parenthesis are optional!
```
if boolean_expression{
    <body>
}
else if(boolean_expression){
    <body>
}
else {
    <body>
}
```
### ***-> While***
The while statement works as you'd expect. It will continue iterating until the boolean_expression evaluates to false. 

Optionally, you may include an identifier. The identifier will be created in the while loop's scope if not present already, initialized to zero (if locally created), and will be incrimented for each loop.

Parenthesis are optional!

```
while(boolean_expression){
    <body>
}

while boolean_expression, identifer {
    <body>
    // Identifier incremented.
}
```
### ***-> Do While***
The do while loop is identical to the while loop, but will always execute the body once before checking the boolean expression.

Optionally, you may include an identifier. The identifier will be created in the while loop's scope if not present already, initialized to zero (if locally created), and will be incrimented for each loop.

Like the while loop, an identifer may be included after the "do". Parenthesis are optional.
```
do {
    <body>
} while boolean_expression


//Integer x created inside do's scope, initialized to zero.
do identifier { 
    <body>
    // identifier incrimented at end of loop! x++;
} while [ ( ] boolean_expression [ ) ]


int x = 5
//Paren's used around x this time!
//x from the current scope is used instead, and intial value of 5 is kept. 
do (x) { 
    <body>
    // x is incremeneted as usual
} while(boolean_expression)
```

### ***-> Switch Statement***
The Penny switch statement works contrary to typical implementions. 

Penny does not have default fall through behavior, instead a case will automatically break. If you wish a case to use fallthrough behaviour, use the fall keyword.

Is clauses may have any number of values, each separated by a comma.

Parenthesis are optional.

```
switch  (  literal_expression  )  ){
    is 1{ 
        <body>   //No Fallthrough!
    }
    is 2, 3, 4, 5{ //Multiple values
        <body>
       fall // Fallthrough!
    }
    def{
        <body>    //Default case
    }
}
```

### ***-> Function Definition***
A function may be defined with the func keyword, followed by a name and an argument list. As usual, argument types are optional, but may be explicitely defined with a colon followed by the type. 

Explicit return types follow the function and an arrow operator. The return type is void by default.
The return keyword can be substituted with an arrow operator.
```
func name(x, y, z : list){ //Default void return
    <body> 
}
```
```
func name(x : int, y, z) -> int {
    <body >
    return x + 5;
}
```
```
func name(x : int, y, z) -> int {
    <body >
    -> x + 5; //arrow operator substitutes for return.
```

### ***-> Global Storage Statements***
Penny has a new storage statement which allows you to store any expression in a global expression cache, and then fetch that expression, and its value at a later time. 

There are three keywords associated with this behavior: memorize, recall, and forget. 

**memorize**: Store the expression in the GEC.

**recall**: Retrieve and evaluate the expression in the GEC.

**forget**: Retrieve, evaluate, and then delete the expression in the GEC.
```
// Store the mathematical expression in the GEC
memorize 5+3 - 1 

//Retrieve the expression, and return its evaluation
var x : int = recall 

//Retrieve the expression, return its evaluation, and then clear the GEC
var x : int = forget 
```
### ***-> Print Statement***
Unlike Java we know how to print things here. It's called print....

```
    print("Ooga Booga!")
```