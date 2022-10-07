/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'package:test/test.dart';
import '../../bin/master_imports.dart';


void main() {
  testSymbolTable();
  testFunctionDefinitionStatement();
}

void testFunctionDefinitionStatement()
{
  test("functiondefinitionstatement", (){
    FunctionDefinitionStatement statement = FunctionDefinitionStatement();
    statement.setName = "myfunc";
    TypeLiteral type = TypeLiteral();
    type.setType(PennyType(PenType.NULL));
    statement.setType(type);
    expect(statement.type?.type, PenType.NULL);
    
    type.setType(PennyType(PenType.INT));
    statement.setType(type);
    expect(statement.children.length, 2);

    statement.addParameter("x", type);
    statement.addParameter("y", type);
    statement.addParameter("mynull", null);
    expect(statement.argumentNames[0], "x");
    expect(statement.argumentNames[1], "y");
    expect(statement.argumentNames[2], "mynull");

    expect(statement.argumentTypes[0].type, PenType.INT);
    expect(statement.argumentTypes[1].type, PenType.INT);
    expect(statement.argumentTypes[2].type, PenType.OBJECT);
  });
}

void testSymbolTable() {
  test("testglobalscopeisadded", () {
    var symbolTable = SymbolTable();
    expect(symbolTable.symbolStack.length, 1);
  });

  test("testregisterSymbol", () {
    var symbolTable = SymbolTable();
    PennyType type = PennyType(PenType.INT);
    symbolTable.registerSymbol("x", type);
    expect((symbolTable.symbolStack[0]["x"] as PennyType).type, PenType.INT);
    symbolTable.registerSymbol("y", type);
    expect((symbolTable.symbolStack[0]["y"] as PennyType).type, PenType.INT);
    symbolTable.pushScope();
    symbolTable.registerSymbol("x2", PennyType(PenType.FLOAT));
    expect((symbolTable.symbolStack[1]["x2"] as PennyType).type, PenType.FLOAT);
    symbolTable.popScope();
  });

  test("hasgetsymbol", () {
    var symbolTable = SymbolTable();
    symbolTable.registerSymbol("x", PennyType(PenType.INT));
    expect(symbolTable.hasSymbol("x"), true);
    expect(symbolTable.hasSymbol("y"), false);
    symbolTable.pushScope();
    symbolTable.registerSymbol("x2", PennyType(PenType.FLOAT));
    expect(symbolTable.symbolStack.length, 2);
    expect(symbolTable.hasSymbol("x"), true);
    expect(symbolTable.hasSymbol("y"), false);
    expect(symbolTable.hasSymbol("x2"), true);
    expect(symbolTable.hasSymbol("z"), false);

    PennyType x = symbolTable.getSymbol("x") as PennyType;
    expect(x != null, true);
    PennyType x2 = symbolTable.getSymbol("x2") as PennyType;
    expect(x2 != null, true);

    PenType? xt = symbolTable.getSymbolType("x");
    expect(xt != null, true);
    expect(xt, PenType.INT);
  });
  test("testpopandpushscope", () {
    var symbolTable = SymbolTable();
    symbolTable.pushScope();
    symbolTable.registerSymbol("x", PennyType(PenType.INT));
    expect(symbolTable.symbolStack.length, 2);
    expect(symbolTable.symbolStack[1].containsKey("x"), true);
    symbolTable.popScope();
    expect(symbolTable.symbolStack.length, 1);
    expect(symbolTable.symbolStack[0].containsKey("x"), false);
  });

  test("registerfunction", () {
    var symbolTable = SymbolTable();
    symbolTable.registerfunction("myfunc", FunctionDefinitionStatement());
    symbolTable.pushScope();
    symbolTable.registerfunction(
        "mysecondfunc", FunctionDefinitionStatement());
    expect(symbolTable.symbolStack[0].containsKey("myfunc"), true);
    expect(symbolTable.symbolStack[1].containsKey("mysecondfunc"), true);
  });
}
