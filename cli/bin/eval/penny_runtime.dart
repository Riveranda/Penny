/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

class PennyRuntime<T> {
  List<Map<String, T>> scopes = [];
  
  Object? globalStorage;
  Object? get getGlobalStorage => globalStorage;

  set setGlobalStorage(Object? globalStorage) =>
      this.globalStorage = globalStorage;

  PennyRuntime() {
    Map<String, T> globalScope = {};
    scopes.add(globalScope);
  }
  Object? getValue(String name) {
    for (var scope in scopes) {
      if (scope.containsKey(name)) {
        return scope[name];
      }
    }
    return null;
  }

  void setValue(String variableName, T val) {
    for (Map<String, T> scope in scopes) {
      if (scope.containsKey(variableName)) {
        scope[variableName] = val;
      }
    }
    scopes.last[variableName] = val;
  }

  void pushScope() {
    scopes.add({});
  }

  void popScope() {
    scopes.removeLast();
  }
}
