/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'package:test/test.dart';
import '../../bin/master_imports.dart';


void main() {
  testParseError();
}

void testParseError() {
  PennyTokenizer tokenizer = PennyTokenizer("int a = 5", true);
  TokenList tokenList = tokenizer.tokenList;
  ParseError error = ParseError(
      tokenList.lastToken(),
      ErrorType.UNEXPECTED_TOKEN,
      [ErrorType.ARG_MISMATCH, ErrorType.BAD_TYPE_NAME]);
  test("testParseErrorMessage", () {
    expect(error.message,
        'Unexpected Token. Wrong number of arguments. Bad Type Name.');
  });

  test("testParseErrorFullMessage", () {
    expect(error.getFullMessage(),
        "Line 1:int a = 5\n               ^\n\nError: Unexpected Token. Wrong number of arguments. Bad Type Name.");
  });

  test("testParseErrorExceptionThrown", () {
    try {
      throwParseErrorException([error, error]);
    } on ParseErrorException catch (e) {
      expect(e.makeMessage(),
          "${error.getFullMessage()}\n\n${error.getFullMessage()}\n\n");
      expect(e.makeMessage(),
          "Line 1:int a = 5\n               ^\n\nError: Unexpected Token. Wrong number of arguments. Bad Type Name.\n\nLine 1:int a = 5\n               ^\n\nError: Unexpected Token. Wrong number of arguments. Bad Type Name.\n\n");
    }
  });
}

void throwParseErrorException(List<ParseError> errors) {
  throw ParseErrorException(errors);
}
