/* This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'dart:io';
import 'master_imports.dart';

String helpmsg = """Welcome to the Penny Scripting Language
CLI Usage:
  ./Penny.exe <options> [file]

  -h Print the help message

  -f Parse and execute a file
      ./Penny.exe -f test.pen

  Parse and execute a string
      ./Penny.exe "print(5)"
""";

void main(List<String> arguments) {
  if (!arguments.isNotEmpty) {
    print("ERROR: No input!");
    print(helpmsg);
    return;
  }
  if (arguments[0].toLowerCase() == "-h") {
    print(helpmsg);
    return;
  }
  if (arguments[0].toLowerCase() == "-f") {
    if (arguments.length != 2) {
      print("ERROR: No file path passed!");
      print(helpmsg);
      return;
    }
    if (arguments[1].substring(-4, -1) != ".pen") {
      print("ERROR: Penny files must have .pen extension");
      return;
    }
    File(arguments[1]).readAsString().then((String source) {
      runProgram(source);
      return;
    });
  } else {
    runProgram(arguments[0]);
  }
}

void runProgram(String src) {
  PennyParser parser = PennyParser();
  PennyProgram program = parser.parse(src);
  program.verify();
  program.executeProgram();
}
