/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../../master_imports.dart';

class PennyProgram extends Statement {
  String output = "";
  List<Statement> statements = [];
  Map<String, FunctionDefinitionStatement> functions = {};
  Expression? expression;

  void print<T>(T v) {
    output += "${T.toString()}\n";
  }

  void addStatement(Statement child) {
    Statement statement = addChild(child);
    statements.add(statement);
    if (statement is FunctionDefinitionStatement) {
      functions[statement.getName] = statement;
    }
  }

  void setExpression(Expression expression) {
    expression = addChild(expression);
  }

  bool isExpression() {
    return expression != null;
  }

  FunctionDefinitionStatement? getfunction(String name) {
    return functions[name];
  }

  void executeProgram() {
    execute(PennyRuntime());
  }

  @override
  void execute(PennyRuntime runtime) {
    if (expression != null) {
      print(expression?.evaluate(runtime));
    } else {
      for (Statement statement in statements) {
        statement.execute(runtime);
      }
    }
  }

  @override
  void validate(SymbolTable symbolTable) {
    if (expression != null) {
      expression?.validate(symbolTable);
    } else {
      for (Statement statement in statements) {
        statement.validate(symbolTable);
      }
    }
  }
}
