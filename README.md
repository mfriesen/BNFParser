## BNFParser

**BNFParser** is a [**Backus-Naur Form**](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_Form) Framework for Objective C written by **Mike Friesen** released under the **Apache 2 Open Source License**.

An [**Java**](https://github.com/mfriesen/BNFParserJava) version is also available.

**BNFParser** was inspired by the framework [ParseKit](http://parsekit.com/) by Todd Ditchendorf.

The **BNFParser** Framework offers 3 basic services of general interest to developers:

1. String Tokenization via the `BNFTokenizerFactory` and `BNFToken` classes

2. Property Key/Value mapper via `PropertyParser`

3. Text Parsing via Grammars via **BNFParser** [see grammar syntax](http://parsekit.com/grammars.html)

### 1. String Tokenization

The string tokenizer breaks down any string into a series of letter/number/symbols for easy processing.

#### How do I use it? 
    NSString *text = @"The cow jumped over the moon!";
    BNFTokenizerFactory *factory = [[BNFTokenizerFactory alloc] init];
    BNFToken *token = [factory tokens:text];
    while (token) {
      NSLog(@"TOKEN %@", [token stringValue]);
      token = [token nextToken];
    }

### 2. PropertyParser

Uses the string tokenizer to parse a string and create key/value mapping based on the `'='` symbol.

#### How do I use it?

    NSString *text = @"sample key = sample value";
    PropertyParser *propertyParser = [[PropertyParser alloc] init];
    NSMutableDictionary *keyValueMap = [propertyParser parse:text];
    STAssertNotNil([keyValueMap objectForKey:@"sample key"], @"expect key exists");

### 3. Text Parsing via Grammars

**BNFParser** currently only ships with a **JSON grammar** so the example are based on that.

#### How do I use it?

    // Create String Tokens
    NSString *text = @"{ \"key\":\"value\"}";
    BNFTokenizerFactory *factory = [[BNFTokenizerFactory alloc] init];
    BNFToken *token = [factory tokens:text];
    
    // Create Backus-Naur Form State Definitions
    BNFStateDefinitionFactory *sdf = [[BNFStateDefinitionFactory alloc] init];
    NSMutableDictionary *map = [stateDefinitionFactory json];
    
    // Run Tokens through Parser
    BNFParser *parser = [[BNFParser alloc] initWithStateDefinitions:dic];
    BNFParseResult *result = [parser parse:token];
    
    // Verify results
    
    // verify text passes grammar:
    STAssertTrue([result success], @"assume success"); 
    
    // the "first" token, same as the token returned from the tokenizer factory:
    STAssertNotNil([result top], @"assume not nil"); 
    
    // the "first" error token, this token and any afterwards are considered to not have passed the grammar:
    STAssertNil([result error], @"assume nil");  

### Bugs and Feedback

For bugs, questions and discussions please use the [Github Issues](https://github.com/Netflix/BNFParser/issues).

### Contributing

We love contributions! If you'd like to contribute please submit a pull request via Github. 

### In the Wild

#### Applications (OS X)

[GoJSON](http://gobits.ca) - JSON Editor

### LICENSE

This library is distributed under the **Apache 2 Open Source License**.