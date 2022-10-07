/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

import 'package:test/test.dart';
import '../../bin/master_imports.dart';


void main()
{
  testTypes();
}

void testTypes()
{
  test('testintttype', (){
    PennyType type = PennyType(PenType.INT);
    expect(type.isAssignableFrom(PenType.FLOAT), true);
    expect(type.isAssignableFrom(PenType.INT), true);
    expect(type.isAssignableFrom(PenType.OBJECT), true);
    expect(type.isAssignableFrom(PenType.BOOLEAN), false);
    expect(type.isAssignableFrom(PenType.LIST), false);
    expect(type.isAssignableFrom(PenType.NULL), false);
    expect(type.isAssignableFrom(PenType.VOID), false);
    expect(type.isAssignableFrom(PenType.STRING), false);
  });

  test('testfloattype', (){
    PennyType type = PennyType(PenType.FLOAT);
    expect(type.isAssignableFrom(PenType.FLOAT), true);
    expect(type.isAssignableFrom(PenType.INT), true);
    expect(type.isAssignableFrom(PenType.OBJECT), true);
    expect(type.isAssignableFrom(PenType.BOOLEAN), false);
    expect(type.isAssignableFrom(PenType.LIST), false);
    expect(type.isAssignableFrom(PenType.NULL), false);
    expect(type.isAssignableFrom(PenType.VOID), false);
    expect(type.isAssignableFrom(PenType.STRING), false);
  });
  test('teststringtype', (){
    PennyType type = PennyType(PenType.STRING);
    expect(type.isAssignableFrom(PenType.STRING), true);
    expect(type.isAssignableFrom(PenType.OBJECT), true);
    expect(type.isAssignableFrom(PenType.INT), false);
    expect(type.isAssignableFrom(PenType.FLOAT), false);
    expect(type.isAssignableFrom(PenType.NULL), false);
    expect(type.isAssignableFrom(PenType.VOID), false);
    expect(type.isAssignableFrom(PenType.BOOLEAN), false);
    expect(type.isAssignableFrom(PenType.LIST), false);
  });
}