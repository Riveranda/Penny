import 'token_list.dart';
import 'token_type.dart';

class PennyTokenizer {
  late TokenList tokenList;
  get getTokens => tokenList;

  String src;
  int position = 0;
  int line = 1;
  int lineOffset = 0;

  PennyTokenizer(this.src, [bool test = true]) {
    tokenList = TokenList(this);
    if (test) {
      tokenize();
    }
  }

  void tokenize() {
    consumeWhiteSpace();
    while (!tokenizationEnd()) {
      scanToken();
      consumeWhiteSpace();
    }
    tokenList.addToken(
        TokenType.EOF, "<EOF>", position, position, line, lineOffset);
  }

  void scanToken() {
    if (scanNumber()) {
      return;
    }
    if (scanString()) {
      return;
    }
    if (scanIdentifier()) {
      return;
    }
    scanSyntax();
  }

  bool scanNumber() {
    if (isDigit(peek())) {
      int start = position;
      String numStr = "";
      bool decimalFound = false;
      while (!tokenizationEnd() &&
          (isDigit(peek()) || peek() == '.' || peek() == "f")) {
        if (peek() == '.') {
          if (decimalFound) {
            tokenList.addToken(
                TokenType.ERROR,
                "Multiple . found in float token.",
                start,
                position,
                line,
                lineOffset);
          }
          decimalFound = true;
        }
        if (matchAndconsume("f")) {
          decimalFound = true;
          break;
        }
        numStr += takeChar();
      }
      if (!decimalFound) {
        tokenList.addToken(
            TokenType.INTEGER, numStr, start, position, line, lineOffset);
      } else {
        tokenList.addToken(
            TokenType.FLOAT, numStr, start, position, line, lineOffset);
      }
      return true;
    }
    return false;
  }

  bool scanString() {
    if (peek() == '"') {
      int start = position;
      do {
        matchAndconsume('\\');
        if (!tokenizationEnd()) {
          takeChar();
        }
      } while (!tokenizationEnd() && peek() != '"');
      String value = src.substring(++start, position);
      if (!tokenizationEnd()) {
        takeChar();
        tokenList.addToken(
            TokenType.STRING, value, start, position, line, lineOffset);
      } else {
        tokenList.addToken(
            TokenType.ERROR, value, start, position, line, lineOffset);
      }
      return true;
    }
    return false;
  }

  bool scanIdentifier() {
    if (isAlpha(peek())) {
      int start = position;
      while (isAlphaNumeric(peek()) && !tokenizationEnd()) {
        takeChar();
      }
      String value = src.substring(start, position);
      if (KEYWORDS.containsKey(value)) {
        tokenList.addToken(
            KEYWORDS[value]!, value, start, position, line, lineOffset);
      } else {
        tokenList.addToken(
            TokenType.IDENTIFIER, value, start, position, line, lineOffset);
      }
      return true;
    }
    return false;
  }

//Scans all syntax tokens located in stringToTokenObj in tokentype.dart
  void scanSyntax() {
    int start = position;

    TokenType? token;
    if (stringToTokenObj.containsKey(peek())) {
      var c = takeChar();
      Map<String, TokenType>? map = stringToTokenObj[c];
      if (map != null && map.containsKey(peek())) {
        token = map[peek()];
        takeChar();
      } else {
        token = map?["DEF"];
      }
    }
    if (token != null) {
      if (token == TokenType.MULTILINE) {
        // Multiline comment support
        while (!(src[position - 1] == '*') &&
            peek() == '/' &&
            !tokenizationEnd()) {
          takeChar();
        }
        matchAndconsume('/');
      } else {
        String? s = tokenToStrings[token];
        if (s != null) {
          tokenList.addToken(token, s, start, position, line, lineOffset);
        } else {
          tokenList.addToken(
              TokenType.ERROR,
              "<Unexpected Token: [{takeChar()}]}",
              start,
              position,
              line,
              lineOffset);
        }
      }
    } else {
      tokenList.addToken(TokenType.ERROR, "<Unexpected Token: [{takeChar()}]}",
          start, position, line, lineOffset);
    }
  }

//==============
// UTILITY
//==============

  void consumeWhiteSpace() {
    while (!tokenizationEnd()) {
      String c = peek();
      if (c == ' ' || c == '\r' || c == '\t') {
        lineOffset++;
        position++;
        continue;
      } else if (c == '\n') {
        position++;
        line++;
        lineOffset = 0;
      }
      break;
    }
  }

  String peek() {
    if (tokenizationEnd()) return "\0";
    return src[position];
  }

  bool isAlphaNumeric(String c) => (isAlpha(c) || isDigit(c));

  final alpha = RegExp('[A-Za-z]');
  bool isAlpha(String c) {
    if (c.length > 1) {
      return false;
    }
    if (c == "_") {
      return true;
    }

    if (alpha.hasMatch(c)) {
      return true;
    }
    return false;
  }

  bool isDigit(String s) {
    if (s.length > 1) {
      return false;
    }
    return (s.codeUnitAt(0) ^ 0x30) <= 9;
  }

  String takeChar() {
    String c = src[position];
    lineOffset++;
    position++;
    return c;
  }

  bool tokenizationEnd() => position >= src.length;

  bool matchAndconsume(String c) {
    if (peek() == c) {
      takeChar();
      return true;
    }
    return false;
  }
}
