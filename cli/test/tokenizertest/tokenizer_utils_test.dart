/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'package:test/test.dart';
import '../../bin/master_imports.dart';

final String src = '''func temp(a :int, b:str, c:list) {
                                  var f = a + 5
                                  var g = [1, 3, "hey"]
                                  for i in 5 {
                                    print("Hello")
                                  }
                                }''';
void main() {
  testToken();
  testTokenType();
  testTokenList();
  testPennytokenizerUtilities();
}

void testToken() {
  PennyTokenizer tokenizer = PennyTokenizer(src, false);
  test('tokenizerStringContainsNewLines', () {
    List<String> split = tokenizer.src.split("\n");
    for (var i = 0; i < split.length; i++) {
      split[i] = split[i].trim();
    }
    expect(split[0], "func temp(a :int, b:str, c:list) {");
    expect(
      split[1],
      "var f = a + 5",
    );
    expect(
      split[2],
      "var g = [1, 3, \"hey\"]",
    );
    expect(split[3], "for i in 5 {");
    expect(split[4], "print(\"Hello\")");
    expect(split[5], "}");
    expect(split[6], "}");
  });

  test('testGetLineContent', () {
    Token token = Token(4, 4, 2, 4, "f", TokenType.IDENTIFIER, tokenizer);
    String s = token.getLineContent();
    expect("var f = a + 5", s);
  });
}

// INTENDED TO ENFORCE THERE ARE NO CHANGES
void testTokenType() {
  final Map<String, TokenType> TEST_KEYWORDS = {
    "else": TokenType.ELSE,
    "false": TokenType.FALSE,
    "func": TokenType.FUNCTION,
    "for": TokenType.FOR,
    "in": TokenType.IN,
    "if": TokenType.IF,
    "not": TokenType.NOT,
    "null": TokenType.NULL,
    "print": TokenType.PRINT,
    "return": TokenType.RETURN,
    "true": TokenType.TRUE,
    "var": TokenType.VAR,
    "range": TokenType.RANGE,
    "while": TokenType.WHILE,
    "break": TokenType.BREAK,
    "continue": TokenType.CONTINUE,
    "dowhile": TokenType.DOWHILE,
    "is": TokenType.IS,
    "switch": TokenType.SWITCH,
    "def": TokenType.DEFAULT,
    "and": TokenType.AND,
    "or": TokenType.OR,
    "final": TokenType.FINAL,
    "include": TokenType.INCUDE,
    "void": TokenType.VOID,
    "del": TokenType.DELETE,
    "glob": TokenType.GLOBAL,
    "memorize": TokenType.MEMORIZE, //global storage box. Fetch with recall or forget 
    "recall": TokenType.RECALL,
    "forget": TokenType.FORGET,
    "fall": TokenType.FALL
  };

  test('testTestKeyWordsUpdated', () {
    expect(KEYWORDS.length, TEST_KEYWORDS.length,
        reason: "Both lists must be identical.");
  });

  test("testKeywordMap", () {
    TEST_KEYWORDS.forEach((key, value) {
      expect(KEYWORDS[key], value);
    });
  });
}

void testTokenList() {
  PennyTokenizer tokenizer = PennyTokenizer(src, false);
  TokenList tokenList = TokenList(tokenizer);
  test('testTokenListInit', () {
    expect(tokenList.tokens.length, 0,
        reason: "List should initialize as empty");
    expect(tokenList.currentToken, 0,
        reason: "currentToken should initialize to 0");
    expect(tokenList.tokenizer != null, true);
  });

  test('addToken', () {
    tokenList.addToken(TokenType.COMMA, ",", 1, 1, 3, 5);
    tokenList.addToken(TokenType.DOWHILE, "dowhile", 1, 7, 5, 7);
    expect(tokenList.tokens.length, 2);
    expect(tokenList.tokens[0].type, TokenType.COMMA,
        reason: "Tokens should be added correctly, and in order");
    expect(tokenList.tokens[1].type, TokenType.DOWHILE,
        reason: "Tokens should be added correctly, and in order.");
    tokenList.tokens.clear();
  });
  test('testGetCurrentToken', () {
    tokenList.addToken(TokenType.COMMA, ",", 1, 1, 3, 5);
    tokenList.addToken(TokenType.DOWHILE, "dowhile", 1, 7, 5, 7);
    expect(tokenList.getCurrentToken().type, TokenType.COMMA);
    tokenList.currentToken++;
    expect(tokenList.getCurrentToken().type, TokenType.DOWHILE);
    tokenList.reset();
    tokenList.tokens.clear();
  });

  test('testConsumetoken', () {
    tokenList.addToken(TokenType.COMMA, ",", 1, 1, 3, 5);
    tokenList.addToken(TokenType.DOWHILE, "dowhile", 1, 7, 5, 7);
    expect(tokenList.consumeToken().type, TokenType.COMMA);
    expect(tokenList.currentToken, 1);
    expect(tokenList.getCurrentToken().type, TokenType.DOWHILE);
    tokenList.reset();
    tokenList.tokens.clear();
  });

  test('testMatchAndConsume', () {
    tokenList.addToken(TokenType.COMMA, ",", 1, 1, 3, 5);
    tokenList.addToken(TokenType.DOWHILE, "dowhile", 1, 7, 5, 7);
    expect(tokenList.matchAndConsume(TokenType.COMMA), true);
    expect(tokenList.currentToken, 1);
    expect(tokenList.getCurrentToken().type, TokenType.DOWHILE);
    expect(tokenList.matchAndConsumeMultiple([TokenType.FOR, TokenType.BANG_EQUAL]),
        false);
    tokenList.reset();
    expect(
        tokenList.matchAndConsumeMultiple([TokenType.COMMA, TokenType.DOWHILE]), true);
    expect(tokenList.currentToken, 1);
    tokenList.reset();
    tokenList.tokens.clear();
  });

  test('testmatchString', () {
    tokenList.addToken(TokenType.IDENTIFIER, "x", 1, 1, 3, 5);
    expect(tokenList.matchString("x"), true);
    expect(tokenList.matchString("y"), false);
    tokenList.tokens.clear();
    tokenList.addToken(TokenType.COMMA, ",", 1, 1, 3, 5);
    expect(tokenList.matchString(","), false);
    tokenList.tokens.clear();
    tokenList.reset();
  });

  test('testmatchType', () {
    tokenList.addToken(TokenType.COMMA, ",", 1, 1, 3, 5);
    tokenList.addToken(TokenType.DOWHILE, "dowhile", 1, 7, 5, 7);
    expect(tokenList.matchType([TokenType.COMMA, TokenType.BREAK]), true);
    expect(tokenList.matchType([TokenType.WHILE, TokenType.AND]), false);
    tokenList.tokens.clear();
    tokenList.reset();
  });

  test('testhasMoreTokens', () {
    expect(tokenList.hasMoreTokens(), false);
    tokenList.addToken(TokenType.COMMA, ",", 1, 1, 3, 5);
    expect(tokenList.hasMoreTokens(), true);
    tokenList.tokens.clear();
    tokenList.reset();
  });

  test('testlastToken', () {
    tokenList.addToken(TokenType.COMMA, ",", 1, 1, 3, 5);
    tokenList.addToken(TokenType.DOWHILE, "dowhile", 1, 7, 5, 7);
    expect(tokenList.lastToken().type, TokenType.DOWHILE);
    tokenList.tokens.clear;
    tokenList.reset();
  });

  test('testToString', () {
    tokenList.tokens.clear();
    tokenList.reset();
    tokenList.addToken(TokenType.COMMA, ",", 1, 1, 3, 5);
    tokenList.addToken(TokenType.DOWHILE, "dowhile", 1, 7, 5, 7);
    expect(tokenList.toString(), "-->[,]<-- dowhile ");
    tokenList.tokens.clear();
    tokenList.reset();
  });
}

void testPennytokenizerUtilities() {
  PennyTokenizer tokenizer = PennyTokenizer(src, false);

  test('testpeek', () {
    expect(tokenizer.peek(), "f");
  });

  test('testisAlphaNumeric', () {
    expect(tokenizer.isAlphaNumeric("a"), true);
    expect(tokenizer.isAlphaNumeric("1"), true);
    expect(tokenizer.isAlphaNumeric("11"), false,
        reason: "Must be a character");
    expect(tokenizer.isAlphaNumeric("%"), false);
  });

  test('testtakeChar', () {
    expect(tokenizer.takeChar(), "f");
    expect(tokenizer.lineOffset, 1);
    expect(tokenizer.position, 1);
    tokenizer.lineOffset = 0;
    tokenizer.position = 0;
  });

  test('testtokenizationEnd', () {
    expect(tokenizer.tokenizationEnd(), false);
    tokenizer.position = tokenizer.src.length;
    expect(tokenizer.tokenizationEnd(), true);
    tokenizer.position = 0;
  });

  test('testMatchAndConsume', () {
    expect(tokenizer.matchAndconsume("f"), true);
    expect(tokenizer.lineOffset, 1);
    expect(tokenizer.position, 1);
    expect(tokenizer.matchAndconsume("-"), false);
    tokenizer.lineOffset = 0;
    tokenizer.position = 0;
  });

  test('testConsumeWhiteSpace', () {
    tokenizer.src = " for i in range 5:";
    tokenizer.consumeWhiteSpace();
    expect(tokenizer.position, 1);
    tokenizer.position += 3;
    tokenizer.consumeWhiteSpace();
    expect(tokenizer.position, 5);
    tokenizer.src = src;
    tokenizer.position = 0;
    tokenizer.lineOffset = 0;
    tokenizer.line = 1;
  });
}
