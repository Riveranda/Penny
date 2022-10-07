import '../../master_imports.dart';

class MemorizeStatement extends Statement {
  late Expression expression;

  void setExpression(Expression expression) {
    this.expression = addChild(expression);
  }

  @override
  void execute(PennyRuntime runtime) {
    runtime.setGlobalStorage = expression.evaluate(runtime);
  }

  @override
  void validate(SymbolTable symbolTable) {
    expression.validate(symbolTable);
  }
}
