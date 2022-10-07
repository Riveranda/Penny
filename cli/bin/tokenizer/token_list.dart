/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'penny_tokenizer.dart';
import "token.dart";
import 'token_type.dart';

class TokenList {
  final PennyTokenizer _tokenizer;
  List<Token> tokens = List<Token>.empty(growable: true);
  int currentToken = 0;
  get tokenizer => _tokenizer;

  get getTokens => tokens;

  set setTokens(tokens) => this.tokens = tokens;

  set setCurrentToken(currentToken) => this.currentToken = currentToken;

  TokenList(this._tokenizer);

  void addToken(TokenType eof, String stringValue, int start, int end, int line,
      int lineOffset) {
    tokens.add(Token(start, end, line, lineOffset - (end - start), stringValue,
        eof, _tokenizer));
  }

  Token getCurrentToken() {
    return tokens.elementAt(currentToken);
  }

  Token consumeToken() {
    return tokens.elementAt(currentToken++);
  }

  bool matchAndConsume(TokenType type) {
    if (match(type)) {
      consumeToken();
      return true;
    }
    return false;
  }

  bool matchAndConsumeMultiple(List<TokenType> types) {
    if (matchType(types)) {
      consumeToken();
      return true;
    }
    return false;
  }

  bool match(TokenType type) {
    return getCurrentToken().type == type;
  }

  bool matchMultiple(List<TokenType> types) {
    for (var type in types) {
      if (getCurrentToken().type == type) {
        return true;
      }
    }
    return false;
  }

  bool matchString(String identifier) {
    if (getCurrentToken().type == TokenType.IDENTIFIER &&
        getCurrentToken().stringValue == identifier) {
      return true;
    }
    return false;
  }

  bool matchType(List<TokenType> types) {
    for (var i = 0; i < types.length; i++) {
      if (getCurrentToken().type == types[i]) {
        return true;
      }
    }
    return false;
  }

  void reset() {
    currentToken = 0;
  }

  bool hasMoreTokens() {
    return (currentToken <= (tokens.length - 1)) &&
        getCurrentToken().type != TokenType.EOF;
  }

  Token lastToken() {
    return tokens.last;
  }

  @override
  String toString() {
    String s = "";
    for (var i = 0; i < tokens.length; i++) {
      var token = tokens.elementAt(i);
      if (i == currentToken) {
        s += "-->[";
      }
      s += token.stringValue;
      if (i == currentToken) {
        s += "]<--";
      }
      s += " ";
    }
    return s;
  }
}
