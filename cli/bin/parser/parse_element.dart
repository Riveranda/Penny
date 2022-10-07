/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../master_imports.dart';

abstract class ParseElement {
  late ParseElement parent;
  get getParent => parent;

  late Token start;
  void setStart(Token? start) {
    this.start = start!;
  }

  late Token end;
  set setEnd(end) => this.end = end;

  late List<ParseElement> children = [];

  late List<ParseError> errors = [];


  PennyProgram? getProgram() {
    if (parent is PennyProgram) {
      //return parent;
    } else {
      return parent.getProgram();
    }
    return null;
  }

  void setToken(Token token) {
    end = token;
    start = token;
  }

  bool hasErrors() {
    return errors.isNotEmpty;
  }

  void addError(ErrorType errorType, List<ErrorType> args) {
    addErrorWithToken(errorType, start, args);
  }

  void addErrorWithToken(
      ErrorType errorMessage, Token token, List<ErrorType> args) {
    errors.add(ParseError(token, errorMessage, args));
  }

  T addChild<T>(T element) {
    ParseElement pe = element as ParseElement;
    pe.parent = this;
    children.add(pe);
    return element;
  }

  bool hasError(ErrorType errorMessage) {
    for (var err in errors) {
      if (err.errorType == errorMessage) {
        return true;
      }
    }
    return false;
  }

  void registerFunctions(SymbolTable symbolTable) {
    for (ParseElement child in children) {
      if (child is FunctionDefinitionStatement) {
        if (symbolTable.hasSymbol(child.getName)) {
          child.addError(ErrorType.DUPLICATE_NAME, []);
        } else {
          symbolTable.registerfunction(child.getName, child);
        }
      }
    }
  }

  void validate(SymbolTable symboltable){
    
  }

  List<ParseError> collector = [];
  void verify() {
    SymbolTable symbolTable = SymbolTable();
    registerFunctions(symbolTable);
    validate(symbolTable);
    collectErrors(this);
  }

  void collectErrors(ParseElement parseelement) {
    collector.addAll(parseelement.errors);
    for (ParseElement child in parseelement.children) {
      collectErrors(child);
    }
  }
}
