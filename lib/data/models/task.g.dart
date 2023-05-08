// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetSeeGoalCollection on Isar {
  IsarCollection<SeeGoal> get seeGoals => this.collection();
}

const SeeGoalSchema = CollectionSchema(
  name: r'SeeGoal',
  id: -155673579532909273,
  properties: {
    r'description': PropertySchema(
      id: 0,
      name: r'description',
      type: IsarType.string,
    ),
    r'insertTime': PropertySchema(
      id: 1,
      name: r'insertTime',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 3,
      name: r'priority',
      type: IsarType.long,
    ),
    r'statePatterns': PropertySchema(
      id: 4,
      name: r'statePatterns',
      type: IsarType.objectList,
      target: r'StatePattern',
    ),
    r'tasks': PropertySchema(
      id: 5,
      name: r'tasks',
      type: IsarType.longList,
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.byte,
      enumMap: _SeeGoaltypeEnumValueMap,
    ),
    r'updateTime': PropertySchema(
      id: 7,
      name: r'updateTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _seeGoalEstimateSize,
  serialize: _seeGoalSerialize,
  deserialize: _seeGoalDeserialize,
  deserializeProp: _seeGoalDeserializeProp,
  idName: r'id',
  indexes: {
    r'priority': IndexSchema(
      id: -6477851841645083544,
      name: r'priority',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'priority',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'insertTime': IndexSchema(
      id: 4224881274084417522,
      name: r'insertTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'insertTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'StatePattern': StatePatternSchema},
  getId: _seeGoalGetId,
  getLinks: _seeGoalGetLinks,
  attach: _seeGoalAttach,
  version: '3.0.5',
);

int _seeGoalEstimateSize(
  SeeGoal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.statePatterns.length * 3;
  {
    final offsets = allOffsets[StatePattern]!;
    for (var i = 0; i < object.statePatterns.length; i++) {
      final value = object.statePatterns[i];
      bytesCount += StatePatternSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.tasks.length * 8;
  return bytesCount;
}

void _seeGoalSerialize(
  SeeGoal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.description);
  writer.writeDateTime(offsets[1], object.insertTime);
  writer.writeString(offsets[2], object.name);
  writer.writeLong(offsets[3], object.priority);
  writer.writeObjectList<StatePattern>(
    offsets[4],
    allOffsets,
    StatePatternSchema.serialize,
    object.statePatterns,
  );
  writer.writeLongList(offsets[5], object.tasks);
  writer.writeByte(offsets[6], object.type.index);
  writer.writeDateTime(offsets[7], object.updateTime);
}

SeeGoal _seeGoalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SeeGoal();
  object.description = reader.readString(offsets[0]);
  object.id = id;
  object.insertTime = reader.readDateTime(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.priority = reader.readLong(offsets[3]);
  object.statePatterns = reader.readObjectList<StatePattern>(
        offsets[4],
        StatePatternSchema.deserialize,
        allOffsets,
        StatePattern(),
      ) ??
      [];
  object.tasks = reader.readLongList(offsets[5]) ?? [];
  object.type = _SeeGoaltypeValueEnumMap[reader.readByteOrNull(offsets[6])] ??
      GoalType.once;
  object.updateTime = reader.readDateTimeOrNull(offsets[7]);
  return object;
}

P _seeGoalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readObjectList<StatePattern>(
            offset,
            StatePatternSchema.deserialize,
            allOffsets,
            StatePattern(),
          ) ??
          []) as P;
    case 5:
      return (reader.readLongList(offset) ?? []) as P;
    case 6:
      return (_SeeGoaltypeValueEnumMap[reader.readByteOrNull(offset)] ??
          GoalType.once) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SeeGoaltypeEnumValueMap = {
  'once': 0,
  'daily': 1,
  'always': 2,
};
const _SeeGoaltypeValueEnumMap = {
  0: GoalType.once,
  1: GoalType.daily,
  2: GoalType.always,
};

Id _seeGoalGetId(SeeGoal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _seeGoalGetLinks(SeeGoal object) {
  return [];
}

void _seeGoalAttach(IsarCollection<dynamic> col, Id id, SeeGoal object) {
  object.id = id;
}

extension SeeGoalQueryWhereSort on QueryBuilder<SeeGoal, SeeGoal, QWhere> {
  QueryBuilder<SeeGoal, SeeGoal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhere> anyPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'priority'),
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhere> anyInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'insertTime'),
      );
    });
  }
}

extension SeeGoalQueryWhere on QueryBuilder<SeeGoal, SeeGoal, QWhereClause> {
  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> priorityEqualTo(
      int priority) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'priority',
        value: [priority],
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> priorityNotEqualTo(
      int priority) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priority',
              lower: [],
              upper: [priority],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priority',
              lower: [priority],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priority',
              lower: [priority],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priority',
              lower: [],
              upper: [priority],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> priorityGreaterThan(
    int priority, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'priority',
        lower: [priority],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> priorityLessThan(
    int priority, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'priority',
        lower: [],
        upper: [priority],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> priorityBetween(
    int lowerPriority,
    int upperPriority, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'priority',
        lower: [lowerPriority],
        includeLower: includeLower,
        upper: [upperPriority],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> insertTimeEqualTo(
      DateTime insertTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'insertTime',
        value: [insertTime],
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> insertTimeNotEqualTo(
      DateTime insertTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [],
              upper: [insertTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [insertTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [insertTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [],
              upper: [insertTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> insertTimeGreaterThan(
    DateTime insertTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [insertTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> insertTimeLessThan(
    DateTime insertTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [],
        upper: [insertTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterWhereClause> insertTimeBetween(
    DateTime lowerInsertTime,
    DateTime upperInsertTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [lowerInsertTime],
        includeLower: includeLower,
        upper: [upperInsertTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SeeGoalQueryFilter
    on QueryBuilder<SeeGoal, SeeGoal, QFilterCondition> {
  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> insertTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> insertTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> insertTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> insertTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'insertTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> priorityEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> priorityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> priorityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> priorityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition>
      statePatternsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statePatterns',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> statePatternsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statePatterns',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition>
      statePatternsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statePatterns',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition>
      statePatternsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statePatterns',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition>
      statePatternsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statePatterns',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition>
      statePatternsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statePatterns',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> tasksElementEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tasks',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> tasksElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tasks',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> tasksElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tasks',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> tasksElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tasks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> tasksLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tasks',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> tasksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tasks',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> tasksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tasks',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> tasksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tasks',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> tasksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tasks',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> tasksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tasks',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> typeEqualTo(
      GoalType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> typeGreaterThan(
    GoalType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> typeLessThan(
    GoalType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> typeBetween(
    GoalType lower,
    GoalType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> updateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updateTime',
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> updateTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updateTime',
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> updateTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> updateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> updateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> updateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SeeGoalQueryObject
    on QueryBuilder<SeeGoal, SeeGoal, QFilterCondition> {
  QueryBuilder<SeeGoal, SeeGoal, QAfterFilterCondition> statePatternsElement(
      FilterQuery<StatePattern> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'statePatterns');
    });
  }
}

extension SeeGoalQueryLinks
    on QueryBuilder<SeeGoal, SeeGoal, QFilterCondition> {}

extension SeeGoalQuerySortBy on QueryBuilder<SeeGoal, SeeGoal, QSortBy> {
  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByInsertTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.desc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> sortByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }
}

extension SeeGoalQuerySortThenBy
    on QueryBuilder<SeeGoal, SeeGoal, QSortThenBy> {
  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByInsertTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.desc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QAfterSortBy> thenByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }
}

extension SeeGoalQueryWhereDistinct
    on QueryBuilder<SeeGoal, SeeGoal, QDistinct> {
  QueryBuilder<SeeGoal, SeeGoal, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QDistinct> distinctByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'insertTime');
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QDistinct> distinctByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority');
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QDistinct> distinctByTasks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tasks');
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<SeeGoal, SeeGoal, QDistinct> distinctByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updateTime');
    });
  }
}

extension SeeGoalQueryProperty
    on QueryBuilder<SeeGoal, SeeGoal, QQueryProperty> {
  QueryBuilder<SeeGoal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SeeGoal, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<SeeGoal, DateTime, QQueryOperations> insertTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'insertTime');
    });
  }

  QueryBuilder<SeeGoal, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SeeGoal, int, QQueryOperations> priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<SeeGoal, List<StatePattern>, QQueryOperations>
      statePatternsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statePatterns');
    });
  }

  QueryBuilder<SeeGoal, List<int>, QQueryOperations> tasksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tasks');
    });
  }

  QueryBuilder<SeeGoal, GoalType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<SeeGoal, DateTime?, QQueryOperations> updateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updateTime');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetSeeGoalExperiencesCollection on Isar {
  IsarCollection<SeeGoalExperiences> get seeGoalExperiences =>
      this.collection();
}

const SeeGoalExperiencesSchema = CollectionSchema(
  name: r'SeeGoalExperiences',
  id: 1523224022712779656,
  properties: {
    r'experiences': PropertySchema(
      id: 0,
      name: r'experiences',
      type: IsarType.stringList,
    ),
    r'goalId': PropertySchema(
      id: 1,
      name: r'goalId',
      type: IsarType.long,
    ),
    r'insertTime': PropertySchema(
      id: 2,
      name: r'insertTime',
      type: IsarType.dateTime,
    ),
    r'score': PropertySchema(
      id: 3,
      name: r'score',
      type: IsarType.long,
    )
  },
  estimateSize: _seeGoalExperiencesEstimateSize,
  serialize: _seeGoalExperiencesSerialize,
  deserialize: _seeGoalExperiencesDeserialize,
  deserializeProp: _seeGoalExperiencesDeserializeProp,
  idName: r'id',
  indexes: {
    r'goalId': IndexSchema(
      id: 2738626632585230611,
      name: r'goalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'goalId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'insertTime': IndexSchema(
      id: 4224881274084417522,
      name: r'insertTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'insertTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'score': IndexSchema(
      id: -359542572601593437,
      name: r'score',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'score',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _seeGoalExperiencesGetId,
  getLinks: _seeGoalExperiencesGetLinks,
  attach: _seeGoalExperiencesAttach,
  version: '3.0.5',
);

int _seeGoalExperiencesEstimateSize(
  SeeGoalExperiences object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.experiences.length * 3;
  {
    for (var i = 0; i < object.experiences.length; i++) {
      final value = object.experiences[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _seeGoalExperiencesSerialize(
  SeeGoalExperiences object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.experiences);
  writer.writeLong(offsets[1], object.goalId);
  writer.writeDateTime(offsets[2], object.insertTime);
  writer.writeLong(offsets[3], object.score);
}

SeeGoalExperiences _seeGoalExperiencesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SeeGoalExperiences();
  object.experiences = reader.readStringList(offsets[0]) ?? [];
  object.goalId = reader.readLong(offsets[1]);
  object.id = id;
  object.insertTime = reader.readDateTime(offsets[2]);
  object.score = reader.readLong(offsets[3]);
  return object;
}

P _seeGoalExperiencesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _seeGoalExperiencesGetId(SeeGoalExperiences object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _seeGoalExperiencesGetLinks(
    SeeGoalExperiences object) {
  return [];
}

void _seeGoalExperiencesAttach(
    IsarCollection<dynamic> col, Id id, SeeGoalExperiences object) {
  object.id = id;
}

extension SeeGoalExperiencesQueryWhereSort
    on QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QWhere> {
  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhere>
      anyGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'goalId'),
      );
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhere>
      anyInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'insertTime'),
      );
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhere> anyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'score'),
      );
    });
  }
}

extension SeeGoalExperiencesQueryWhere
    on QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QWhereClause> {
  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      goalIdEqualTo(int goalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'goalId',
        value: [goalId],
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      goalIdNotEqualTo(int goalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [],
              upper: [goalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [goalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [goalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [],
              upper: [goalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      goalIdGreaterThan(
    int goalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [goalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      goalIdLessThan(
    int goalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [],
        upper: [goalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      goalIdBetween(
    int lowerGoalId,
    int upperGoalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [lowerGoalId],
        includeLower: includeLower,
        upper: [upperGoalId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      insertTimeEqualTo(DateTime insertTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'insertTime',
        value: [insertTime],
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      insertTimeNotEqualTo(DateTime insertTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [],
              upper: [insertTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [insertTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [insertTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [],
              upper: [insertTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      insertTimeGreaterThan(
    DateTime insertTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [insertTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      insertTimeLessThan(
    DateTime insertTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [],
        upper: [insertTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      insertTimeBetween(
    DateTime lowerInsertTime,
    DateTime upperInsertTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [lowerInsertTime],
        includeLower: includeLower,
        upper: [upperInsertTime],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      scoreEqualTo(int score) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'score',
        value: [score],
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      scoreNotEqualTo(int score) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'score',
              lower: [],
              upper: [score],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'score',
              lower: [score],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'score',
              lower: [score],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'score',
              lower: [],
              upper: [score],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      scoreGreaterThan(
    int score, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'score',
        lower: [score],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      scoreLessThan(
    int score, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'score',
        lower: [],
        upper: [score],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterWhereClause>
      scoreBetween(
    int lowerScore,
    int upperScore, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'score',
        lower: [lowerScore],
        includeLower: includeLower,
        upper: [upperScore],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SeeGoalExperiencesQueryFilter
    on QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QFilterCondition> {
  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'experiences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'experiences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'experiences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'experiences',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'experiences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'experiences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'experiences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'experiences',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'experiences',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'experiences',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experiences',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experiences',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experiences',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experiences',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experiences',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      experiencesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experiences',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      goalIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      goalIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      goalIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      goalIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      insertTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      insertTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      insertTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      insertTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'insertTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      scoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      scoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      scoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterFilterCondition>
      scoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SeeGoalExperiencesQueryObject
    on QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QFilterCondition> {}

extension SeeGoalExperiencesQueryLinks
    on QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QFilterCondition> {}

extension SeeGoalExperiencesQuerySortBy
    on QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QSortBy> {
  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      sortByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      sortByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      sortByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.asc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      sortByInsertTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.desc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }
}

extension SeeGoalExperiencesQuerySortThenBy
    on QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QSortThenBy> {
  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      thenByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      thenByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      thenByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.asc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      thenByInsertTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.desc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QAfterSortBy>
      thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }
}

extension SeeGoalExperiencesQueryWhereDistinct
    on QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QDistinct> {
  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QDistinct>
      distinctByExperiences() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'experiences');
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QDistinct>
      distinctByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalId');
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QDistinct>
      distinctByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'insertTime');
    });
  }

  QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QDistinct>
      distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }
}

extension SeeGoalExperiencesQueryProperty
    on QueryBuilder<SeeGoalExperiences, SeeGoalExperiences, QQueryProperty> {
  QueryBuilder<SeeGoalExperiences, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SeeGoalExperiences, List<String>, QQueryOperations>
      experiencesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'experiences');
    });
  }

  QueryBuilder<SeeGoalExperiences, int, QQueryOperations> goalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalId');
    });
  }

  QueryBuilder<SeeGoalExperiences, DateTime, QQueryOperations>
      insertTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'insertTime');
    });
  }

  QueryBuilder<SeeGoalExperiences, int, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetSeeTaskCollection on Isar {
  IsarCollection<SeeTask> get seeTasks => this.collection();
}

const SeeTaskSchema = CollectionSchema(
  name: r'SeeTask',
  id: -3392477825759854955,
  properties: {
    r'description': PropertySchema(
      id: 0,
      name: r'description',
      type: IsarType.string,
    ),
    r'endTime': PropertySchema(
      id: 1,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'estimatedTimeInMinutes': PropertySchema(
      id: 2,
      name: r'estimatedTimeInMinutes',
      type: IsarType.long,
    ),
    r'evaluation': PropertySchema(
      id: 3,
      name: r'evaluation',
      type: IsarType.string,
    ),
    r'goalId': PropertySchema(
      id: 4,
      name: r'goalId',
      type: IsarType.long,
    ),
    r'insertTime': PropertySchema(
      id: 5,
      name: r'insertTime',
      type: IsarType.dateTime,
    ),
    r'parentMessageId': PropertySchema(
      id: 6,
      name: r'parentMessageId',
      type: IsarType.string,
    ),
    r'score': PropertySchema(
      id: 7,
      name: r'score',
      type: IsarType.long,
    ),
    r'startTime': PropertySchema(
      id: 8,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 9,
      name: r'status',
      type: IsarType.byte,
      enumMap: _SeeTaskstatusEnumValueMap,
    ),
    r'taskDate': PropertySchema(
      id: 10,
      name: r'taskDate',
      type: IsarType.string,
    )
  },
  estimateSize: _seeTaskEstimateSize,
  serialize: _seeTaskSerialize,
  deserialize: _seeTaskDeserialize,
  deserializeProp: _seeTaskDeserializeProp,
  idName: r'id',
  indexes: {
    r'goalId': IndexSchema(
      id: 2738626632585230611,
      name: r'goalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'goalId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'taskDate': IndexSchema(
      id: 5562689836249259754,
      name: r'taskDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'taskDate',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'insertTime': IndexSchema(
      id: 4224881274084417522,
      name: r'insertTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'insertTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _seeTaskGetId,
  getLinks: _seeTaskGetLinks,
  attach: _seeTaskAttach,
  version: '3.0.5',
);

int _seeTaskEstimateSize(
  SeeTask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.evaluation.length * 3;
  bytesCount += 3 + object.parentMessageId.length * 3;
  bytesCount += 3 + object.taskDate.length * 3;
  return bytesCount;
}

void _seeTaskSerialize(
  SeeTask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.description);
  writer.writeDateTime(offsets[1], object.endTime);
  writer.writeLong(offsets[2], object.estimatedTimeInMinutes);
  writer.writeString(offsets[3], object.evaluation);
  writer.writeLong(offsets[4], object.goalId);
  writer.writeDateTime(offsets[5], object.insertTime);
  writer.writeString(offsets[6], object.parentMessageId);
  writer.writeLong(offsets[7], object.score);
  writer.writeDateTime(offsets[8], object.startTime);
  writer.writeByte(offsets[9], object.status.index);
  writer.writeString(offsets[10], object.taskDate);
}

SeeTask _seeTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SeeTask();
  object.description = reader.readString(offsets[0]);
  object.endTime = reader.readDateTimeOrNull(offsets[1]);
  object.estimatedTimeInMinutes = reader.readLong(offsets[2]);
  object.evaluation = reader.readString(offsets[3]);
  object.goalId = reader.readLong(offsets[4]);
  object.id = id;
  object.insertTime = reader.readDateTime(offsets[5]);
  object.parentMessageId = reader.readString(offsets[6]);
  object.score = reader.readLong(offsets[7]);
  object.startTime = reader.readDateTimeOrNull(offsets[8]);
  object.status =
      _SeeTaskstatusValueEnumMap[reader.readByteOrNull(offsets[9])] ??
          TaskStatus.pending;
  object.taskDate = reader.readString(offsets[10]);
  return object;
}

P _seeTaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (_SeeTaskstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          TaskStatus.pending) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SeeTaskstatusEnumValueMap = {
  'pending': 0,
  'running': 1,
  'done': 2,
  'failed': 3,
  'suspended': 4,
  'cancelled': 5,
};
const _SeeTaskstatusValueEnumMap = {
  0: TaskStatus.pending,
  1: TaskStatus.running,
  2: TaskStatus.done,
  3: TaskStatus.failed,
  4: TaskStatus.suspended,
  5: TaskStatus.cancelled,
};

Id _seeTaskGetId(SeeTask object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _seeTaskGetLinks(SeeTask object) {
  return [];
}

void _seeTaskAttach(IsarCollection<dynamic> col, Id id, SeeTask object) {
  object.id = id;
}

extension SeeTaskQueryWhereSort on QueryBuilder<SeeTask, SeeTask, QWhere> {
  QueryBuilder<SeeTask, SeeTask, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhere> anyGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'goalId'),
      );
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhere> anyInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'insertTime'),
      );
    });
  }
}

extension SeeTaskQueryWhere on QueryBuilder<SeeTask, SeeTask, QWhereClause> {
  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> goalIdEqualTo(int goalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'goalId',
        value: [goalId],
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> goalIdNotEqualTo(
      int goalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [],
              upper: [goalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [goalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [goalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [],
              upper: [goalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> goalIdGreaterThan(
    int goalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [goalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> goalIdLessThan(
    int goalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [],
        upper: [goalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> goalIdBetween(
    int lowerGoalId,
    int upperGoalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [lowerGoalId],
        includeLower: includeLower,
        upper: [upperGoalId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> taskDateEqualTo(
      String taskDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'taskDate',
        value: [taskDate],
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> taskDateNotEqualTo(
      String taskDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskDate',
              lower: [],
              upper: [taskDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskDate',
              lower: [taskDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskDate',
              lower: [taskDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskDate',
              lower: [],
              upper: [taskDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> insertTimeEqualTo(
      DateTime insertTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'insertTime',
        value: [insertTime],
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> insertTimeNotEqualTo(
      DateTime insertTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [],
              upper: [insertTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [insertTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [insertTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [],
              upper: [insertTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> insertTimeGreaterThan(
    DateTime insertTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [insertTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> insertTimeLessThan(
    DateTime insertTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [],
        upper: [insertTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterWhereClause> insertTimeBetween(
    DateTime lowerInsertTime,
    DateTime upperInsertTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [lowerInsertTime],
        includeLower: includeLower,
        upper: [upperInsertTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SeeTaskQueryFilter
    on QueryBuilder<SeeTask, SeeTask, QFilterCondition> {
  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> endTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition>
      estimatedTimeInMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estimatedTimeInMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition>
      estimatedTimeInMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estimatedTimeInMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition>
      estimatedTimeInMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estimatedTimeInMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition>
      estimatedTimeInMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estimatedTimeInMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> evaluationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'evaluation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> evaluationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'evaluation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> evaluationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'evaluation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> evaluationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'evaluation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> evaluationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'evaluation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> evaluationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'evaluation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> evaluationContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'evaluation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> evaluationMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'evaluation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> evaluationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'evaluation',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> evaluationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'evaluation',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> goalIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> goalIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> goalIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> goalIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> insertTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> insertTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> insertTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> insertTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'insertTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> parentMessageIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition>
      parentMessageIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> parentMessageIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> parentMessageIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentMessageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition>
      parentMessageIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> parentMessageIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> parentMessageIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> parentMessageIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentMessageId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition>
      parentMessageIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentMessageId',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition>
      parentMessageIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentMessageId',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> scoreEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> scoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> scoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> scoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> startTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> startTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> startTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> startTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> startTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> startTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> statusEqualTo(
      TaskStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> statusGreaterThan(
    TaskStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> statusLessThan(
    TaskStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> statusBetween(
    TaskStatus lower,
    TaskStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> taskDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> taskDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> taskDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> taskDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> taskDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> taskDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> taskDateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> taskDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> taskDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskDate',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterFilterCondition> taskDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskDate',
        value: '',
      ));
    });
  }
}

extension SeeTaskQueryObject
    on QueryBuilder<SeeTask, SeeTask, QFilterCondition> {}

extension SeeTaskQueryLinks
    on QueryBuilder<SeeTask, SeeTask, QFilterCondition> {}

extension SeeTaskQuerySortBy on QueryBuilder<SeeTask, SeeTask, QSortBy> {
  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByEstimatedTimeInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedTimeInMinutes', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy>
      sortByEstimatedTimeInMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedTimeInMinutes', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByEvaluation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'evaluation', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByEvaluationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'evaluation', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByInsertTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByParentMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMessageId', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByParentMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMessageId', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByTaskDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDate', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> sortByTaskDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDate', Sort.desc);
    });
  }
}

extension SeeTaskQuerySortThenBy
    on QueryBuilder<SeeTask, SeeTask, QSortThenBy> {
  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByEstimatedTimeInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedTimeInMinutes', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy>
      thenByEstimatedTimeInMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedTimeInMinutes', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByEvaluation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'evaluation', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByEvaluationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'evaluation', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByInsertTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByParentMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMessageId', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByParentMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMessageId', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByTaskDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDate', Sort.asc);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QAfterSortBy> thenByTaskDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDate', Sort.desc);
    });
  }
}

extension SeeTaskQueryWhereDistinct
    on QueryBuilder<SeeTask, SeeTask, QDistinct> {
  QueryBuilder<SeeTask, SeeTask, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<SeeTask, SeeTask, QDistinct> distinctByEstimatedTimeInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedTimeInMinutes');
    });
  }

  QueryBuilder<SeeTask, SeeTask, QDistinct> distinctByEvaluation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'evaluation', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QDistinct> distinctByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalId');
    });
  }

  QueryBuilder<SeeTask, SeeTask, QDistinct> distinctByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'insertTime');
    });
  }

  QueryBuilder<SeeTask, SeeTask, QDistinct> distinctByParentMessageId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentMessageId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeeTask, SeeTask, QDistinct> distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<SeeTask, SeeTask, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<SeeTask, SeeTask, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<SeeTask, SeeTask, QDistinct> distinctByTaskDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskDate', caseSensitive: caseSensitive);
    });
  }
}

extension SeeTaskQueryProperty
    on QueryBuilder<SeeTask, SeeTask, QQueryProperty> {
  QueryBuilder<SeeTask, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SeeTask, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<SeeTask, DateTime?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<SeeTask, int, QQueryOperations>
      estimatedTimeInMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedTimeInMinutes');
    });
  }

  QueryBuilder<SeeTask, String, QQueryOperations> evaluationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'evaluation');
    });
  }

  QueryBuilder<SeeTask, int, QQueryOperations> goalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalId');
    });
  }

  QueryBuilder<SeeTask, DateTime, QQueryOperations> insertTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'insertTime');
    });
  }

  QueryBuilder<SeeTask, String, QQueryOperations> parentMessageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentMessageId');
    });
  }

  QueryBuilder<SeeTask, int, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<SeeTask, DateTime?, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<SeeTask, TaskStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<SeeTask, String, QQueryOperations> taskDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskDate');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetSeeActionCollection on Isar {
  IsarCollection<SeeAction> get seeActions => this.collection();
}

const SeeActionSchema = CollectionSchema(
  name: r'SeeAction',
  id: -4254748684991768037,
  properties: {
    r'cost': PropertySchema(
      id: 0,
      name: r'cost',
      type: IsarType.float,
    ),
    r'endTime': PropertySchema(
      id: 1,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'goalId': PropertySchema(
      id: 2,
      name: r'goalId',
      type: IsarType.long,
    ),
    r'input': PropertySchema(
      id: 3,
      name: r'input',
      type: IsarType.string,
    ),
    r'output': PropertySchema(
      id: 4,
      name: r'output',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 5,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'taskId': PropertySchema(
      id: 6,
      name: r'taskId',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 7,
      name: r'type',
      type: IsarType.byte,
      enumMap: _SeeActiontypeEnumValueMap,
    )
  },
  estimateSize: _seeActionEstimateSize,
  serialize: _seeActionSerialize,
  deserialize: _seeActionDeserialize,
  deserializeProp: _seeActionDeserializeProp,
  idName: r'id',
  indexes: {
    r'goalId': IndexSchema(
      id: 2738626632585230611,
      name: r'goalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'goalId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'taskId': IndexSchema(
      id: -6391211041487498726,
      name: r'taskId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'taskId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'startTime': IndexSchema(
      id: -3870335341264752872,
      name: r'startTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'startTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _seeActionGetId,
  getLinks: _seeActionGetLinks,
  attach: _seeActionAttach,
  version: '3.0.5',
);

int _seeActionEstimateSize(
  SeeAction object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.input.length * 3;
  bytesCount += 3 + object.output.length * 3;
  return bytesCount;
}

void _seeActionSerialize(
  SeeAction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeFloat(offsets[0], object.cost);
  writer.writeDateTime(offsets[1], object.endTime);
  writer.writeLong(offsets[2], object.goalId);
  writer.writeString(offsets[3], object.input);
  writer.writeString(offsets[4], object.output);
  writer.writeDateTime(offsets[5], object.startTime);
  writer.writeLong(offsets[6], object.taskId);
  writer.writeByte(offsets[7], object.type.index);
}

SeeAction _seeActionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SeeAction();
  object.cost = reader.readFloat(offsets[0]);
  object.endTime = reader.readDateTimeOrNull(offsets[1]);
  object.goalId = reader.readLong(offsets[2]);
  object.id = id;
  object.input = reader.readString(offsets[3]);
  object.output = reader.readString(offsets[4]);
  object.startTime = reader.readDateTime(offsets[5]);
  object.taskId = reader.readLong(offsets[6]);
  object.type = _SeeActiontypeValueEnumMap[reader.readByteOrNull(offsets[7])] ??
      ActionType.none;
  return object;
}

P _seeActionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readFloat(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (_SeeActiontypeValueEnumMap[reader.readByteOrNull(offset)] ??
          ActionType.none) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SeeActiontypeEnumValueMap = {
  'none': 0,
  'queryRawData': 1,
  'queryStatsData': 2,
  'search': 3,
  'askUserForCreateTask': 4,
  'askUserForEvaluation': 5,
  'askUserForTaskProgress': 6,
  'askUserForTaskReduce': 7,
  'askGptForCreateTask': 8,
  'askGptForNextAction': 9,
  'askGptForTaskProgressEvaluation': 10,
  'askGptForTaskReorder': 11,
  'askGptForTaskReduce': 12,
  'askGptForNewExperience': 13,
  'talkToPerson': 14,
  'getNewPictureFromCamera': 15,
};
const _SeeActiontypeValueEnumMap = {
  0: ActionType.none,
  1: ActionType.queryRawData,
  2: ActionType.queryStatsData,
  3: ActionType.search,
  4: ActionType.askUserCommon,
  5: ActionType.askUserForEvaluation,
  6: ActionType.askUserForTaskProgress,
  7: ActionType.askUserForTaskReduce,
  8: ActionType.askGptForCreateTask,
  9: ActionType.askGptForNextAction,
  10: ActionType.askGptForTaskProgressEvaluation,
  11: ActionType.askGptForTaskReorder,
  12: ActionType.askGptForTaskReduce,
  13: ActionType.askGptForNewExperience,
  14: ActionType.talkToPerson,
  15: ActionType.getNewPictureFromCamera,
};

Id _seeActionGetId(SeeAction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _seeActionGetLinks(SeeAction object) {
  return [];
}

void _seeActionAttach(IsarCollection<dynamic> col, Id id, SeeAction object) {
  object.id = id;
}

extension SeeActionQueryWhereSort
    on QueryBuilder<SeeAction, SeeAction, QWhere> {
  QueryBuilder<SeeAction, SeeAction, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhere> anyGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'goalId'),
      );
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhere> anyTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'taskId'),
      );
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhere> anyStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'startTime'),
      );
    });
  }
}

extension SeeActionQueryWhere
    on QueryBuilder<SeeAction, SeeAction, QWhereClause> {
  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> goalIdEqualTo(
      int goalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'goalId',
        value: [goalId],
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> goalIdNotEqualTo(
      int goalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [],
              upper: [goalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [goalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [goalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [],
              upper: [goalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> goalIdGreaterThan(
    int goalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [goalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> goalIdLessThan(
    int goalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [],
        upper: [goalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> goalIdBetween(
    int lowerGoalId,
    int upperGoalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [lowerGoalId],
        includeLower: includeLower,
        upper: [upperGoalId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> taskIdEqualTo(
      int taskId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'taskId',
        value: [taskId],
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> taskIdNotEqualTo(
      int taskId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> taskIdGreaterThan(
    int taskId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskId',
        lower: [taskId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> taskIdLessThan(
    int taskId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskId',
        lower: [],
        upper: [taskId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> taskIdBetween(
    int lowerTaskId,
    int upperTaskId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskId',
        lower: [lowerTaskId],
        includeLower: includeLower,
        upper: [upperTaskId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> startTimeEqualTo(
      DateTime startTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'startTime',
        value: [startTime],
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> startTimeNotEqualTo(
      DateTime startTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [],
              upper: [startTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [startTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [startTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [],
              upper: [startTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> startTimeGreaterThan(
    DateTime startTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startTime',
        lower: [startTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> startTimeLessThan(
    DateTime startTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startTime',
        lower: [],
        upper: [startTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterWhereClause> startTimeBetween(
    DateTime lowerStartTime,
    DateTime upperStartTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startTime',
        lower: [lowerStartTime],
        includeLower: includeLower,
        upper: [upperStartTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SeeActionQueryFilter
    on QueryBuilder<SeeAction, SeeAction, QFilterCondition> {
  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> costEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> costGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> costLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> costBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> endTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> goalIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> goalIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> goalIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> goalIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> inputEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'input',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> inputGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'input',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> inputLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'input',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> inputBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'input',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> inputStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'input',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> inputEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'input',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> inputContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'input',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> inputMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'input',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> inputIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'input',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> inputIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'input',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> outputEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'output',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> outputGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'output',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> outputLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'output',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> outputBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'output',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> outputStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'output',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> outputEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'output',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> outputContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'output',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> outputMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'output',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> outputIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'output',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> outputIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'output',
        value: '',
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> startTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> taskIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> taskIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> taskIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> taskIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> typeEqualTo(
      ActionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> typeGreaterThan(
    ActionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> typeLessThan(
    ActionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterFilterCondition> typeBetween(
    ActionType lower,
    ActionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SeeActionQueryObject
    on QueryBuilder<SeeAction, SeeAction, QFilterCondition> {}

extension SeeActionQueryLinks
    on QueryBuilder<SeeAction, SeeAction, QFilterCondition> {}

extension SeeActionQuerySortBy on QueryBuilder<SeeAction, SeeAction, QSortBy> {
  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByInput() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'input', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByInputDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'input', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByOutput() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'output', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByOutputDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'output', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension SeeActionQuerySortThenBy
    on QueryBuilder<SeeAction, SeeAction, QSortThenBy> {
  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByInput() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'input', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByInputDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'input', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByOutput() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'output', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByOutputDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'output', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension SeeActionQueryWhereDistinct
    on QueryBuilder<SeeAction, SeeAction, QDistinct> {
  QueryBuilder<SeeAction, SeeAction, QDistinct> distinctByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cost');
    });
  }

  QueryBuilder<SeeAction, SeeAction, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<SeeAction, SeeAction, QDistinct> distinctByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalId');
    });
  }

  QueryBuilder<SeeAction, SeeAction, QDistinct> distinctByInput(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'input', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QDistinct> distinctByOutput(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'output', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeeAction, SeeAction, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<SeeAction, SeeAction, QDistinct> distinctByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskId');
    });
  }

  QueryBuilder<SeeAction, SeeAction, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension SeeActionQueryProperty
    on QueryBuilder<SeeAction, SeeAction, QQueryProperty> {
  QueryBuilder<SeeAction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SeeAction, double, QQueryOperations> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cost');
    });
  }

  QueryBuilder<SeeAction, DateTime?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<SeeAction, int, QQueryOperations> goalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalId');
    });
  }

  QueryBuilder<SeeAction, String, QQueryOperations> inputProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'input');
    });
  }

  QueryBuilder<SeeAction, String, QQueryOperations> outputProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'output');
    });
  }

  QueryBuilder<SeeAction, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<SeeAction, int, QQueryOperations> taskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskId');
    });
  }

  QueryBuilder<SeeAction, ActionType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetMeStateHistoryCollection on Isar {
  IsarCollection<MeStateHistory> get meStateHistorys => this.collection();
}

const MeStateHistorySchema = CollectionSchema(
  name: r'MeStateHistory',
  id: -6140995458771746620,
  properties: {
    r'insertTime': PropertySchema(
      id: 0,
      name: r'insertTime',
      type: IsarType.dateTime,
    ),
    r'stateKey': PropertySchema(
      id: 1,
      name: r'stateKey',
      type: IsarType.byte,
      enumMap: _MeStateHistorystateKeyEnumValueMap,
    ),
    r'value': PropertySchema(
      id: 2,
      name: r'value',
      type: IsarType.float,
    )
  },
  estimateSize: _meStateHistoryEstimateSize,
  serialize: _meStateHistorySerialize,
  deserialize: _meStateHistoryDeserialize,
  deserializeProp: _meStateHistoryDeserializeProp,
  idName: r'id',
  indexes: {
    r'insertTime': IndexSchema(
      id: 4224881274084417522,
      name: r'insertTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'insertTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'stateKey': IndexSchema(
      id: 535423888346486579,
      name: r'stateKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'stateKey',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _meStateHistoryGetId,
  getLinks: _meStateHistoryGetLinks,
  attach: _meStateHistoryAttach,
  version: '3.0.5',
);

int _meStateHistoryEstimateSize(
  MeStateHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _meStateHistorySerialize(
  MeStateHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.insertTime);
  writer.writeByte(offsets[1], object.stateKey.index);
  writer.writeFloat(offsets[2], object.value);
}

MeStateHistory _meStateHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MeStateHistory();
  object.id = id;
  object.insertTime = reader.readDateTime(offsets[0]);
  object.stateKey =
      _MeStateHistorystateKeyValueEnumMap[reader.readByteOrNull(offsets[1])] ??
          StateKey.none;
  object.value = reader.readFloat(offsets[2]);
  return object;
}

P _meStateHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (_MeStateHistorystateKeyValueEnumMap[
              reader.readByteOrNull(offset)] ??
          StateKey.none) as P;
    case 2:
      return (reader.readFloat(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MeStateHistorystateKeyEnumValueMap = {
  'none': 0,
  'appear': 1,
  'upright': 2,
  'smile': 3,
};
const _MeStateHistorystateKeyValueEnumMap = {
  0: StateKey.none,
  1: StateKey.appear,
  2: StateKey.upright,
  3: StateKey.smile,
};

Id _meStateHistoryGetId(MeStateHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _meStateHistoryGetLinks(MeStateHistory object) {
  return [];
}

void _meStateHistoryAttach(
    IsarCollection<dynamic> col, Id id, MeStateHistory object) {
  object.id = id;
}

extension MeStateHistoryQueryWhereSort
    on QueryBuilder<MeStateHistory, MeStateHistory, QWhere> {
  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhere> anyInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'insertTime'),
      );
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhere> anyStateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'stateKey'),
      );
    });
  }
}

extension MeStateHistoryQueryWhere
    on QueryBuilder<MeStateHistory, MeStateHistory, QWhereClause> {
  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause>
      insertTimeEqualTo(DateTime insertTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'insertTime',
        value: [insertTime],
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause>
      insertTimeNotEqualTo(DateTime insertTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [],
              upper: [insertTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [insertTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [insertTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insertTime',
              lower: [],
              upper: [insertTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause>
      insertTimeGreaterThan(
    DateTime insertTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [insertTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause>
      insertTimeLessThan(
    DateTime insertTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [],
        upper: [insertTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause>
      insertTimeBetween(
    DateTime lowerInsertTime,
    DateTime upperInsertTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'insertTime',
        lower: [lowerInsertTime],
        includeLower: includeLower,
        upper: [upperInsertTime],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause>
      stateKeyEqualTo(StateKey stateKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'stateKey',
        value: [stateKey],
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause>
      stateKeyNotEqualTo(StateKey stateKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateKey',
              lower: [],
              upper: [stateKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateKey',
              lower: [stateKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateKey',
              lower: [stateKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateKey',
              lower: [],
              upper: [stateKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause>
      stateKeyGreaterThan(
    StateKey stateKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'stateKey',
        lower: [stateKey],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause>
      stateKeyLessThan(
    StateKey stateKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'stateKey',
        lower: [],
        upper: [stateKey],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterWhereClause>
      stateKeyBetween(
    StateKey lowerStateKey,
    StateKey upperStateKey, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'stateKey',
        lower: [lowerStateKey],
        includeLower: includeLower,
        upper: [upperStateKey],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MeStateHistoryQueryFilter
    on QueryBuilder<MeStateHistory, MeStateHistory, QFilterCondition> {
  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      insertTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      insertTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      insertTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'insertTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      insertTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'insertTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      stateKeyEqualTo(StateKey value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateKey',
        value: value,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      stateKeyGreaterThan(
    StateKey value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateKey',
        value: value,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      stateKeyLessThan(
    StateKey value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateKey',
        value: value,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      stateKeyBetween(
    StateKey lower,
    StateKey upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      valueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      valueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      valueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterFilterCondition>
      valueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension MeStateHistoryQueryObject
    on QueryBuilder<MeStateHistory, MeStateHistory, QFilterCondition> {}

extension MeStateHistoryQueryLinks
    on QueryBuilder<MeStateHistory, MeStateHistory, QFilterCondition> {}

extension MeStateHistoryQuerySortBy
    on QueryBuilder<MeStateHistory, MeStateHistory, QSortBy> {
  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy>
      sortByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.asc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy>
      sortByInsertTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.desc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy> sortByStateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateKey', Sort.asc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy>
      sortByStateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateKey', Sort.desc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension MeStateHistoryQuerySortThenBy
    on QueryBuilder<MeStateHistory, MeStateHistory, QSortThenBy> {
  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy>
      thenByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.asc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy>
      thenByInsertTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insertTime', Sort.desc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy> thenByStateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateKey', Sort.asc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy>
      thenByStateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateKey', Sort.desc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension MeStateHistoryQueryWhereDistinct
    on QueryBuilder<MeStateHistory, MeStateHistory, QDistinct> {
  QueryBuilder<MeStateHistory, MeStateHistory, QDistinct>
      distinctByInsertTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'insertTime');
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QDistinct> distinctByStateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateKey');
    });
  }

  QueryBuilder<MeStateHistory, MeStateHistory, QDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }
}

extension MeStateHistoryQueryProperty
    on QueryBuilder<MeStateHistory, MeStateHistory, QQueryProperty> {
  QueryBuilder<MeStateHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MeStateHistory, DateTime, QQueryOperations>
      insertTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'insertTime');
    });
  }

  QueryBuilder<MeStateHistory, StateKey, QQueryOperations> stateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateKey');
    });
  }

  QueryBuilder<MeStateHistory, double, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const StatePatternSchema = Schema(
  name: r'StatePattern',
  id: 1819542108218411779,
  properties: {
    r'positive': PropertySchema(
      id: 0,
      name: r'positive',
      type: IsarType.bool,
    ),
    r'stateKey': PropertySchema(
      id: 1,
      name: r'stateKey',
      type: IsarType.byte,
      enumMap: _StatePatternstateKeyEnumValueMap,
    )
  },
  estimateSize: _statePatternEstimateSize,
  serialize: _statePatternSerialize,
  deserialize: _statePatternDeserialize,
  deserializeProp: _statePatternDeserializeProp,
);

int _statePatternEstimateSize(
  StatePattern object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _statePatternSerialize(
  StatePattern object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.positive);
  writer.writeByte(offsets[1], object.stateKey.index);
}

StatePattern _statePatternDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StatePattern();
  object.positive = reader.readBool(offsets[0]);
  object.stateKey =
      _StatePatternstateKeyValueEnumMap[reader.readByteOrNull(offsets[1])] ??
          StateKey.none;
  return object;
}

P _statePatternDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (_StatePatternstateKeyValueEnumMap[
              reader.readByteOrNull(offset)] ??
          StateKey.none) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _StatePatternstateKeyEnumValueMap = {
  'none': 0,
  'appear': 1,
  'upright': 2,
  'smile': 3,
};
const _StatePatternstateKeyValueEnumMap = {
  0: StateKey.none,
  1: StateKey.appear,
  2: StateKey.upright,
  3: StateKey.smile,
};

extension StatePatternQueryFilter
    on QueryBuilder<StatePattern, StatePattern, QFilterCondition> {
  QueryBuilder<StatePattern, StatePattern, QAfterFilterCondition>
      positiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positive',
        value: value,
      ));
    });
  }

  QueryBuilder<StatePattern, StatePattern, QAfterFilterCondition>
      stateKeyEqualTo(StateKey value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateKey',
        value: value,
      ));
    });
  }

  QueryBuilder<StatePattern, StatePattern, QAfterFilterCondition>
      stateKeyGreaterThan(
    StateKey value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateKey',
        value: value,
      ));
    });
  }

  QueryBuilder<StatePattern, StatePattern, QAfterFilterCondition>
      stateKeyLessThan(
    StateKey value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateKey',
        value: value,
      ));
    });
  }

  QueryBuilder<StatePattern, StatePattern, QAfterFilterCondition>
      stateKeyBetween(
    StateKey lower,
    StateKey upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StatePatternQueryObject
    on QueryBuilder<StatePattern, StatePattern, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const TaskEvaluationSchema = Schema(
  name: r'TaskEvaluation',
  id: -2490526241653144247,
  properties: {},
  estimateSize: _taskEvaluationEstimateSize,
  serialize: _taskEvaluationSerialize,
  deserialize: _taskEvaluationDeserialize,
  deserializeProp: _taskEvaluationDeserializeProp,
);

int _taskEvaluationEstimateSize(
  TaskEvaluation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _taskEvaluationSerialize(
  TaskEvaluation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {}
TaskEvaluation _taskEvaluationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaskEvaluation();
  return object;
}

P _taskEvaluationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TaskEvaluationQueryFilter
    on QueryBuilder<TaskEvaluation, TaskEvaluation, QFilterCondition> {}

extension TaskEvaluationQueryObject
    on QueryBuilder<TaskEvaluation, TaskEvaluation, QFilterCondition> {}
