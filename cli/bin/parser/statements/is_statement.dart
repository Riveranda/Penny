/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../../tokenizer/token.dart';
import '../../tokenizer/token_type.dart';
import '../expressions/expression.dart';
import '../symbol_table.dart';
import 'statement.dart';

class IsStatement extends Statement {
  late List<Expression> matches = [];

  late Token token;
  List<Statement> trueStatements = [];

  get getMatches => matches;

  void setMatches(List<Expression> m) {
    for (var e in m) {
      matches.add(addChild(e));
    }
  }

  Token get getToken => token;

  @override
  void setToken(Token token) {
    this.token = token;
  }

  List<Statement> get getTrueStatements => trueStatements;

  set setTrueStatements(List<Statement> trueStatements) =>
      this.trueStatements = trueStatements;

  bool isDefault() {
    return token.type == TokenType.DEFAULT;
  }

  @override
  void validate(SymbolTable symboltable) {
    // TODO: implement validate
  }
}
