// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiaryEntryCollection on Isar {
  IsarCollection<DiaryEntry> get diaryEntrys => this.collection();
}

const DiaryEntrySchema = CollectionSchema(
  name: r'DiaryEntry',
  id: -1043886744285152801,
  properties: {
    r'aiFeedback': PropertySchema(
      id: 0,
      name: r'aiFeedback',
      type: IsarType.string,
    ),
    r'aiFeedbackLoaded': PropertySchema(
      id: 1,
      name: r'aiFeedbackLoaded',
      type: IsarType.bool,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'energy': PropertySchema(
      id: 3,
      name: r'energy',
      type: IsarType.long,
    ),
    r'fatigue': PropertySchema(
      id: 4,
      name: r'fatigue',
      type: IsarType.long,
    ),
    r'focus': PropertySchema(
      id: 5,
      name: r'focus',
      type: IsarType.long,
    ),
    r'mood': PropertySchema(
      id: 6,
      name: r'mood',
      type: IsarType.long,
    ),
    r'photoPath': PropertySchema(
      id: 7,
      name: r'photoPath',
      type: IsarType.string,
    ),
    r'sleepiness': PropertySchema(
      id: 8,
      name: r'sleepiness',
      type: IsarType.long,
    ),
    r'text': PropertySchema(
      id: 9,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _diaryEntryEstimateSize,
  serialize: _diaryEntrySerialize,
  deserialize: _diaryEntryDeserialize,
  deserializeProp: _diaryEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _diaryEntryGetId,
  getLinks: _diaryEntryGetLinks,
  attach: _diaryEntryAttach,
  version: '3.1.0+1',
);

int _diaryEntryEstimateSize(
  DiaryEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.aiFeedback;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.photoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _diaryEntrySerialize(
  DiaryEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.aiFeedback);
  writer.writeBool(offsets[1], object.aiFeedbackLoaded);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.energy);
  writer.writeLong(offsets[4], object.fatigue);
  writer.writeLong(offsets[5], object.focus);
  writer.writeLong(offsets[6], object.mood);
  writer.writeString(offsets[7], object.photoPath);
  writer.writeLong(offsets[8], object.sleepiness);
  writer.writeString(offsets[9], object.text);
}

DiaryEntry _diaryEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiaryEntry(
    aiFeedback: reader.readStringOrNull(offsets[0]),
    aiFeedbackLoaded: reader.readBoolOrNull(offsets[1]) ?? false,
    createdAt: reader.readDateTime(offsets[2]),
    energy: reader.readLong(offsets[3]),
    fatigue: reader.readLong(offsets[4]),
    focus: reader.readLong(offsets[5]),
    mood: reader.readLong(offsets[6]),
    photoPath: reader.readStringOrNull(offsets[7]),
    sleepiness: reader.readLong(offsets[8]),
    text: reader.readString(offsets[9]),
  );
  object.id = id;
  return object;
}

P _diaryEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _diaryEntryGetId(DiaryEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _diaryEntryGetLinks(DiaryEntry object) {
  return [];
}

void _diaryEntryAttach(IsarCollection<dynamic> col, Id id, DiaryEntry object) {
  object.id = id;
}

extension DiaryEntryQueryWhereSort
    on QueryBuilder<DiaryEntry, DiaryEntry, QWhere> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DiaryEntryQueryWhere
    on QueryBuilder<DiaryEntry, DiaryEntry, QWhereClause> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterWhereClause> idBetween(
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
}

extension DiaryEntryQueryFilter
    on QueryBuilder<DiaryEntry, DiaryEntry, QFilterCondition> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      aiFeedbackIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'aiFeedback',
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      aiFeedbackIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'aiFeedback',
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> aiFeedbackEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      aiFeedbackGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      aiFeedbackLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> aiFeedbackBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aiFeedback',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      aiFeedbackStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      aiFeedbackEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      aiFeedbackContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aiFeedback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> aiFeedbackMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aiFeedback',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      aiFeedbackIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiFeedback',
        value: '',
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      aiFeedbackIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aiFeedback',
        value: '',
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      aiFeedbackLoadedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiFeedbackLoaded',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> energyEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'energy',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> energyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'energy',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> energyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'energy',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> energyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'energy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fatigueEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fatigue',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      fatigueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fatigue',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fatigueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fatigue',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> fatigueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fatigue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> focusEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'focus',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> focusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'focus',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> focusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'focus',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> focusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'focus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> moodEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mood',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> moodGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mood',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> moodLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mood',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> moodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      photoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'photoPath',
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      photoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'photoPath',
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> photoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      photoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> photoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> photoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      photoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> photoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> photoPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> photoPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      photoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      photoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> sleepinessEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sleepiness',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      sleepinessGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sleepiness',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
      sleepinessLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sleepiness',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> sleepinessBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sleepiness',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> textContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension DiaryEntryQueryObject
    on QueryBuilder<DiaryEntry, DiaryEntry, QFilterCondition> {}

extension DiaryEntryQueryLinks
    on QueryBuilder<DiaryEntry, DiaryEntry, QFilterCondition> {}

extension DiaryEntryQuerySortBy
    on QueryBuilder<DiaryEntry, DiaryEntry, QSortBy> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByAiFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedback', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByAiFeedbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedback', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByAiFeedbackLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedbackLoaded', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy>
      sortByAiFeedbackLoadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedbackLoaded', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByEnergyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFatigue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigue', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFatigueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigue', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByPhotoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByPhotoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortBySleepiness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepiness', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortBySleepinessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepiness', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension DiaryEntryQuerySortThenBy
    on QueryBuilder<DiaryEntry, DiaryEntry, QSortThenBy> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByAiFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedback', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByAiFeedbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedback', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByAiFeedbackLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedbackLoaded', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy>
      thenByAiFeedbackLoadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiFeedbackLoaded', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByEnergyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFatigue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigue', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFatigueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigue', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByPhotoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByPhotoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenBySleepiness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepiness', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenBySleepinessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepiness', Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension DiaryEntryQueryWhereDistinct
    on QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> {
  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByAiFeedback(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiFeedback', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByAiFeedbackLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiFeedbackLoaded');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energy');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByFatigue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fatigue');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focus');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mood');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByPhotoPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctBySleepiness() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepiness');
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }
}

extension DiaryEntryQueryProperty
    on QueryBuilder<DiaryEntry, DiaryEntry, QQueryProperty> {
  QueryBuilder<DiaryEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DiaryEntry, String?, QQueryOperations> aiFeedbackProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiFeedback');
    });
  }

  QueryBuilder<DiaryEntry, bool, QQueryOperations> aiFeedbackLoadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiFeedbackLoaded');
    });
  }

  QueryBuilder<DiaryEntry, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DiaryEntry, int, QQueryOperations> energyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energy');
    });
  }

  QueryBuilder<DiaryEntry, int, QQueryOperations> fatigueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fatigue');
    });
  }

  QueryBuilder<DiaryEntry, int, QQueryOperations> focusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focus');
    });
  }

  QueryBuilder<DiaryEntry, int, QQueryOperations> moodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mood');
    });
  }

  QueryBuilder<DiaryEntry, String?, QQueryOperations> photoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoPath');
    });
  }

  QueryBuilder<DiaryEntry, int, QQueryOperations> sleepinessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepiness');
    });
  }

  QueryBuilder<DiaryEntry, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }
}
