/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../../master_imports.dart';

class FunctionDefinitionStatement<T> extends Statement{
  String name = "";

  set setName(String name) => this.name = name;
  String get getName => name;

  PennyType? type;
  PennyType? get getType => type;

  List<PennyType> argumentTypes = [];
  List<String> argumentNames = [];
  List<Statement>? body;

  void setType(TypeLiteral? literal) {
    if (literal == null) {
      type = PennyType(PenType.NULL);
    } else {
      addChild(literal);
      type = literal.getType();
    }
  }

  void addParameter(String name, TypeLiteral? typeLiteral) {
    argumentNames.add(name);
    if (typeLiteral == null) {
      argumentTypes.add(PennyType(PenType.OBJECT));
    } else {
      addChild(typeLiteral);
      argumentTypes.add(typeLiteral.getType());
    }
  }

  String getParameterName(int i) => argumentNames.elementAt(i);

  PennyType getParameterType(int i) => argumentTypes.elementAt(i);

  int getParameterCount() => argumentNames.length;

  void setBody(List<Statement> statements) {
    body = [];
    for (Statement statement in statements) {
      body?.add(addChild(statement));
    }
  }

  @override
  void validate(SymbolTable symboltable) {
    symboltable.pushScope();
    for (int i = 0; i < getParameterCount(); i++) {
      if (symboltable.hasSymbol(getParameterName(i))) {
        addError(ErrorType.DUPLICATE_NAME, []);
      } else {
        symboltable.registerSymbol(getParameterName(i), getParameterType(i));
      }
    }
    if (body != null) {
      for (Statement statement in body!) {
        statement.validate(symboltable);
      }
    }
    symboltable.popScope();
    if (type?.type != PenType.VOID) {
      if (!validateReturnCoverage(body)) {
        addError(ErrorType.MISSING_RETURN_STATEMENT, []);
      }
    }
  }

  T? invoke(PennyRuntime runtime, List<T> args) {
    runtime.pushScope();
    int parameterCount = getParameterCount();
    for (int i = 0; i < parameterCount; i++) {
      runtime.setValue(getParameterName(i), args.elementAt(i));
    }
    T? returnVal;
    try {
      if (body != null) {
        for (Statement statement in body!) {
          statement.execute(runtime);
        }
      }
    } on ReturnException catch (re) {
      returnVal = re.getValue as T;
    } finally {
      runtime.popScope();
    }
    return returnVal;
  }

  @override
  void execute(PennyRuntime runtime) {}

  bool validateReturnCoverage(List<Statement>? statements) {
    //TODO Implement
    return true;
  }
}
