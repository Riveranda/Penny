/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'package:test/test.dart';
import '../../bin/master_imports.dart';

final String src =
    'func temp(a :int, b:str, c:list) {\nvar f = a + 5\nvar g = [1, 3, "hey"]\nfor i in 5 {\nprint("Hello")\n}\n} ->';

void main() {
  testScanInteger();
  testScanString();
  testScanIdentifier();
  testScanSyntax();
}

void testScanInteger() {
  test('testScanNumber', () {
    PennyTokenizer tokenizer = PennyTokenizer("12345", false);
    expect(tokenizer.scanNumber(), true);
    Token num = tokenizer.tokenList.getCurrentToken();
    expect(num.type, TokenType.INTEGER);
    expect(num.stringValue, "12345");

    tokenizer = PennyTokenizer("not a number", false);
    expect(tokenizer.scanNumber(), false);
  });

  test('scanNumberFloat', () {
    PennyTokenizer tokenizer = PennyTokenizer("12.3", false);
    expect(tokenizer.scanNumber(), true);
    Token float = tokenizer.tokenList.getCurrentToken();
    expect(float.type, TokenType.FLOAT);
    expect(float.stringValue, "12.3");

    tokenizer = PennyTokenizer("12..3", false);
    expect(tokenizer.scanNumber(), true);
    expect(tokenizer.tokenList.getCurrentToken().type, TokenType.ERROR);

    tokenizer = PennyTokenizer("12.2f", false);
    expect(tokenizer.scanNumber(), true);
    expect(tokenizer.tokenList.getCurrentToken().type, TokenType.FLOAT);

    tokenizer = PennyTokenizer("12f", false);
    expect(tokenizer.scanNumber(), true);
    expect(tokenizer.tokenList.getCurrentToken().type, TokenType.FLOAT);

    tokenizer = PennyTokenizer("12.", false);
    expect(tokenizer.scanNumber(), true);
    expect(tokenizer.tokenList.getCurrentToken().type, TokenType.FLOAT);
  });
}

void testScanString() {
  test("testScanString", () {
    PennyTokenizer tokenizer = PennyTokenizer("\"Hello \"%name%\"\"", false);
    expect(tokenizer.scanString(), true);
    Token str = tokenizer.tokenList.getCurrentToken();
    expect(str.type, TokenType.STRING);
  });

  test('testScanStringInvalid', () {
    PennyTokenizer tokenizer =
        PennyTokenizer("\"This string does not end", false);
    expect(tokenizer.scanString(), true);
    Token str = tokenizer.tokenList.getCurrentToken();
    expect(str.type, TokenType.ERROR);
  });
}

void testScanIdentifier() {
  PennyTokenizer tokenizer;
  test("testAllKeywordTokens", () {
    KEYWORDS.forEach((key, value) {
      tokenizer = PennyTokenizer(key, false);
      expect(tokenizer.scanIdentifier(), true);
      Token token = tokenizer.tokenList.getCurrentToken();
      expect(token.type, value);
      expect(token.stringValue, key);
    });
  });
}

void testScanSyntax() {
  PennyTokenizer tokenizer;
  test('testAllSyntaxTokens', () {
    tokenToStrings.forEach((key, value) {
      tokenizer = PennyTokenizer(value, false);
      tokenizer.scanSyntax();
      Token token = tokenizer.tokenList.getCurrentToken();
      expect(token.type, key);
      expect(token.stringValue, value);
    });
  });

  test('testTokenizerOnManyTokens', () {
    tokenizer = PennyTokenizer(src, true);
    TokenList tokenList = tokenizer.tokenList;
    expect(tokenList.tokens.length, 45);
    List<TokenType> types = [
      TokenType.FUNCTION,
      TokenType.IDENTIFIER,
      TokenType.LEFT_PAREN,
      TokenType.IDENTIFIER,
      TokenType.COLON,
      TokenType.IDENTIFIER,
      TokenType.COMMA,
      TokenType.IDENTIFIER,
      TokenType.COLON,
      TokenType.IDENTIFIER,
      TokenType.COMMA,
      TokenType.IDENTIFIER,
      TokenType.COLON,
      TokenType.IDENTIFIER,
      TokenType.RIGHT_PAREN,
      TokenType.LEFT_BRACE,
      TokenType.VAR,
      TokenType.IDENTIFIER,
      TokenType.EQUAL,
      TokenType.IDENTIFIER,
      TokenType.PLUS,
      TokenType.INTEGER,
      TokenType.VAR,
      TokenType.IDENTIFIER,
      TokenType.EQUAL,
      TokenType.LEFT_BRACKET,
      TokenType.INTEGER,
      TokenType.COMMA,
      TokenType.INTEGER,
      TokenType.COMMA,
      TokenType.STRING,
      TokenType.RIGHT_BRACKET,
      TokenType.FOR,
      TokenType.IDENTIFIER,
      TokenType.IN,
      TokenType.INTEGER,
      TokenType.LEFT_BRACE,
      TokenType.PRINT,
      TokenType.LEFT_PAREN,
      TokenType.STRING,
      TokenType.RIGHT_PAREN,
      TokenType.RIGHT_BRACE,
      TokenType.RIGHT_BRACE,
      TokenType.ARROW,
      TokenType.EOF
    ];

    expect(tokenList.tokens.length, types.length);
    for (var i = 0; i < tokenList.tokens.length; i++) {
      expect(types[i], tokenList.tokens[i].type);
    }
  });
}
