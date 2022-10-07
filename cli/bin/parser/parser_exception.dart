/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../tokenizer/token.dart';

class ParseErrorException implements Exception {
  final List<ParseError> errors;
  ParseErrorException(this.errors);

  @override
  String toString() => makeMessage();

  String makeMessage() {
    String errorMessage = "";
    for (var err in errors) {
      errorMessage += "${err.getFullMessage()}\n\n";
    }
    return errorMessage;
  }
}

class ParseError {
  final Token _location;
  Token get location => _location;

  final ErrorType _errorType;
  ErrorType get errorType => _errorType;

  String _message = "";
  String get message => _message;

  ParseError(this._location, this._errorType, List<ErrorType> args) {
    if (errorTypetoString.containsKey(_errorType)) {
      _message += "${errorTypetoString[errorType]!}. ";
    }
    args.forEach((arg) {
      if (errorTypetoString.containsKey(arg)) {
        _message += "${errorTypetoString[arg]!}. ";
      }
    });
    _message = _message.trim();
  }

  String getFullMessage() {
    String s = "";
    String lineStart = "Line ${location.getLine}:";
    s += lineStart;
    s += location.getLineContent();
    s += "\n";
    for (var i = 0; i < lineStart.length + location.lineOffset - 1; i++) {
      s += " ";
    }
    s += "^\n\n";
    s += "Error: ";
    s += _message;
    return s;
  }
}

Map<ErrorType, String> errorTypetoString = {
  ErrorType.UNTERMINATED_LIST: "Unterminated list literal",
  ErrorType.UNTERMINATED_ARG_LIST: "Unterminated argument list",
  ErrorType.BAD_TYPE_NAME: "Bad Type Name",
  ErrorType.DUPLICATE_NAME: "This name is already used in this program",
  ErrorType.INCOMPATIBLE_TYPES: "Incompatible types",
  ErrorType.UNKNOWN_NAME: "This symbol is not defined",
  ErrorType.ARG_MISMATCH: "Wrong number of arguments",
  ErrorType.MISSING_RETURN_STATEMENT: "Missing return statement in function",
  ErrorType.UNEXPECTED_TOKEN: "Unexpected Token"
};

enum ErrorType {
  UNTERMINATED_LIST,
  UNTERMINATED_ARG_LIST,
  BAD_TYPE_NAME,
  DUPLICATE_NAME,
  INCOMPATIBLE_TYPES,
  UNKNOWN_NAME,
  ARG_MISMATCH,
  MISSING_RETURN_STATEMENT,
  UNEXPECTED_TOKEN
}
