/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'penny_type.dart';
import 'statements/function_definition_statement.dart';

class SymbolTable{
  List<Map<String, Object>> symbolStack = [];

  SymbolTable() {
    Map<String, Object> globalScope = {};
    symbolStack.add(globalScope);
  }

  bool hasSymbol(String name) {
    return getSymbol(name) != null;
  }

  Object? getSymbol(String name) {
    for (final Map<String, Object> element in symbolStack.reversed) {
      if (element.containsKey(name)) {
        return element[name];
      }
    }
    return null;
  }

  void registerfunction(String name, FunctionDefinitionStatement func) {
    symbolStack.last[name] = func;
  }
  void registerSymbol(String name, PennyType type) {
    symbolStack.last[name] = type;
  }

  PenType? getSymbolType(String name) {
    return (getSymbol(name) as PennyType).type;
  }

  void pushScope() {
    symbolStack.add({});
  }

  void popScope() {
    symbolStack.removeLast();
  }
}
