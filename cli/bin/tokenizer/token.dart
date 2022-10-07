/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'token_type.dart';
import 'penny_tokenizer.dart';

class Token {
  int start;
  int end;
  int line;
  int get getLine => line;
  int lineOffset;
  String stringValue;
  TokenType type;
  final PennyTokenizer _tokenizer;

  Token(this.start, this.end, this.line, this.lineOffset, this.stringValue,
      this.type, this._tokenizer);

  String getLineContent() {
    var lines = _tokenizer.src.split("\n");
    return lines[line - 1].trim();
  }
}
