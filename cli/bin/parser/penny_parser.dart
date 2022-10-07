/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import '../master_imports.dart';

class PennyParser {
  late TokenList tokens;
  FunctionDefinitionStatement? currentFunctionDefinition;

  PennyProgram parse(String source) {
    tokens = PennyTokenizer(source).getTokens;
    PennyProgram program = PennyProgram();
    program.setStart(tokens.getCurrentToken());
    Expression expression = parseExpression();
    if (expression is FunctionCallExpression) {
      program.addStatement(FunctionCallStatement(expression));
    }

    if (tokens.hasMoreTokens()) {
      tokens.reset();
      while (tokens.hasMoreTokens()) {
        program.addStatement(parseProgramStatement());
      }
    } else {
      program.setExpression(expression);
    }
    if (tokens.hasMoreTokens()) {
      program.setEnd = tokens.getCurrentToken();
    }
    return program;
  }

  Statement parseProgramStatement() {
    if (tokens.match(TokenType.PRINT)) {
      return parsePrintStatement();
    }
    if (tokens.match(TokenType.FOR)) {
      return parseForStatement();
    }
    if (tokens.match(TokenType.IF)) {
      return parseIfStatement();
    }
    if (tokens.match(TokenType.VAR)) {
      return parseVarStatement();
    }
    if (tokens.match(TokenType.IDENTIFIER)) {
      Token variableName = tokens.consumeToken();
      if (tokens.matchAndConsume(TokenType.EQUAL)) {
        return parseAssignmentStatement(variableName);
      } else if (tokens.match(TokenType.LEFT_BRACKET)) {
        return parseArrayAssignmentStatement(variableName);
      } else if (tokens.match(TokenType.LEFT_PAREN)) {
        return FunctionCallStatement(parseFunctionExpression(variableName));
      }
    }
    if (tokens.match(TokenType.FUNCTION)) {
      return parseFunctionDeclarationStatement();
    }
    if (tokens.matchMultiple([TokenType.RETURN, TokenType.ARROW])) {
      return parseReturnStatement();
    }
    if (tokens.match(TokenType.WHILE)) {
      return parseWhileStatement();
    }
    if (tokens.match(TokenType.BREAK)) {
      return parseBreakStatement();
    }
    if (tokens.match(TokenType.CONTINUE)) {
      return parseContinueStatement();
    }
    if (tokens.match(TokenType.CONTINUE)) {
      return parseDoWhileStatement();
    }
    if (tokens.match(TokenType.SWITCH)) {
      return parseSwitchStatement();
    }
    if (tokens.matchMultiple([TokenType.IS, TokenType.DEFAULT])) {
      return parseIsStatement();
    }
    if (tokens.match(TokenType.MEMORIZE)) {
      return parseMemorizeStatement();
    } if (tokens.match(TokenType.FALL)) {
      return FallStatement();
    }
    return SyntaxErrorStatement(tokens.consumeToken());
  }

  Statement parseArrayAssignmentStatement(Token variableName) {
    AssignmentStatement statement = AssignmentStatement();
    statement.setStart(variableName);
    statement.setVariableName = variableName.stringValue;

    List<Expression> index = [];
    while (tokens.hasMoreTokens() &&
        tokens.matchAndConsume(TokenType.LEFT_BRACKET)) {
      index.add(parseExpression());
      require(TokenType.RIGHT_BRACE, statement);
    }

    statement.setArrayIndex = index;
    require(TokenType.EQUAL, statement);
    Expression expression = parseExpression();
    statement.setExpression = expression;
    return statement;
  }

  FunctionDefinitionStatement parseFunctionDeclarationStatement() {
    var statement = FunctionDefinitionStatement();
    tempFunDef = statement;
    statement.setStart(tokens.consumeToken());
    statement.setName = require(TokenType.IDENTIFIER, statement).stringValue;
    require(TokenType.LEFT_PAREN, statement);

    while (tokens.hasMoreTokens() && !tokens.match(TokenType.RIGHT_PAREN)) {
      String name = require(TokenType.IDENTIFIER, statement).stringValue;
      TypeLiteral? type =
          (tokens.matchAndConsume(TokenType.COLON)) ? parseTypeLiteral() : null;
      statement.addParameter(name, type);
      tokens.matchAndConsume(TokenType.COMMA);
    }

    require(TokenType.RIGHT_PAREN, statement);

    if (tokens.matchAndConsume(TokenType.ARROW)) {
      statement.setType(parseTypeLiteral());
    } else {
      TypeLiteral type = TypeLiteral();
      type.setType(PennyType(PenType.VOID));
      statement.setType(type);
    }

    require(TokenType.LEFT_BRACE, statement);

    List<Statement> body = [];
    while (tokens.hasMoreTokens() && !tokens.match(TokenType.RIGHT_BRACE)) {
      body.add(parseProgramStatement());
    }

    require(TokenType.RIGHT_BRACE, statement);
    statement.setBody(body);
    tempFunDef = null;
    return statement;
  }

  AssignmentStatement parseAssignmentStatement(Token name) {
    AssignmentStatement assignmentStatement = AssignmentStatement();
    assignmentStatement.setStart(name);
    assignmentStatement.setVariableName = name.stringValue;
    Expression expression = parseExpression();
    assignmentStatement.setExpression = expression;
    assignmentStatement.setEnd = expression.end;
    return assignmentStatement;
  }

  IsStatement parseIsStatement() {
    IsStatement statement = IsStatement();
    statement.setStart(tokens.getCurrentToken());
    statement.setToken(tokens.consumeToken());

    if (!statement.isDefault()) {
      List<Expression> matches = [];

      while (tokens.hasMoreTokens() &&
          !tokens.matchAndConsume(TokenType.LEFT_BRACE)) {
        matches.add(parsePrimaryExpression());

        if (tokens.getCurrentToken().type != TokenType.COLON) {
          require(TokenType.COMMA, statement);
        }
      }
      statement.setMatches(matches);
    }

    require(TokenType.LEFT_BRACE, statement);

    List<Statement> body = [];
    while (tokens.hasMoreTokens() && !tokens.match(TokenType.RIGHT_BRACE)) {
      body.add(parseProgramStatement());
    }

    require(TokenType.RIGHT_BRACE, statement);
    statement.setTrueStatements = body;
    return statement;
  }

  SwitchStatement parseSwitchStatement() {
    SwitchStatement statement = SwitchStatement();
    statement.setStart(tokens.consumeToken());
    bool paren = tokens.matchAndConsume(TokenType.LEFT_PAREN);
    var expression = parseExpression();
    statement.setExpression = expression;
    statement.setType = expression.getType();
    if (paren) {
      require(TokenType.RIGHT_PAREN, statement);
    }
    require(TokenType.LEFT_BRACE, statement);
    List<Statement> body = [];
    while (!tokens.match(TokenType.RIGHT_BRACE) && tokens.hasMoreTokens()) {
      body.add(parseIsStatement());
    }
    statement.setIsStatement = body;
    require(TokenType.RIGHT_BRACE, statement);
    return statement;
  }

  DowhileStatement parseDoWhileStatement() {
    DowhileStatement statement = DowhileStatement();
    currentWhileStatement = statement;
    statement.setStart(tokens.consumeToken());
    if (tokens.match(TokenType.IDENTIFIER)) {
      statement.setVariableName = tokens.consumeToken();
    } else if (tokens.match(TokenType.LEFT_PAREN)) {
      statement.setVariableName = require(TokenType.IDENTIFIER, statement);
      require(TokenType.RIGHT_PAREN, statement);
    }

    require(TokenType.LEFT_BRACE, statement);

    List<Statement> body = [];
    while (!tokens.match(TokenType.RIGHT_BRACE) && tokens.hasMoreTokens()) {
      body.add(parseProgramStatement());
    }

    require(TokenType.RIGHT_BRACE, statement);
    require(TokenType.WHILE, statement);

    bool paren = tokens.matchAndConsume(TokenType.LEFT_PAREN);

    statement.setExpression = parseExpression();
    if (paren) {
      require(TokenType.RIGHT_PAREN, statement);
    }

    currentWhileStatement = null;
    statement.setBody = body;
    return statement;
  }

  ContinueStatement parseContinueStatement() {
    ContinueStatement statement = ContinueStatement();
    statement.setStart(tokens.consumeToken());
    if (currentForStatement != null) {
      statement.setParentLoop = currentForStatement;
    } else if (currentWhileStatement != null) {
      statement.setParentLoop = currentWhileStatement;
    }
    return statement;
  }

  BreakStatement parseBreakStatement() {
    BreakStatement statement = BreakStatement();
    statement.setStart(tokens.consumeToken());
    if (currentForStatement != null) {
      statement.setParentLoop = currentForStatement;
    } else if (currentWhileStatement != null) {
      statement.setParentLoop = currentWhileStatement;
    }
    return statement;
  }

  Statement? currentWhileStatement;
  WhileStatement parseWhileStatement() {
    WhileStatement statement = WhileStatement();
    currentWhileStatement = statement;
    statement.setStart(tokens.consumeToken());
    bool paren = tokens.matchAndConsume(TokenType.LEFT_PAREN);
    statement.setExpression = parseExpression();
    if (tokens.matchAndConsume(TokenType.COMMA)) {
      statement.setVariableName = require(TokenType.IDENTIFIER, statement);
    }
    if (paren) {
      require(TokenType.RIGHT_PAREN, statement);
    }
    require(TokenType.LEFT_BRACE, statement);
    List<Statement> body = [];
    while (!tokens.match(TokenType.RIGHT_BRACE) && tokens.hasMoreTokens()) {
      body.add(parseProgramStatement());
    }
    require(TokenType.RIGHT_BRACE, statement);
    currentWhileStatement = null;
    statement.setBody = body;
    return statement;
  }

  ReturnStatement parseReturnStatement() {
    ReturnStatement returnStatement = ReturnStatement();
    returnStatement.setStart(tokens.consumeToken());
    if (tokens.hasMoreTokens() && !tokens.match(TokenType.RIGHT_BRACE)) {
      returnStatement.setExpression = parseExpression();
    }
    if (tempFunDef != null) {
      returnStatement.setFunction = tempFunDef;
    }
    return returnStatement;
  }

  FunctionDefinitionStatement? tempFunDef;

  VariableStatement parseVarStatement() {
    VariableStatement variableStatement = VariableStatement();
    variableStatement.setStart(tokens.consumeToken());
    variableStatement.setVariableName =
        require(TokenType.IDENTIFIER, variableStatement).stringValue;
    if (tokens.matchAndConsume(TokenType.COLON)) {
      variableStatement.setExplicitType = parseTypeLiteral().type;
    }
    variableStatement.setEnd = require(TokenType.EQUAL, variableStatement);
    variableStatement.setExpression = parseExpression();
    return variableStatement;
  }

  IfStatement parseIfStatement() {
    IfStatement ifStatement = IfStatement();
    ifStatement.setToken(tokens.consumeToken());
    bool paren = tokens.matchAndConsume(TokenType.LEFT_PAREN);
    ifStatement.setExpression = parseExpression();
    require(TokenType.RIGHT_PAREN, ifStatement);
    if (paren) {
      require(TokenType.RIGHT_PAREN, ifStatement);
    }
    require(TokenType.LEFT_BRACE, ifStatement);
    List<Statement> body = [];
    while (tokens.hasMoreTokens() && !tokens.match(TokenType.RIGHT_BRACE)) {
      body.add(parseProgramStatement());
    }
    ifStatement.setTrueStatements = body;
    ifStatement.setEnd = require(TokenType.RIGHT_BRACE, ifStatement);
    List<Statement> elseStatements = [];
    if (tokens.matchAndConsume(TokenType.ELSE)) {
      if (tokens.match(TokenType.IF)) {
        elseStatements.add(parseIfStatement());
      } else {
        require(TokenType.LEFT_BRACE, ifStatement);
        while (tokens.hasMoreTokens() && !tokens.match(TokenType.RIGHT_BRACE)) {
          elseStatements.add(parseProgramStatement());
        }
        require(TokenType.RIGHT_BRACE, ifStatement);
      }
    }
    ifStatement.setElseStatements = elseStatements;
    return ifStatement;
  }

  ForStatement? currentForStatement = ForStatement();

  Statement parseForStatement() {
    ForStatement forStatement = ForStatement();
    forStatement.setStart(tokens.consumeToken());
    bool paren = tokens.matchAndConsume(TokenType.LEFT_PAREN);
    if (tokens.match(TokenType.IDENTIFIER)) {
      forStatement.setVariableName = tokens.getCurrentToken().stringValue;
    }
    require(TokenType.IDENTIFIER, forStatement);
    require(TokenType.IN, forStatement);
    forStatement.setExpression = parseExpression();
    if (paren) {
      require(TokenType.RIGHT_PAREN, forStatement);
    }
    require(TokenType.LEFT_BRACE, forStatement);
    List<Statement> statements = [];
    while (tokens.hasMoreTokens() && !tokens.match(TokenType.RIGHT_BRACE)) {
      statements.add(parseProgramStatement());
    }
    forStatement.setBody = statements;
    forStatement.setEnd = tokens.getCurrentToken();
    require(TokenType.RIGHT_BRACE, forStatement);
    currentForStatement = null;
    return forStatement;
  }

  Statement parsePrintStatement() {
    PrintStatement printStatement = PrintStatement();
    printStatement.setToken(tokens.consumeToken());
    require(TokenType.LEFT_PAREN, printStatement);
    printStatement.setExpression = parseExpression();
    printStatement.setEnd = require(TokenType.RIGHT_PAREN, printStatement);
    return printStatement;
  }

  Expression parseExpression() {
    if (tokens.match(TokenType.RANGE)) {
      return parseRangeExpression();
    }
    if (tokens.matchMultiple([TokenType.RECALL, TokenType.FORGET])) {
      return parseGlobalStorageExpression();
    }
    return parseEqualityExpression();
  }

  Statement parseMemorizeStatement() {
    MemorizeStatement statement = MemorizeStatement();
    statement.setStart(tokens.consumeToken());
    statement.setExpression(parseExpression());
    return statement;
  }

  Expression parseGlobalStorageExpression() {
    Token token = tokens.consumeToken();
    if (token.type == TokenType.RECALL) {
      RecallExpression expression = RecallExpression();
      expression.setStart(token);
      return expression;
    } else {
      ForgetExpression expression = ForgetExpression();
      expression.setStart(token);
      return expression;
    }
  }

  Expression parseRangeExpression() {
    RangeExpression rangeExpression = RangeExpression();
    rangeExpression.setStart(tokens.consumeToken());
    require(TokenType.LEFT_PAREN, rangeExpression);
    List<Expression> control = [];
    while (!tokens.match(TokenType.RIGHT_PAREN) && tokens.hasMoreTokens()) {
      control.add(parseExpression());
      tokens.matchAndConsume(TokenType.COMMA);
    }
    rangeExpression.setControl(control);
    require(TokenType.RIGHT_PAREN, rangeExpression);
    return rangeExpression;
  }

  Expression parseEqualityExpression() {
    Expression lhs = parseComparisonExpression();
    if (tokens.matchMultiple([TokenType.EQUAL_EQUAL, TokenType.BANG_EQUAL])) {
      Token token = tokens.consumeToken();
      Expression rhs = parseEqualityExpression();
      return EqualityExpression(token, lhs, rhs);
    }
    return lhs;
  }

  Expression parseComparisonExpression() {
    Expression lhs = parseAdditiveExpression();
    if (tokens.matchMultiple([
      TokenType.GREATER,
      TokenType.GREATER_EQUAL,
      TokenType.LESS,
      TokenType.LESS_EQUAL
    ])) {
      Token token = tokens.consumeToken();
      Expression rhs = parseAdditiveExpression();
      rhs.setToken(token);
      return ComparisonExpression(token, lhs, rhs);
    }
    return lhs;
  }

  Expression parseAdditiveExpression() {
    Expression expression = parseFactorExpression();
    while (tokens.matchMultiple([TokenType.PLUS, TokenType.MINUS])) {
      Token operator = tokens.consumeToken();
      Expression rightHandSide =
          (tokens.matchAndConsumeMultiple([TokenType.PLUS, TokenType.MINUS]))
              ? IntegerLiteralExpression("1")
              : parseFactorExpression();
      AdditiveExpression additiveExpression =
          AdditiveExpression(operator, expression, rightHandSide);
      additiveExpression.start = expression.start;
      additiveExpression.setEnd = expression.end;
      additiveExpression.setToken(operator);
      expression = additiveExpression;
    }
    return expression;
  }

  Expression parseFactorExpression() {
    Expression leftHandSide = parseUnaryExpression();
    while (tokens.matchMultiple([
      TokenType.SLASH,
      TokenType.STAR,
      TokenType.STARSTAR,
      TokenType.MOD,
      TokenType.OR,
      TokenType.AND,
      TokenType.BINAND,
      TokenType.BINLEFTSHIFT,
      TokenType.BINOR,
      TokenType.BINRIGHTSHIFT,
      TokenType.BINXOR,
    ])) {
      Token operator = tokens.consumeToken();
      final Expression rightHandSide = parseUnaryExpression();
      FactorExpression factorExpression =
          FactorExpression(operator, leftHandSide, rightHandSide);
      factorExpression.setStart(leftHandSide.start);
      factorExpression.setToken(operator);
      leftHandSide = factorExpression;
    }
    return leftHandSide;
  }

  Expression parseUnaryExpression() {
    if (tokens
        .matchMultiple([TokenType.MINUS, TokenType.NOT, TokenType.BINCOMP])) {
      Token token = tokens.consumeToken();
      Expression exp = parsePrimaryExpression();
      UnaryExpression unaryExpression = UnaryExpression(token, exp);
      unaryExpression.setStart(token);
      return unaryExpression;
    }
    return parsePrimaryExpression();
  }

  FunctionCallExpression parseFunctionExpression(Token start) {
    List<Expression> argumentList = [];
    bool terminated = true;
    tokens.consumeToken();
    if (!tokens.matchAndConsume(TokenType.RIGHT_PAREN)) {
      argumentList.add(parseExpression());
      while (tokens.matchAndConsume(TokenType.COMMA)) {
        argumentList.add(parseExpression());
      }
      terminated = false;
    }
    FunctionCallExpression expression =
        FunctionCallExpression(start.stringValue, argumentList);
    expression.setToken(start);
    if (!terminated) {
      _requireMsg(
          TokenType.RIGHT_PAREN, expression, ErrorType.UNTERMINATED_ARG_LIST);
    }
    return expression;
  }

  Expression parseIndexExpression(Token variableName) {
    IndexExpression indexExpression = IndexExpression();
    indexExpression.setStart(tokens.getCurrentToken());
    List<Expression> indexes = [];
    while (tokens.matchAndConsume(TokenType.LEFT_BRACKET) &&
        tokens.hasMoreTokens()) {
      indexes.add(parsePrimaryExpression());
      require(TokenType.RIGHT_BRACKET, indexExpression);
    }
    indexExpression.setVariableName(variableName.stringValue);
    indexExpression.setIndexes(indexes);
    return indexExpression;
  }

  Expression parseNullCheckExpression(Token variableName) {
    NullCheckExpression nullCheckExpression = NullCheckExpression();
    nullCheckExpression.setVariable(variableName);
    nullCheckExpression.setStart(variableName);
    nullCheckExpression.end = tokens.consumeToken();
    return nullCheckExpression;
  }

  Expression parseTernaryExpression(
      ParenthesizedExpression parenthesizedExpression) {
    TernaryExpression expression = TernaryExpression();
    expression.setParenthesizedExpression = parenthesizedExpression;
    expression.setTrueExpression = parseExpression();
    require(TokenType.COLON, expression);
    expression.setFalseExpression = parseExpression();
    return expression;
  }

  Expression parsePrimaryExpression() {
    Token token;
    if (tokens.match(TokenType.INTEGER)) {
      token = tokens.consumeToken();
      IntegerLiteralExpression integerExpression =
          IntegerLiteralExpression(token.stringValue);
      integerExpression.setToken(token);
      return integerExpression;
    } else if (tokens.match(TokenType.FLOAT)) {
      token = tokens.consumeToken();
      FloatLiteralExpression floatExpression =
          FloatLiteralExpression(token.stringValue);
      floatExpression.setToken(token);
      return floatExpression;
    } else if (tokens.match(TokenType.IDENTIFIER)) {
      token = tokens.consumeToken();
      if (tokens.match(TokenType.LEFT_PAREN)) {
        return parseFunctionExpression(token);
      }
      if (tokens.match(TokenType.LEFT_BRACKET)) {
        return parseIndexExpression(token);
      }
      if (tokens.match(TokenType.QUESTION)) {
        return parseNullCheckExpression(token);
      } else {
        IdentifierExpression identifierExpression =
            IdentifierExpression(token.stringValue);
        identifierExpression.setToken(token);
        return identifierExpression;
      }
    } else if (tokens.match(TokenType.STRING)) {
      token = tokens.consumeToken();
      StringLiteralExpression stringLiteralExpression =
          StringLiteralExpression(token.stringValue);
      stringLiteralExpression.setToken(token);
      return stringLiteralExpression;
    } else if (tokens.match(TokenType.TRUE)) {
      token = tokens.consumeToken();
      BooleanLiteralExpression booleanLiteralExpression =
          BooleanLiteralExpression(true);
      booleanLiteralExpression.setToken(token);
      return booleanLiteralExpression;
    } else if (tokens.match(TokenType.FALSE)) {
      token = tokens.consumeToken();
      BooleanLiteralExpression booleanLiteralExpression =
          BooleanLiteralExpression(false);
      booleanLiteralExpression.setToken(token);
      return booleanLiteralExpression;
    } else if (tokens.match(TokenType.NULL)) {
      token = tokens.consumeToken();
      NullLiteralExpression literalExpression = NullLiteralExpression();
      literalExpression.setToken(token);
      return literalExpression;
    } else if (tokens.matchAndConsume(TokenType.LEFT_BRACKET)) {
      List<Expression> listargs = [];
      bool terminated = true;
      if (!tokens.matchAndConsume(TokenType.RIGHT_BRACKET)) {
        listargs.add(parseExpression());
        while (tokens.matchAndConsume(TokenType.COMMA)) {
          listargs.add(parseExpression());
        }
        terminated = false;
      }
      ListLiteralExpression literalExpression = ListLiteralExpression(listargs);
      if (!terminated) {
        _requireMsg(TokenType.RIGHT_BRACKET, literalExpression,
            ErrorType.UNTERMINATED_ARG_LIST);
      }
      return literalExpression;
    } else if (tokens.matchAndConsume(TokenType.LEFT_PAREN)) {
      Expression expression = parseExpression();
      ParenthesizedExpression parenthesizedExpression =
          ParenthesizedExpression(expression);
      require(TokenType.RIGHT_PAREN, parenthesizedExpression);
      if (tokens.matchAndConsume(TokenType.QUESTION)) {
        return parseTernaryExpression(parenthesizedExpression);
      }
      return parenthesizedExpression;
    }
    return SyntaxErrorExpression(tokens.getCurrentToken());
  }

  TypeLiteral parseTypeLiteral() {
    TypeLiteral typeLiteral = TypeLiteral();
    switch (tokens.getCurrentToken().stringValue) {
      case "int":
        tokens.consumeToken();
        typeLiteral.setType(PennyType(PenType.INT));
        break;
      case "string":
        tokens.consumeToken();
        typeLiteral.setType(PennyType(PenType.STRING));
        break;
      case "bool":
        tokens.consumeToken();
        typeLiteral.setType(PennyType(PenType.BOOLEAN));
        break;
      case "object":
        tokens.consumeToken();
        typeLiteral.setType(PennyType(PenType.OBJECT));
        break;
      case "float":
        tokens.consumeToken();
        typeLiteral.setType(PennyType(PenType.FLOAT));
        break;
      case "list":
        tokens.consumeToken();
        if (tokens.matchAndConsume(TokenType.LESS)) {
          PennyType type = PennyType(PenType.LIST);
          ListType lt = type.getListType(parseTypeLiteral().getType().type);
          typeLiteral.setType(lt);
          tokens.matchAndConsume(TokenType.GREATER);
        } else {
          PennyType type = PennyType(PenType.LIST);
          typeLiteral.setType(type.getListType(PenType.OBJECT));
        }
        break;
    }
    return typeLiteral;
  }

// UTILITIES
  Token require(TokenType type, ParseElement elt) {
    return _requireMsg(type, elt, ErrorType.UNEXPECTED_TOKEN);
  }

  Token _requireMsg(TokenType type, ParseElement elt, ErrorType msg) {
    if (tokens.match(type)) {
      return tokens.consumeToken();
    } else {
      elt.addError(msg, []);
      return tokens.getCurrentToken();
    }
  }
}
