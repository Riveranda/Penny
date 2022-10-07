/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../symbol_table.dart';
import '../penny_type.dart';
import '../../eval/penny_runtime.dart';
import 'expression.dart';

class IndexExpression extends Expression {
  late String variableName;
  late List<Expression> indexes;

  IndexExpression();

  void setVariableName(String str) {
    variableName = str;
  }

  void setIndexes(List<Expression> list) {
    indexes = list;
  }

  @override
  Object evaluate(PennyRuntime runtime) {
    List<Object> array = runtime.getValue(variableName) as List<Object>;
    for (var i = 0; i < indexes.length; i++) {
      array = array.elementAt(indexes.elementAt(i).evaluate(runtime) as int)
          as List<Object>;
    }
    int index = indexes.last.evaluate(runtime) as int;
    return array.elementAt(index + ((index < 0) ? array.length : 0));
  }

  @override
  PennyType getType() {
    return indexes.first.getType();
  }

  @override
  void validate(SymbolTable symboltable) {
    for (var index in indexes) {
      index.validate(symboltable);
    }
  }
}
