/*This file is part of Penny.

Penny is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Penny is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Penny. If not, see <https://www.gnu.org/licenses/>.*/

enum PenType { INT, FLOAT, STRING, BOOLEAN, OBJECT, NULL, VOID, LIST }

class PennyType {
  final PenType type;
  PennyType(this.type);

  bool isAssignableFrom(PenType foreignType) {
    if (foreignType == PenType.VOID) {
      return false;
    } else if (foreignType == PenType.NULL) {
      return false;
    } else if (type == PenType.LIST) {
      return false;
    } else if (foreignType == PenType.OBJECT) {
      return true;
    } else if (foreignType == type) {
      return true;
    }
    if ((type == PenType.INT || type == PenType.FLOAT) &&
        (foreignType == PenType.INT || foreignType == PenType.FLOAT)) {
      return true;
    }
    return false;
  }

  final Map<PenType, ListType> cache = {};
  ListType getListType(PenType type) {
    if (cache.containsKey(type)) {
      return cache[type]!;
    }
    ListType listType = ListType(type);
    cache.putIfAbsent(type, () => listType);
    return listType;
  }

  @override
  String toString() => type.toString();
}

class ListType extends PennyType {
  PenType componentType;
  ListType(this.componentType) : super(componentType);

  @override
  bool isAssignableFrom(PenType type) {
    if (type == PenType.NULL) {
      return true;
    } else if (type == PenType.LIST) {
      ListType otherlist = getListType(type);
      return componentType == otherlist.componentType;
    }
    return false;
  }

  @override
  String toString() {
    return "${super.toString()}<${componentType.toString}>}";
  }
}
